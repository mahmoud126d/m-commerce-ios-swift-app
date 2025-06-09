//
//  GetAllProductsUseCase.swift
//  Shoplet
//
//  Created by Macos on 04/06/2025.
//

import Foundation

final class GetAllProductsUseCase {
    private let repository: ProductRepository

    init(repository: ProductRepository) {
        self.repository = repository
    }

    func execute(completion: @escaping (Result<[ProductModel], Error>) -> Void) {
        repository.getAllProducts(completion: completion)
    }
}

