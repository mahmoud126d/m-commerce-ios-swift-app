//
//  ProductViewModel.swift
//  Shoplet
//
//  Created by Macos on 04/06/2025.
//

import Foundation
import Combine

class ProductViewModel: ObservableObject {
    private let getProductByIdUseCase: GetProductByIdUseCase
    private let getAllProductsUseCase: GetAllProductsUseCase
    private let draftOrderUseCase : DraftOrderUseCase
    private let userDefault = UserDefaultManager.shared
    private var draftOrder : DraftOrder?
    private var draftOrderLineItem : [LineItem]?
    @Published var allProducts: [ProductModel] = []
    @Published var selectedProduct: ProductModel?
    @Published var errorMessage: String?
    @Published var selectedColor : String = "Black"
    @Published var selectedQuantity : Int = 1
    @Published var selectedSize : Int = 32
    @Published var price : String = ""

    init(repository: ProductRepository = ProductRepositoryImpl()) {
        self.getProductByIdUseCase = GetProductByIdUseCase(repository: repository)
        self.getAllProductsUseCase = GetAllProductsUseCase(repository: repository)
        self.draftOrderUseCase = DraftOrderUseCase(repo: repository)
    }

    func fetchAllProducts() {
        getAllProductsUseCase.execute { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let products):
                    self?.allProducts = products
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func fetchProductById(_ id: String) {
        getProductByIdUseCase.execute(id: id) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let product):
                    self?.selectedProduct = product
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func addToCart(product : ProductModel){
        //userDefault.hasDraftOrder = false
        let userDraftOrder = DraftOrderItem(
            draft_order: DraftOrder(
                customer: Customer(id: 7971971891418),
                line_items: [
                    LineItem(price: product.variants?.first?.price,
                             product_id: product.id,
                             quantity: selectedQuantity,
                             title: product.title,
                             variant_id: product.variants?.first?.id,
                             variant_title: product.variants?.first?.title,
                             vendor: product.vendor,
                             properties: [
                                Property(name: "Color", value: selectedColor),
                                Property(name: "Image", value: product.image?.src),
                                Property(name: "Size", value: "\(selectedSize)")
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
                    item.quantity = (item.quantity ?? 1) + self.selectedQuantity
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
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
            }

            
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
