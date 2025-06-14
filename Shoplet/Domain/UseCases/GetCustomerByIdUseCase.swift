//
//  GetCustomerByIdUseCase.swift
//  Shoplet
//
//  Created by Macos on 13/06/2025.
//

import Foundation

protocol GetCustomerByIdUseCase {
    func execute(id: Int, completion: @escaping (Result<CustomerAuthResponse, NetworkError>) -> Void)
}

class DefaultGetCustomerByIdUseCase: GetCustomerByIdUseCase {
    private let repository: CustomerRepository
    
    init(repository: CustomerRepository) {
        self.repository = repository
    }
    
    func execute(id: Int, completion: @escaping (Result<CustomerAuthResponse, NetworkError>) -> Void) {
        repository.getCustomerById(id: id, completion: completion)
    }
}
