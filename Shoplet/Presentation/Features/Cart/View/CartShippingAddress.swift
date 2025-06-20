//
//  CartShippingAddress.swift
//  Shoplet
//
//  Created by Macos on 20/06/2025.
//

import SwiftUI

struct CartShippingAddress: View {
    @Binding var address: AddressDetails?
    @State private var moveUp: Bool = false
    @State var navActive = false
    @State var onSelectAddress:(_ address: AddressDetails)->Void
    var body: some View {
        VStack{
            HStack{
                
                Image(.location)
                    .resizable()
                    .frame(width: 30, height: 30)
                //                            .offset(y: moveUp ? -2 : 0)
                //                            .animation(Animation.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: moveUp)
                //                            .onAppear {
                //                                    moveUp.toggle()
                //                                }
                //                            .frame(height: 20)
                
                VStack(alignment: .leading){
                    Text("Deliver to")
                    Text("\(address?.address1 ?? "no"), \(address?.city ?? "no")")
                        .font(.headline)
                        .bold()
                    
                }.padding(.leading, 4)
            }
            .padding(.bottom, 8)
            .frame(maxWidth: .infinity, maxHeight: 80)
            // .padding(.horizontal, 16)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
            .clipped()
            
            NavigationLink(destination:AddressesView(isCheckout: true){ address in
                onSelectAddress(address)
            }, isActive: $navActive) {
                Button {
                    navActive = true
                } label: {
                    Text("chooose anothor Address ")
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Color.primaryColor)
                .cornerRadius(12)
            }
        }
    }
}

/*#Preview {
    CartShippingAddress()
}*/
