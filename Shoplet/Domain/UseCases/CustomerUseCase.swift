//
//  CustomerUseCase.swift
//  Shoplet
//
//  Created by Macos on 11/06/2025.
//

import Foundation

protocol CreateCustomerUseCase {
    func execute(customer: CustomerRequest, completion: @escaping (Result<Customer, NetworkError>) -> Void)
}

class DefaultCreateCustomerUseCase: CreateCustomerUseCase {
    private let repository: CustomerRepository
    
    init(repository: CustomerRepository) {
        self.repository = repository
    }
    
    func execute(customer: CustomerRequest, completion: @escaping (Result<Customer, NetworkError>) -> Void) {
        repository.createCustomer(customer: customer, completion: completion)
    }
}

