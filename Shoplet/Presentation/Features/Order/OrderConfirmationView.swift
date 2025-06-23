//
//  OrderConfirmationView.swift
//  Shoplet
//
//  Created by Farid on 23/06/2025.
//

import SwiftUI


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
