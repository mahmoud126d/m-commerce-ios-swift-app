//
//  MeView.swift
//  Shoplet
//
//  Created by Farid on 10/06/2025.
//

import SwiftUI

struct MeView: View {
    @StateObject var profileViewModel = ProfileViewModel()
    var body: some View {
        NavigationView{
            VStack{
                Text("Profile")
                    .font(.headline)
                    .bold()
                Spacer()
                
                List{
                    UserDetails(profileViewModel: profileViewModel)
                    NavigationLink(destination: AddressesView(isCheckout: false)) {
                        Text("Address")
                    }
                    NavigationLink(destination: CurrencyView()) {
                        Text("Currency")
                    }
                    Text("About")
                    Text("Support")
                }
                Spacer()
                
            }.onAppear{
                profileViewModel.getCustomer()
            }
        }
        
    }
}

struct UserDetails: View {
    @StateObject var profileViewModel: ProfileViewModel
    var body: some View {
        HStack{
            Spacer()
            VStack {
                Text(profileViewModel.customer?.first_name ?? " " + (profileViewModel.customer?.last_name ?? "") )
                    .bold()
                
                
                Text(profileViewModel.customer?.email ?? " ")
                    .foregroundColor(.gray)
                    .padding(.bottom)
            }.padding(.trailing, 24)
            Image(systemName: "eraser")
            Spacer()
        }
    }
}

#Preview {
    MeView()
}
