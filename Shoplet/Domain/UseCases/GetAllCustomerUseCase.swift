//
//  GetAllCustomerUseCase.swift
//  Shoplet
//
//  Created by Macos on 13/06/2025.
//

import Foundation

protocol GetAllCustomersUseCase {
    func execute(completion: @escaping (Result<CustomerListResponse, NetworkError>) -> Void)
}

class DefaultGetAllCustomersUseCase: GetAllCustomersUseCase {
    private let repository: CustomerRepository

    init(repository: CustomerRepository) {
        self.repository = repository
    }

    func execute(completion: @escaping (Result<CustomerListResponse, NetworkError>) -> Void) {
        repository.getAllCustomers(completion: completion)
    }
}
