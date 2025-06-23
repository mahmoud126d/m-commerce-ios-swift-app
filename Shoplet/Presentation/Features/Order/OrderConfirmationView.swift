//
//  OrderConfirmationView.swift
//  Shoplet
//
//  Created by Farid on 23/06/2025.
//

import SwiftUI

//struct OrderConfirmationView: View {
//    var body: some View {
//        VStack(spacing: 24) {
//            Image(systemName: "checkmark.circle.fill")
//                .resizable()
//                .frame(width: 100, height: 100)
//                .foregroundColor(.green)
//
//            Text("Order Confirmed!")
//                .font(.title)
//                .bold()
//
//            Text("Thank you for your purchase. A confirmation has been sent to your email.")
//                .multilineTextAlignment(.center)
//                .padding()
//
//            Button("Continue Shopping") {
//                // You can pop to root view or navigate to home
//            }
//            .padding()
//            .background(Color.primaryColor)
//            .foregroundColor(.white)
//            .cornerRadius(8)
//        }
//        .padding()
//    }
//}
struct OrderConfirmationView: View {
    let totalPrice: String
    let customerName: String?
    let itemsCount: Int

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .frame(width: 80, height: 80)
                .foregroundColor(.green)

            Text("Order Placed Successfully!")
                .font(.title)
                .bold()

            Text("Customer: \(customerName ?? "Guest")")
            Text("Items: \(itemsCount)")
            Text("Total: \(totalPrice)")

            Spacer()
        }
        .padding()
        .navigationTitle("Confirmation")
    }
}
#Preview {
    OrderConfirmationView(totalPrice: "", customerName: "", itemsCount: 1)
}
