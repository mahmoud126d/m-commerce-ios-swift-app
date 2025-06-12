//
//  CustomerViewModel.swift
//  Shoplet
//
//  Created by Macos on 11/06/2025.
//

import Foundation
import Combine

class CustomerViewModel: ObservableObject {
    private let createCustomerUseCase: CreateCustomerUseCase
    
    @Published var customer: Customer?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    init(createCustomerUseCase: CreateCustomerUseCase) {
        self.createCustomerUseCase = createCustomerUseCase
    }
    
    func createCustomer(_ request: CustomerRequest) {
        isLoading = true
        errorMessage = nil
        
        createCustomerUseCase.execute(customer: request) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let customer):
                    self?.customer = customer
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    print("ViewModel Error: \(error.localizedDescription)") 
                }
            }
        }
    }
}
