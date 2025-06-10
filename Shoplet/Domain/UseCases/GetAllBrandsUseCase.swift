//
//  GetAllBrandsUseCase.swift
//  Shoplet
//
//  Created by Farid on 10/06/2025.
//

import Foundation
final class GetAllBrandsUseCase {
    private let repository: ProductRepository
    
    init(repository: ProductRepository) {
        self.repository = repository
    }

    func execute(completion: @escaping (Result<[SmartCollection], Error>) -> Void) {
        repository.getAllBrands(completion: completion)
    }
}
