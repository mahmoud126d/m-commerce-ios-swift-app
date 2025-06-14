//
//  CheckoutPage.swift
//  Shoplet
//
//  Created by Macos on 14/06/2025.
//

import SwiftUI

struct CheckoutPage: View {
    @State private var coupon = ""
    @StateObject  var cartViewModel : CartViewModel
    var body: some View {
        VStack{
            Text("Checkout")
                .font(.headline)
                .bold()
            Spacer()
            HStack{
                TextField("Enter Coupon...", text: $coupon)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                            )
                
                Button {
                    
                } label: {
                    Text("Validate")
                        .foregroundColor(.white)
                }.padding()
                 .background(Color.primaryColor)
                 .cornerRadius(12)

            }.padding()
            
            PriceRow(title: "Discounts", desc: "0.0", color: .red).padding(.trailing, 8)
            PriceRow(title: "SubPrice", desc: "\(cartViewModel.subTotal ?? "0.0") USD")
            PriceRow(title: "Tax", desc: "\(cartViewModel.tax ?? "0.0") USD")
            PriceRow(title: "TotalPrice", desc: "\(cartViewModel.total ?? "0.0") USD")
            Spacer()

        }
    }
}

struct PriceRow : View{
    var title: String
    var desc: String
    var color : Color = .black
    var body: some View{
        HStack{
            Text(title)
                .bold()
            Spacer()
            Text(desc)
                .foregroundColor(color)
            
        }.padding(.horizontal, 16)
            .padding(.vertical, 8)
    }
}

#Preview {
    CheckoutPage(cartViewModel: CartViewModel())
}
