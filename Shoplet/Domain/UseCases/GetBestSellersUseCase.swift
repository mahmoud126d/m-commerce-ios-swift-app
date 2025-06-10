//
//  GetBestSellersUseCase.swift
//  Shoplet
//
//  Created by Farid on 10/06/2025.
//

import Foundation
final class GetBestSellersUseCase {
    private let repository: ProductRepository
    
    init(repository: ProductRepository) {
        self.repository = repository
    }

    func execute(completion: @escaping (Result<[ProductModel], Error>) -> Void) {
        repository.getBestSellers(completion: completion)
    }
}
