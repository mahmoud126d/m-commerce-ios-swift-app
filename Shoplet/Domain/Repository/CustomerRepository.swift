//
//  CustomerRepository.swift
//  Shoplet
//
//  Created by Macos on 11/06/2025.
//

import Foundation

protocol CustomerRepository {
    func createCustomer(customer: CustomerRequest, completion: @escaping (Result<Customer, NetworkError>) -> Void)
}
