//
//  AddressesView.swift
//  Shoplet
//
//  Created by Macos on 18/06/2025.
//

import SwiftUI

struct AddressesView: View {
    @StateObject var addressViewModel: AddressViewModel = AddressViewModel()
    @State private var isActive = false
    @State var isCheckout: Bool
    @State var selectedAddressId: Int?
    @State var selectedAddress: AddressDetails?
    var onSelect: ((AddressDetails) -> Void)? = nil
    @Environment(\.dismiss) var back
    var body: some View {
        ZStack{
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
                ScrollView(showsIndicators: false){
                    VStack(alignment: .leading){
                        ForEach(addressViewModel.addresses ?? [], id: \.id){
                            item in
                            AddresseItem(address: item, deleteAddress: { id in
                                addressViewModel.deleteAddress(addressId: id)
                            }, setDefault:  { _ in
                                addressViewModel.updateAddressToDefault(addressId: item.id ?? 0)
                            },isSelected:
                                selectedAddressId == item.id && isCheckout
                            
                            ).onTapGesture {
                                if isCheckout{
                                    self.selectedAddressId = item.id
                                    self.selectedAddress = item
                                }
                            }
                        }
                        if isCheckout{
                            PrimaryButton(title: "Confirm") {
                                guard let address = selectedAddress else {return}
                               // addressViewModel.updateShipingAddress(address: address)
                                onSelect?(address)
                                back()
                            }

                        }
                    }.padding(.bottom, 100)
                }
            }.onAppear{
                addressViewModel.getCustomerAddress()
                if isCheckout{
                    addressViewModel.getDraftOrderById()
                }
            }
            if addressViewModel.isLoading ?? true {
                    ProgressView()
            }
        }
    }
    
}

struct AddresseItem: View {
    var address: AddressDetails
    var deleteAddress: (_ id: Int)-> Void
    var setDefault: (_ id: Int)-> Void
    var isSelected: Bool
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack{
                if address.default ?? false{
                    Text("default")
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.primaryColor)
                        .cornerRadius(12)
                        .foregroundColor(.white)
                }
                else{
                    Button {
                        if (address.default ?? false) == false{
                            setDefault(address.id ?? -1)
                        }
                    } label: {
                            Text("set default").foregroundColor(.black)
                        
                    } .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.primaryColor, lineWidth: 1)
                    )
                }
                if address.default == false{
                    Spacer()
                    Button {
                        deleteAddress(address.id ?? -1)
                    } label: {
                        Image(systemName: "trash")
                            .foregroundColor(.black)
                        
                    }

                }
            }.padding(.vertical)
            AddressRow(title: "Address: ", value: address.address1 ?? "")
            AddressRow(title: "City:", value: address.city ?? "")
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? Color.primaryColor : Color.clear, lineWidth: 2)
        }
        .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 4)
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        
    }
}

struct AddressRow: View{
    var title: String
    var value: String
    var body: some View{
        HStack{
            Text(title)
                .foregroundColor(.gray)
                .fontWeight(.semibold)
                .padding(.trailing, 16)
                .padding(.bottom, 8)
                .frame(width: 100, alignment: .leading)
            Text(value)
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
                .frame(maxWidth: .infinity, alignment: .leading)

        }
        
    }
}

/*#Preview {
    AddressesView(addressViewModel: AddressViewModel(), isCheckout: false)
}*/
