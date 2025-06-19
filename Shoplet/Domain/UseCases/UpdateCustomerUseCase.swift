//
//  UpdateCustomerUseCase.swift
//  Shoplet
//
//  Created by Macos on 18/06/2025.
//

import Foundation

class UpdateCustomerUseCase{
        private let repository: CustomerRepository
        
        init(repository: CustomerRepository) {
            self.repository = repository
        }
        
    func execute(customerId: Int, customer: CustomerRequest, completion: @escaping (Result<CustomerAuthResponse, NetworkError>) -> Void) {
        repository.updateCustomer(customerId: customerId, customer: customer, completion: completion)
    }
        
}
