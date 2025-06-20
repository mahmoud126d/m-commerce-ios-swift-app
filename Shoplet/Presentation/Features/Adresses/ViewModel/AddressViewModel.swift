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
    private let draftOrderUseCase: DraftOrderUseCase
    private let citiesUseCase: CitiesUseCase
    private let userDefault = UserDefaultManager.shared
    private var draftOrder: DraftOrder?
    @Published var addresses :[AddressDetails]?
    @Published var cities: [String]?
    @Published var isLoading: Bool?
    
    init(addressRepo: AddressesRepository = AddressesRepositoryImpl(), productRepo: ProductRepository = ProductRepositoryImpl()) {
        self.createAddressUseCase = CreateAddressUseCase(repo: addressRepo)
        self.getAddressesUseCase = GetUserAddressesUseCase(repo: addressRepo)
        self.markAddressDefaultUseCase = MarkDefaultAddressUseCase(repo: addressRepo)
        self.deleteAddressUseCase = DeleteAddressUseCase(repo: addressRepo)
        self.citiesUseCase = CitiesUseCase(repo: addressRepo)
        self.draftOrderUseCase = DraftOrderUseCase(repo: productRepo)
    }
    
    func getCustomerAddress(){
        isLoading = true
        getAddressesUseCase.excute(customerId: self.userDefault.customerId ?? -1) {[weak self] res in
            switch res{
            case .success(let address):
                DispatchQueue.main.async{
                    self?.isLoading = false
                    self?.addresses = address.addresses
                }
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
                self.getCustomerAddress()
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
                self.getCustomerAddress()
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
    func getDraftOrderById(){
        if userDefault.hasDraftOrder == true{
            draftOrderUseCase.getById(dtaftOrderId: userDefault.draftOrderId) { [weak self] res in
                DispatchQueue.main.async {
                    switch res{
                    case .success(let draftOrder):
                        self?.draftOrder = draftOrder
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }else{
            self.draftOrder = nil
        }
    }
    
    func updateShipingAddress(address: AddressDetails){
        draftOrder?.shipping_address = address
        let draftOrderItem = DraftOrderItem(draft_order: draftOrder)
        draftOrderUseCase.update(draftOrder: draftOrderItem, dtaftOrderId: userDefault.draftOrderId) {[weak self]res in
            DispatchQueue.main.async {
                switch res {
                case .success(let draftOrder):
                    print("updated \(String(describing: draftOrder.id))")
                    self?.userDefault.isNotDefaultAddress = true
                case .failure(let error):
                    print(error)
                }
            }
        }
        
    }
}
