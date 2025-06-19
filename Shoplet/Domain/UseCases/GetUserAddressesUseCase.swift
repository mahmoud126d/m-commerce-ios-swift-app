//
//  GetUserAddressesUseCase.swift
//  Shoplet
//
//  Created by Macos on 19/06/2025.
//

import Foundation

class GetUserAddressesUseCase{
    var repo : AddressesRepository
    
    init(repo: AddressesRepository) {
        self.repo = repo
    }
    func excute(customerId: Int, completion: @escaping (Result<AddressResponse, NetworkError>) -> Void){
        repo.getUserAddresses(customerId: customerId, completion: completion)
    }
}
