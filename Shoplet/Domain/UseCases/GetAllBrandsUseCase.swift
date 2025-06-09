//
//  GetAllBrandsUseCase.swift
//  Shoplet
//
//  Created by Farid on 09/06/2025.
//

import Foundation
final class GetAllBrandsUseCase {
    private let repository: HomeRepository
    
    init(repository: HomeRepository) {
        self.repository = repository
    }

    func execute(completion: @escaping (Result<[SmartCollection], Error>) -> Void) {
        repository.getAllBrands(completion: completion)
    }
}
