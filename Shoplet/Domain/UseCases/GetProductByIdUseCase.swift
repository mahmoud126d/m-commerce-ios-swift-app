//
//  GetProductByIdUseCase.swift
//  Shoplet
//
//  Created by Macos on 04/06/2025.
//

import Foundation

final class GetProductByIdUseCase {
    private let repository: ProductRepository

    init(repository: ProductRepository) {
        self.repository = repository
    }

    func execute(id: String, completion: @escaping (Result<ProductModel, Error>) -> Void) {
        repository.getProductById(id, completion: completion)
    }
}
