//
//  CustomerRepositoryImpl.swift
//  Shoplet
//
//  Created by Macos on 11/06/2025.
//

import Foundation

class CustomerRepositoryImpl: CustomerRepository {
    func createCustomer(customer: CustomerRequest, completion: @escaping (Result<CustomerAuthResponse, NetworkError>) -> Void) {
        APIClient.createCustomer(customer: customer, completion: completion)
    }
    func getCustomerById(id: Int, completion: @escaping (Result<CustomerAuthResponse, NetworkError>) -> Void) {
        APIClient.getCustomerById(id: id, completion: completion)
    }
    func getAllCustomers(completion: @escaping (Result<CustomerListResponse, NetworkError>) -> Void) {
        APIClient.getAllCustomers(completion: completion)
    }

    func updateCustomer(customerId: Int, customer: CustomerRequest, completion: @escaping (Result<CustomerAuthResponse, NetworkError>)->Void){
        APIClient.updateCustomer(customerId: customerId, customer: customer, completion: completion)
    }
}
