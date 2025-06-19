//
//  CreateAddressUseCase.swift
//  Shoplet
//
//  Created by Macos on 19/06/2025.
//

import Foundation

class CreateAddressUseCase{
    var repo : AddressesRepository
    
    init(repo: AddressesRepository) {
        self.repo = repo
    }
    func excute(address: AddressRequest, customerId: Int, completion: @escaping (Result<AddressRequest, NetworkError>) -> Void){
        repo.createAddress(address: address, customerId: customerId, completion: completion)
    }
}
