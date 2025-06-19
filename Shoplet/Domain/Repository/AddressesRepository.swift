//
//  AddressesRepository.swift
//  Shoplet
//
//  Created by Macos on 19/06/2025.
//

import Foundation

protocol AddressesRepository{
    func createAddress(address: AddressRequest,customerId: Int, completion: @escaping (Result<AddressRequest, NetworkError>) -> Void)
    func getUserAddresses(customerId: Int, completion: @escaping (Result<AddressResponse, NetworkError>) -> Void)
    func markAddresseDefault(customerId: Int, addressId:Int, completion: @escaping (Result<AddressRequest, NetworkError>) -> Void)
    func deleteAddresse(customerId: Int, addressId:Int, completion: @escaping (Result<EmptyResponse, NetworkError>) -> Void)
    func getEgyptCities(completion: @escaping(Result<Cities, NetworkError>)->Void)

}
