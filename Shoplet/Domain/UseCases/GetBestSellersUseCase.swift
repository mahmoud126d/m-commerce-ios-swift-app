//
//  GetBestSellersUseCase.swift
//  Shoplet
//
//  Created by Farid on 10/06/2025.
//

import Foundation
final class GetBestSellersUseCase {
    private let repository: HomeRepository
    
    init(repository: HomeRepository) {
        self.repository = repository
    }

    func execute(completion: @escaping (Result<[PopularProductItem], Error>) -> Void) {
        repository.getBestSellers(completion: completion)
    }
}
