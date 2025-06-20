//
//  CartView.swift
//  Shoplet
//
//  Created by Farid on 10/06/2025.
//

import SwiftUI

struct CartView: View {
    @StateObject var cartViewModel = CartViewModel()
    @State private var isActive = false
    @State private var showAddressAlert = false
    var body: some View {
        NavigationView{
            VStack{
                Text("Cart")
                    .font(.headline)
                    .bold()
                if cartViewModel.draftOrder != nil {
                    let draftOrder = cartViewModel.draftOrder
                               ScrollView (showsIndicators: false){
                                   VStack{
                                       ForEach(0..<(draftOrder?.line_items?.count ?? 0), id: \.self) { index in
                                           
                                           if let item = cartViewModel.draftOrder?.line_items?[index] {
                                                   CartItem(
                                                       lineItem: item,
                                                       onQuantityChange: { qan in
                                                           cartViewModel.draftOrder?.line_items?[index].quantity = qan
                                                           cartViewModel.updateLineItemQuantity(lineItem: cartViewModel.draftOrder!.line_items![index])
                                                       }
                                                   ){
                                                       cartViewModel.deleteItemLine(lineItem: item)
                                                   }
                                               }
                                       }
                                      
                                   }
                               }
                    HStack{
                        
                        Text("SubTotal: \(cartViewModel.subTotal ?? "0.0") USD")
                            .bold()
                        NavigationLink(destination: CheckoutPage(cartViewModel: cartViewModel), isActive: $isActive) {
                            Button(action: {
                                if cartViewModel.address == nil{
                                    showAddressAlert = true
                                }
                                else {
                                    isActive = true
                                }
                            }) {
                                Text("Checkout")
                                    .padding()
                                    .background(Color.primaryColor.opacity(0.7))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 16)
                            }
                        }
                    }.padding(.bottom, 120)
                     .padding(.top)
                     .alert("No Shipping Address", isPresented: $showAddressAlert) {
                         Button("OK", role: .cancel) {}
                     } message: {
                         Text("Please go to profile and add an address before proceeding to checkout.")
                     }

                    
                           } else {
                               Spacer()
                               Text("No Data in Cart")
                                   .foregroundColor(.gray)
                               Spacer()
                           }
            }.onAppear{
                cartViewModel.getDraftOrderById()
                cartViewModel.getCustomerShippingAddress()
            }
        }
        }
    }

#Preview {
    CartView()
}
