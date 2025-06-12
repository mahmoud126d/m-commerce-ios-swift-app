//
//  CartView.swift
//  Shoplet
//
//  Created by Farid on 10/06/2025.
//

import SwiftUI

struct CartView: View {
    @StateObject var cartViewModel = CartViewModel()
    var body: some View {
        VStack{
            Text("Cart")
                .font(.largeTitle)
                .bold()
            if let draftOrder = cartViewModel.draftOrder {
                           ScrollView {
                               ForEach(0..<(draftOrder.line_items?.count ?? 0 ), id: \.self) { index in
                                   
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
                       } else {
                           Text("No Data in Cart")
                               .foregroundColor(.gray)
                       }
        }.onAppear{
            cartViewModel.getDraftOrderById()
        }
    }
}

#Preview {
    CartView()
}
