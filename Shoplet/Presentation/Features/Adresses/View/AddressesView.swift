//
//  AddressesView.swift
//  Shoplet
//
//  Created by Macos on 18/06/2025.
//

import SwiftUI

struct AddressesView: View {
    @StateObject var addressViewModel: AddressViewModel
    @State private var isActive = false
    var body: some View {
        VStack{
            HStack{
                Spacer()
                Text("Adresses")
                    Spacer()
                NavigationLink(destination: AddAddress(){
                    address in
                    addressViewModel.createAddress(address: address)
                }, isActive: $isActive) {
                    Button(action: {
                        isActive = true
                    }, label: {
                        Image(systemName: "plus")
                    }).padding(.trailing, 24)
                }
               
            }
            List{
                ForEach(addressViewModel.addresses ?? [], id: \.id){
                    item in
                    AddresseItem(address: item).onTapGesture {
                        addressViewModel.updateAddressToDefault(addressId: item.id ?? 0)
                    }
                }.onDelete(perform: deleteAddress)
            }
        }.onAppear{
            addressViewModel.getCustomerAddress()
        }
    }
    
    func deleteAddress(indexSet: IndexSet){
        indexSet.forEach { index in
            if let address = addressViewModel.addresses?[index], let id = address.id {
                addressViewModel.deleteAddress(addressId: id)
            }
        }
    }
}

struct AddresseItem: View{
    var address: AddressDetails
    var body: some View{
        Text("\(address.address1 ?? ""), \(address.city ?? ""), \(address.country ?? "")")
        
    }
}


#Preview {
    AddressesView(addressViewModel: AddressViewModel())
}
