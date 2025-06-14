//
//  CustomerRepository.swift
//  Shoplet
//
//  Created by Macos on 11/06/2025.
//

import Foundation

protocol CustomerRepository {
    func createCustomer(customer: CustomerRequest, completion: @escaping (Result<CustomerAuthResponse, NetworkError>) -> Void)
    func getCustomerById(id: Int, completion: @escaping (Result<CustomerAuthResponse, NetworkError>) -> Void)
    func getAllCustomers(completion: @escaping (Result<CustomerListResponse, NetworkError>) -> Void)

}
