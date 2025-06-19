//
//  AddressViewModel.swift
//  Shoplet
//
//  Created by Macos on 18/06/2025.
//

import Foundation

class AddressViewModel: ObservableObject{
    private let createAddressUseCase: CreateAddressUseCase
    private let getAddressesUseCase: GetUserAddressesUseCase
    private let markAddressDefaultUseCase: MarkDefaultAddressUseCase
    private let deleteAddressUseCase: DeleteAddressUseCase
    private let citiesUseCase: CitiesUseCase
    private let userDefault = UserDefaultManager.shared
    @Published var addresses :[AddressDetails]?
    @Published var cities: [String]?
    
    init(addressRepo: AddressesRepository = AddressesRepositoryImpl()) {
        self.createAddressUseCase = CreateAddressUseCase(repo: addressRepo)
        self.getAddressesUseCase = GetUserAddressesUseCase(repo: addressRepo)
        self.markAddressDefaultUseCase = MarkDefaultAddressUseCase(repo: addressRepo)
        self.deleteAddressUseCase = DeleteAddressUseCase(repo: addressRepo)
        self.citiesUseCase = CitiesUseCase(repo: addressRepo)
    }
    
    func getCustomerAddress(){
        getAddressesUseCase.excute(customerId: self.userDefault.customerId ?? -1) {[weak self] res in
            switch res{
            case .success(let address):
                self?.addresses = address.addresses
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    func createAddress(address: AddressRequest){
        createAddressUseCase.excute(address: address, customerId: self.userDefault.customerId ?? -1) { res in
            switch res{
            case .success(_):
                print("Saved")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    func updateAddressToDefault(addressId: Int){
        markAddressDefaultUseCase.excute(customerId: self.userDefault.customerId ?? -1, addressId: addressId) { res in
            switch res{
            case .success(_):
                print("Updated")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    func deleteAddress(addressId: Int){
        deleteAddressUseCase.excute(customerId: self.userDefault.customerId ?? -1, addressId: addressId) { res in
            switch res{
            case .success(_):
                print("Deleted")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    func getEgyptCities(){
        citiesUseCase.excute { [weak self]res in
            switch res{
            case .success(let cities):
                DispatchQueue.main.async {
                    self?.cities = cities.data
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
