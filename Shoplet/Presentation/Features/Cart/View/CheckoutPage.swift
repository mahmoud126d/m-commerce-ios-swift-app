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
    @State private var applePay: ApplePay?
    @State private var navigateToOrderConfirmation = false
    @State private var confirmedTotalPrice = ""
    @State private var confirmedCustomerName: String? = nil
    @State private var confirmedItemsCount = 0
    @State private var isLoading = false
    @State private var isCopunValid = true
    @State private var isUsedBefore = false

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
                    cartViewModel.validateDiscount(discount: coupon) { isValid in
                        if isValid {
                            cartViewModel.checkCouponsUsedLater(copuns: coupon) { isUsed in
                                if isUsed {
                                    print("Coupon already used before.")
                                    isUsedBefore = true
                                } else {
                                    discountValue = cartViewModel.discountValue ?? "5.0"
                                    cartViewModel.applayDiscount(discount: coupon)
                                    UserDefaultManager.shared.isUsedACopuns = true
                                    isCopunValid = true
                                }
                            }
                        } else {
                            print("Coupon is not valid.")
                            isCopunValid = false
                        }
                    }
                } label: {
                    Text("Validate")
                        .foregroundColor(.white)
                }
                .padding()
                .background(UserDefaultManager.shared.isUsedACopuns ? Color.primaryColor.opacity(0.9) : Color.primaryColor)
                .cornerRadius(12)
                .disabled(UserDefaultManager.shared.isUsedACopuns)


            }.padding()
            if !isCopunValid{
                Text("This Copun is Wrong")
                    .font(.headline)
                    .foregroundColor(.red)
            }
            
            
            let currency = UserDefaultManager.shared.currency ?? "USD"
            let rate = Double(UserDefaultManager.shared.currencyRate ?? "1.0") ?? 1.0

            PriceRow(
                title: "Discounts",
                desc:  "\(String(format: "%.2f", Double(discountValue)! * rate)) \(currency) " ,
                color: .red
            )
            .padding(.trailing, 8)

            PriceRow(
                title: "SubPrice",
                desc: "\(String(format: "%.2f", (Double(cartViewModel.subTotal ?? "0.0") ?? 0.0) * rate)) \(currency)"
            )

            PriceRow(
                title: "Tax",
                desc: "\(String(format: "%.2f", (Double(cartViewModel.tax ?? "0.0") ?? 0.0) * rate))\(currency)"
            )

            PriceRow(
                title: "TotalPrice",
                desc: "\(String(format: "%.2f", (Double(cartViewModel.total ?? "0.0") ?? 0.0) * rate)) \(currency)"
            )
            if isLoading{
                ProgressView()
            }
            Spacer().frame(height: 20)
            Button(
                action: {
                    cartViewModel.completeOrder()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                      confirmOrderAndNavigate()
                                  }
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
            
            ApplePayButton(action: {
                isLoading = true
                guard let draft_order = cartViewModel.draftOrder else {return}
                applePay = ApplePay(draftOrder: draft_order){
                        isLoading = true
                        cartViewModel.completeOrder()
                    

                }
                applePay?.startPayment(draftOrder: draft_order)

            }).frame(maxWidth: .infinity, maxHeight: 40)
                .padding(.horizontal, 24)
            NavigationLink(
                           destination: OrderConfirmationView(
                               totalPrice: confirmedTotalPrice,
                               customerName: confirmedCustomerName,
                               itemsCount: confirmedItemsCount
                           ),
                           isActive: $navigateToOrderConfirmation,
                           label: { EmptyView() }
                       )

            Spacer()
                .alert("Coupn Already Used", isPresented: $isUsedBefore) {
                    Button("OK", role: .cancel) {}
                } message: {
                    Text("you used this coupon Already please select another one.")
                }
        }.onAppear{
            cartViewModel.getAllPriceRules()
            (UserDefaultManager.shared.isNotDefaultAddress == false)  ?
            cartViewModel.getCustomerShippingAddress()
            : cartViewModel.getDraftOrderById()
        }
    }
    
    private func confirmOrderAndNavigate() {
          confirmedTotalPrice = cartViewModel.total ?? "0.00"
          confirmedCustomerName = cartViewModel.draftOrder?.customer?.first_name
          confirmedItemsCount = cartViewModel.draftOrder?.line_items?.count ?? 0
          navigateToOrderConfirmation = true
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
