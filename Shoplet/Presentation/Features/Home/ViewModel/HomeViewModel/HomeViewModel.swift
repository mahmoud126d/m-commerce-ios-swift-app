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
    // Published properties for UI binding
    @Published var brands: [SmartCollection] = []
    @Published var bestSellers: [ProductModel] = []
    @Published var errorMessage: String?
    @Published var cartCount : Int = UserDefaultManager.shared.getNumOfCartItems()

    init(repository: ProductRepository = ProductRepositoryImpl()) {
        self.getAllBrandsUseCase = GetAllBrandsUseCase(repository: repository)
        self.getBestSellersUseCase = GetBestSellersUseCase(repository: repository)
        self.draftOrderUseCase = DraftOrderUseCase(repo: repository)
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
