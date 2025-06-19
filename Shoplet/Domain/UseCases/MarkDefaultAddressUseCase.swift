//
//  MarkDefaultAddressUseCase.swift
//  Shoplet
//
//  Created by Macos on 19/06/2025.
//

import Foundation

class MarkDefaultAddressUseCase{
    var repo : AddressesRepository
    
    init(repo: AddressesRepository) {
        self.repo = repo
    }
    func excute(customerId: Int, addressId:Int, completion: @escaping (Result<AddressRequest, NetworkError>) -> Void){
        repo.markAddresseDefault(customerId: customerId, addressId: addressId, completion: completion)
    }
}
