//
//  CustomerRepositoryImpl.swift
//  Shoplet
//
//  Created by Macos on 11/06/2025.
//

import Foundation

class CustomerRepositoryImpl: CustomerRepository {
    func createCustomer(customer: CustomerRequest, completion: @escaping (Result<Customer, NetworkError>) -> Void) {
        APIClient.createCustomer(customer: customer, completion: completion)
    }
}
