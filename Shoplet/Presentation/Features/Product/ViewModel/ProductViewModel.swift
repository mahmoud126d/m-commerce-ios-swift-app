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

    @Published var allProducts: [ProductModel] = []
    @Published var selectedProduct: ProductModel?
    @Published var errorMessage: String?

    init(repository: ProductRepository = ProductRepositoryImpl()) {
        self.getProductByIdUseCase = GetProductByIdUseCase(repository: repository)
        self.getAllProductsUseCase = GetAllProductsUseCase(repository: repository)
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
}
