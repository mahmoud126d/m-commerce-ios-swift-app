//
//  OrderDetailsView.swift
//  Shoplet
//
//  Created by Farid on 24/06/2025.
//

import SwiftUI

struct OrderDetailsView: View {
    let order: ShopifyOrder

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Order ID: \(order.id)")
                .font(.headline)

            if let createdAt = order.createdAt {
                Text("Date: \(createdAt.formatted())")
            }

            Text("Total: \(order.total_price ?? "N/A")")
                .font(.title2)
                .bold()

            Divider()

            Text("Items:")
                .font(.headline)

            ForEach(order.line_items, id: \.id) { item in
                VStack(alignment: .leading) {
                    Text(item.title)
                    Text("Quantity: \(item.quantity)")
                    Text("Price: \(item.price ?? "N/A")")
                }
                .padding(.bottom, 8)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Order Details")
    }
}

//struct OrderDetailsView: View {
//    let order: DraftOrder
//
//    var body: some View {
//        ScrollView {
//            VStack(alignment: .leading, spacing: 12) {
//                Text("Order #\(order.id ?? 0)")                    .font(.title2)
//                    .bold()
//
//                Text("Placed on: \(formattedDate(order.created_at))")
//                Text("Total Price: $\(order.total_price ?? "0.00")")
//
//                Divider()
//
//                Text("Items").font(.headline)
//                ForEach(order.line_items ?? [], id: \.id) { item in
//                    VStack(alignment: .leading) {
//                        Text(item.title ?? "No title")
//                            .bold()
//                        Text("Quantity: \(item.quantity ?? 1)")
//                    }
//                    .padding(.vertical, 4)
//                }
//
//                if let address = order.shipping_address {
//                    Divider()
//                    Text("Shipping Address").font(.headline)
//                    Text(address.name ?? "")
//                    Text(address.address1 ?? "")
//                    Text(address.city ?? "")
//                }
//
//                Spacer()
//            }
//            .padding()
//        }
//        .navigationTitle("Order Details")
//    }
//
//    func formattedDate(_ dateString: String?) -> String {
//        guard let dateString = dateString else { return "N/A" }
//        let formatter = ISO8601DateFormatter()
//        if let date = formatter.date(from: dateString) {
//            let displayFormatter = DateFormatter()
//            displayFormatter.dateStyle = .medium
//            displayFormatter.timeStyle = .short
//            return displayFormatter.string(from: date)
//        }
//        return "Invalid date"
//    }
//}

//#Preview {
//    OrderDetailsView(order: .mock)
//}
//extension DraftOrder {
//    static var mock: DraftOrder {
//        DraftOrder(
//            id: 101,
//            name: "Order #101",
//            email: "john@example.com",
//            currency: "USD",
//            line_items: [
//                LineItem(
//                    price: "59.99", quantity: 1, title: "Sneakers"
//                ),
//                LineItem(
//                    price: "30.00", quantity: 1, title: "T-Shirt"
//                )
//            ], total_price: "89.99",
//            created_at: "2025-06-22T14:30:00Z"
//        )
//    }
//}
