//
//  BrandProductsViewModel.swift
//  Shoplet
//
//  Created by Farid on 10/06/2025.
//

import Foundation
import Combine

class BrandProductsViewModel: ObservableObject {
    private var draftOrderUseCase : DraftOrderUseCase
    private let userDefault = UserDefaultManager.shared
    private var draftOrderLineItem : [LineItem]?
    private var draftOrder : DraftOrder?


    @Published var products: [ProductModel] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    private let baseURL = "https://ios1-ism.myshopify.com/admin/api/2024-07"
    private let token = "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"
    
    init(repo : ProductRepository = ProductRepositoryImpl()){
        self.draftOrderUseCase = DraftOrderUseCase(repo: repo)
    }
    
    func fetchProducts(for brand: String) {
        guard let url = URL(string: "\(baseURL)/products.json") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(token, forHTTPHeaderField: "X-Shopify-Access-Token")
        
        URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: ProductResponse.self, decoder: JSONDecoder())
            .map { $0.products.filter { $0.vendor == brand } }
            .receive(on: DispatchQueue.main)
            .replaceError(with: [])
            .assign(to: \.products, on: self)
            .store(in: &cancellables)
    }
    
    func addToCart(product : ProductModel){
        if userDefault.isUserLoggedIn{
            let userDraftOrder = DraftOrderItem(
                draft_order: DraftOrder(
                    customer: DraftOrderCustomer(id: userDefault.customerId),
                    line_items: [
                        LineItem(price: product.variants?.first?.price,
                                 product_id: product.id,
                                 quantity: 1,
                                 title: product.title,
                                 variant_id: product.variants?.first?.id,
                                 variant_title: product.variants?.first?.title,
                                 vendor: product.vendor,
                                 properties: [
                                    Property(name: "Color", value: product.options?[1].values.first ?? "black"),
                                    Property(name: "Image", value: product.image?.src),
                                    Property(name: "Size", value: product.options?[0].values.first ?? "35")
                                 ])
                    ]
                    
                ))
            if userDefault.hasDraftOrder == false {
                
                draftOrderUseCase.create(draftOrder: userDraftOrder) {[weak self] res in
                    DispatchQueue.main.async {
                        switch res{
                        case .success(let res):
                            print("Added \(String(describing: res.id))")
                            self?.userDefault.hasDraftOrder = true
                            self?.userDefault.draftOrderId = res.id ?? 0
                            self?.userDefault.cartItems = res.line_items?.count ?? 0
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
            }else{
                getDraftOrderById {
                    guard let updatedItem = userDraftOrder.draft_order?.line_items?.first else {
                        return
                    }
                    var items = self.draftOrderLineItem ?? []
                    if let index = items.firstIndex(where: { item in
                        guard item.product_id == updatedItem.product_id else { return false }
                        
                        let existingColor = item.properties?.first(where: { $0.name == "Color" })?.value
                        let existingSize = item.properties?.first(where: { $0.name == "Size" })?.value
                        
                        let newColor = updatedItem.properties?.first(where: { $0.name == "Color" })?.value
                        let newSize = updatedItem.properties?.first(where: { $0.name == "Size" })?.value
                        
                        return existingColor == newColor && existingSize == newSize
                    }){
                        var item = items[index]
                        item.quantity = (item.quantity ?? 1) + 1
                        item.price = String(format: "%.2f", Methods.getPrice(product: product, quantity: item.quantity ?? 1))
                        items[index] = item
                    } else {
                        items.append(updatedItem)
                        print("not exist")
                    }
                    
                    self.draftOrderLineItem = items
                    var updatedDraftOrder = userDraftOrder
                    updatedDraftOrder.draft_order?.line_items = items
                    
                    self.draftOrderUseCase.update(draftOrder: updatedDraftOrder, dtaftOrderId: self.userDefault.draftOrderId) { res in
                        DispatchQueue.main.async {
                            switch res {
                            case .success(let draftOrder):
                                print("updated \(String(describing: draftOrder.id))")
                                self.userDefault.cartItems = draftOrder.line_items?.count ?? 0
                                
                            case .failure(let error):
                                print(error)
                            }
                        }
                    }
                }
                
                
            }
        }else{
            print("guest")
        }
    }
    func getDraftOrderById(completion: @escaping () -> Void){
        draftOrderUseCase.getById(dtaftOrderId: userDefault.draftOrderId) { [weak self]res in
            DispatchQueue.main.async {
                switch res{
                case .success(let draftOrder):
                    self?.draftOrder = draftOrder
                    self?.draftOrderLineItem = draftOrder.line_items
                    completion()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}

