//
//  OrdersListView.swift
//  Shoplet
//
//  Created by Farid on 24/06/2025.
//

import SwiftUI
struct OrdersListView: View {
    let customerId: Int
    @StateObject var viewModel = OrderListViewModel()

    var body: some View {
        List(viewModel.orders) { order in
            NavigationLink(destination: OrderDetailsView(order: order)) {
                HStack {
                    Image(systemName: "cart.fill")
                        .foregroundColor(order.statusDisplay == "Completed" ? .green : .orange)
                        .imageScale(.large)
                    
                    VStack(alignment: .leading) {
                        Text("Order #\(order.id)")
                            .font(.headline)
                        Text("Status: \(order.statusDisplay)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text(order.createdAtFormatted)
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }

                    Spacer()

                    Text(order.totalPriceFormatted)
                        .font(.subheadline)
                        .bold()
                }
                .padding(.vertical, 8)
            }
        }
        .navigationTitle("My Orders")
        .onAppear {
            viewModel.fetchOrders(for: customerId)
        }
    }
}


//#Preview {
//    OrdersListView()
//}
