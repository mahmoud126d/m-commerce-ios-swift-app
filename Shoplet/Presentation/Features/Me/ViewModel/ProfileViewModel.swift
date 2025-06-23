//
//  ProfileViewModel.swift
//  Shoplet
//
//  Created by Macos on 15/06/2025.
//

import Foundation

class ProfileViewModel: ObservableObject{
    private let getCustomerUseCase: GetCustomerByIdUseCase
    private var userDefault = UserDefaultManager.shared
     @Published var customer: Customer?
    init(customerRepo: CustomerRepository = CustomerRepositoryImpl()) {
        self.getCustomerUseCase = DefaultGetCustomerByIdUseCase(repository: customerRepo)
    }
    
    func getCustomer(){
        if userDefault.isUserLoggedIn{
            getCustomerUseCase.execute(id: userDefault.customerId ?? 0) {[weak self] res in
                switch res{
                case .success(let customerRes):
                    DispatchQueue.main.async{
                        self?.customer = customerRes.customer
                        print(customerRes.customer?.first_name ?? "Unknown")
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}
