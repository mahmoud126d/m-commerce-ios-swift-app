//
//  HomeViewModel.swift
//  Shoplet
//
//  Created by Farid on 09/06/2025.
//

import Foundation
final class HomeViewModel: ObservableObject {
    // Use Cases
    private let getAllBrandsUseCase: GetAllBrandsUseCase
    private let getBestSellersUseCase: GetBestSellersUseCase

    // Published properties for UI binding
    @Published var brands: [SmartCollection] = []
    @Published var bestSellers: [PopularProductItem] = []
    @Published var errorMessage: String?

    init(repository: HomeRepository = HomeRepositoryImpl()) {
        self.getAllBrandsUseCase = GetAllBrandsUseCase(repository: repository)
        self.getBestSellersUseCase = GetBestSellersUseCase(repository: repository)
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
}
