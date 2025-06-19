//
//  AddressesRepositoryImpl.swift
//  Shoplet
//
//  Created by Macos on 19/06/2025.
//

import Foundation

class AddressesRepositoryImpl: AddressesRepository{
    func createAddress(address: AddressRequest, customerId: Int, completion: @escaping (Result<AddressRequest, NetworkError>) -> Void) {
        APIClient.createAddress(address: address, customerId: customerId, completion: completion)
    }
    
    func getUserAddresses(customerId: Int, completion: @escaping (Result<AddressResponse, NetworkError>) -> Void) {
        APIClient.getUserAddresses(customerId: customerId, completion: completion)
    }
    func markAddresseDefault(customerId: Int, addressId:Int, completion: @escaping (Result<AddressRequest, NetworkError>) -> Void){
        APIClient.markAddresseDefault(customerId: customerId, addressId: addressId, completion: completion)
    }
    func deleteAddresse(customerId: Int, addressId:Int, completion: @escaping (Result<EmptyResponse, NetworkError>) -> Void){
        APIClient.deleteAddresse(customerId: customerId, addressId: addressId, completion: completion)
    }
    func getEgyptCities(completion: @escaping(Result<Cities, NetworkError>)->Void){
        APIClient.getEgyptCities(completion: completion)
    }
    
}
