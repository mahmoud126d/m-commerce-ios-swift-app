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
    @State var discountValue = "0.0"
    var body: some View {
        VStack{
            Text("Checkout")
                .font(.headline)
                .bold()
            CartShippingAddress(address: $cartViewModel.shippingAddress){
                address in
                cartViewModel.updateShipingAddress(address: address)
              
            }
                .padding()
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
                    cartViewModel.getPriceRuleById()
                    discountValue = cartViewModel.discountValue ?? "5.0"
                    
                } label: {
                    Text("Validate")
                        .foregroundColor(.white)
                }.padding()
                 .background(Color.primaryColor)
                 .cornerRadius(12)

            }.padding()
            
            let currency = UserDefaultManager.shared.currency ?? "USD"
            let rate = Double(UserDefaultManager.shared.currencyRate ?? "1.0") ?? 1.0

            PriceRow(
                title: "Discounts",
                desc:  "\(currency) \(String(format: "%.2f", Double(discountValue)! * rate))" ,
                color: .red
            )
            .padding(.trailing, 8)

            PriceRow(
                title: "SubPrice",
                desc: "\(currency) \(String(format: "%.2f", (Double(cartViewModel.subTotal ?? "0.0") ?? 0.0) * rate))"
            )

            PriceRow(
                title: "Tax",
                desc: "\(currency) \(String(format: "%.2f", (Double(cartViewModel.tax ?? "0.0") ?? 0.0) * rate))"
            )

            PriceRow(
                title: "TotalPrice",
                desc: "\(currency) \(String(format: "%.2f", (Double(cartViewModel.total ?? "0.0") ?? 0.0) * rate))"
            )
            
            Spacer().frame(height: 20)
            Button(
                action: {
                    cartViewModel.completeOrder()
                },
                   label: {
                       Text("Cash On Delivery").foregroundColor(.black)
                   }).frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(Color.white)
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.primaryColor)
                }.padding(.horizontal, 24)
            
            Button {
                guard let draft_order = cartViewModel.draftOrder else {return}
                let applePay = ApplePay(draftOrder: draft_order )
                applePay.startPayment(draftOrder: draft_order)

            } label: {
                Text("Buy with apple pay")
            }.frame(maxWidth: .infinity, maxHeight: 40)
                .padding(.horizontal, 24)

            Spacer()

        }.onAppear{
            (UserDefaultManager.shared.isNotDefaultAddress == false)  ?
            cartViewModel.getCustomerShippingAddress()
            : cartViewModel.getDraftOrderById()
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
