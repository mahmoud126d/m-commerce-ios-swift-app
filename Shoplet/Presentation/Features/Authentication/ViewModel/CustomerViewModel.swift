//
//  CustomerViewModel.swift
//  Shoplet
//
//  Created by Macos on 11/06/2025.
//

import Foundation
import Combine
import FirebaseAuth

class CustomerViewModel: ObservableObject {
    private let createCustomerUseCase: CreateCustomerUseCase
    private let getAllCustomersUseCase: GetAllCustomersUseCase

    @Published var customer: CustomerAuthResponse?
    @Published var isLoading = false
    @Published var errorMessage: String?

    init(createCustomerUseCase: CreateCustomerUseCase,
            getAllCustomersUseCase: GetAllCustomersUseCase) {
           self.createCustomerUseCase = createCustomerUseCase
           self.getAllCustomersUseCase = getAllCustomersUseCase
       }
    
    func registerUserWithFirebaseAndShopify(email: String, password: String, customerRequest: CustomerRequest) {
        isLoading = true
        errorMessage = nil

        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.isLoading = false
                    self?.errorMessage = "Firebase Error: \(error.localizedDescription)"
                }
                return
            }

            authResult?.user.sendEmailVerification(completion: { error in
                if let error = error {
                    print("Verification email failed: \(error.localizedDescription)")
                } else {
                    print("Verification email sent.")
                }
            })

            self?.createCustomer(customerRequest)
        }
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
                    
                    UserDefaultManager.shared.isUserLoggedIn = true
                    UserDefaultManager.shared.customerId = customer.customer?.id
                    
                    let name = customer.customer?.first_name ?? "user"
                        print("Hello, \(name)")
                    
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    print("ViewModel Error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func signInWithFirebaseAndShopify(email: String, password: String, completion: @escaping (Bool) -> Void) {
        isLoading = true
        errorMessage = nil

        getAllCustomersUseCase.execute { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let customerList):
                    if let matchedCustomer = customerList.customers.first(where: { $0.email?.lowercased() == email.lowercased() }) {
                        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                            DispatchQueue.main.async {
                                self?.isLoading = false
                                if let error = error {
                                    self?.errorMessage = "Firebase Sign In Error: \(error.localizedDescription)"
                                    completion(false)
                                } else {
                                    self?.customer = CustomerAuthResponse(customer: matchedCustomer)
                                    UserDefaultManager.shared.isUserLoggedIn = true
                                    UserDefaultManager.shared.customerId = matchedCustomer.id
                                    let name = matchedCustomer.first_name ?? "user"
                                    print("Hello, \(name)")
                                    completion(true)
                                }
                            }
                        }
                    } else {
                        self?.isLoading = false
                        self?.errorMessage = "No customer with this email was found in Shopify."
                        completion(false)
                    }

                case .failure(let error):
                    self?.isLoading = false
                    self?.errorMessage = "Shopify Error: \(error.localizedDescription)"
                    completion(false)
                }
            }
        }
    }

}
