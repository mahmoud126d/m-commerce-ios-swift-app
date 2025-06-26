//
//  HomeViewModel.swift
//  Shoplet
//
//  Created by Farid on 10/06/2025.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    // Use Cases
    private let getAllBrandsUseCase: GetAllBrandsUseCase
    private let getBestSellersUseCase: GetBestSellersUseCase
    private let draftOrderUseCase : DraftOrderUseCase
    private let userDefault = UserDefaultManager.shared
    private var allDraftOrders: [DraftOrder]?
    private var hasDraft: Bool = false
    // Published properties for UI binding
    @Published var brands: [SmartCollection] = []
    @Published var bestSellers: [ProductModel] = []
    @Published var errorMessage: String?
    @Published var cartCount : Int = UserDefaultManager.shared.getNumOfCartItems()
    @Published var customerName: String = "Guest"

    private let getCustomerByIdUseCase: GetCustomerByIdUseCase

    init(repository: ProductRepository = ProductRepositoryImpl(), cusRepo: CustomerRepository = CustomerRepositoryImpl()) {
        self.getAllBrandsUseCase = GetAllBrandsUseCase(repository: repository)
        self.getBestSellersUseCase = GetBestSellersUseCase(repository: repository)
        self.draftOrderUseCase = DraftOrderUseCase(repo: repository)
        self.getCustomerByIdUseCase = DefaultGetCustomerByIdUseCase(repository: cusRepo)
    }
    
    
    
    func fetchCustomerName() {
        guard let id = userDefault.customerId else { return }
        getCustomerByIdUseCase.execute(id: id) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self?.customerName = response.customer?.first_name ?? "User"
                case .failure(_):
                    self?.customerName = "User"
                }
            }
        }
    }

    func fetchBrands() {
        getAllBrandsUseCase.execute { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let brands):
                    self?.brands = brands
                case .failure(let error):
                    self?.errorMessage = "Brands Error: \(error.localizedDescription)"
                }
            }
        }
    }

    func fetchBestSellers() {
        getBestSellersUseCase.execute { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let products):
                    self?.bestSellers = products
                case .failure(let error):
                    self?.errorMessage = "Best Sellers Error: \(error.localizedDescription)"
                }
            }
        }
    }
    func getUserDraftOrders() {
        guard userDefault.isUserLoggedIn else {
                userDefault.hasDraftOrder = false
                userDefault.draftOrderId = 0
                userDefault.cartItems = 0
                return
            }

            var found = false
            for draftOrder in self.allDraftOrders ?? [] {
                if draftOrder.customer?.id == self.userDefault.customerId {
                    userDefault.hasDraftOrder = true
                    userDefault.draftOrderId = draftOrder.id ?? 0
                    userDefault.cartItems = draftOrder.line_items?.count ?? 0
                    print("hasDraft")
                    found = true
                    break
                }
            }

            if !found {
                userDefault.hasDraftOrder = false
                userDefault.draftOrderId = 0
                userDefault.cartItems = 0
            }

            print("logged")
        print(userDefault.customerId ?? -1)
    }


    
    func getAllDraftOrders(){
        draftOrderUseCase.getDraftOrders { [weak self] res in
            switch res{
            case .success(let draftOrders):
                DispatchQueue.main.async{
                    self?.allDraftOrders = draftOrders
                    self?.getUserDraftOrders()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    func getItemCartCount(){
        if userDefault.hasDraftOrder == true{
            draftOrderUseCase.getById(dtaftOrderId: userDefault.draftOrderId) {res in
                DispatchQueue.main.async {
                    switch res{
                    case .success(let draftOrder):
                        UserDefaultManager.shared.cartItems = draftOrder.line_items?.count ?? 0
                     //   self.cartCount = draftOrder.line_items?.count ?? 0
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
}
