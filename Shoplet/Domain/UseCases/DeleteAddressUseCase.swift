//
//  DeleteAddressUseCase.swift
//  Shoplet
//
//  Created by Macos on 19/06/2025.
//

import Foundation

class DeleteAddressUseCase{
    var repo : AddressesRepository
    
    init(repo: AddressesRepository) {
        self.repo = repo
    }
    func excute(customerId: Int, addressId:Int, completion: @escaping (Result<EmptyResponse, NetworkError>) -> Void){
        repo.deleteAddresse(customerId: customerId, addressId: addressId, completion: completion)
    }
}
