//
//  OrderViewModel.swift
//  Shoplet
//
//  Created by Farid on 24/06/2025.
//

import Foundation


class OrderListViewModel: ObservableObject {
    @Published var orders: [ShopifyOrder] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let getCustomerOrdersUseCase: GetCustomerOrdersUseCase

    init(getCustomerOrdersUseCase: GetCustomerOrdersUseCase = DefaultGetCustomerOrdersUseCase()) {
        self.getCustomerOrdersUseCase = getCustomerOrdersUseCase
    }

    func fetchOrders(for customerId: Int) {
        isLoading = true
        errorMessage = nil
        getCustomerOrdersUseCase.execute(customerId: customerId) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let orders):
                    self?.orders = orders
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}

//final class OrdersViewModel: ObservableObject {
//    @Published var orders: [ShopifyOrder] = []
//    @Published var isLoading = false
//    @Published var errorMessage: String?
//
//    private let getCustomerOrdersUseCase: GetCustomerOrdersUseCase
//
//    init(getCustomerOrdersUseCase: GetCustomerOrdersUseCase) {
//        self.getCustomerOrdersUseCase = getCustomerOrdersUseCase
//    }
//
//    func fetchOrders(customerId: Int) {
//        isLoading = true
//        errorMessage = nil
//        getCustomerOrdersUseCase.execute(customerId: customerId) { [weak self] result in
//            DispatchQueue.main.async {
//                self?.isLoading = false
//                switch result {
//                case .success(let orders):
//                    self?.orders = orders
//                case .failure(let error):
//                    self?.errorMessage = error.localizedDescription
//                }
//            }
//        }
//    }
//}


//
//import Foundation
//
//
//class OrderViewModel: ObservableObject {
//    @Published var completedOrder: DraftOrder?
//    @Published var completedOrders: [DraftOrder] = []
//    
//    private let completedOrdersKey = "completedOrders"
//
//    // MARK: - Save Completed Orders
//    private func saveCompletedOrdersToUserDefaults() {
//        do {
//            let data = try JSONEncoder().encode(completedOrders)
//            UserDefaults.standard.set(data, forKey: completedOrdersKey)
//        } catch {
//            print("❌ Failed to encode completed orders: \(error)")
//        }
//    }
//
//    // MARK: - Load Completed Orders
//    func loadCompletedOrdersFromUserDefaults() {
//        if let data = UserDefaults.standard.data(forKey: completedOrdersKey) {
//            do {
//                let orders = try JSONDecoder().decode([DraftOrder].self, from: data)
//                self.completedOrders = orders
//            } catch {
//                print("❌ Failed to decode completed orders: \(error)")
//            }
//        }
//    }
//
//    func fetchCompletedOrderById(id: Int, completion: @escaping () -> Void = {}) {
//        APIClient.getDraftOrderById(dtaftOrderId: id) { result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let orderItem):
//                    self.completedOrder = orderItem.draft_order
//                    completion()
//                case .failure(let error):
//                    print("❌ Error fetching order: \(error.localizedDescription)")
//                    completion()
//                }
//            }
//        }
//    }
//
//    // 🔥 ADD THIS METHOD:
//    func completeOrder(draftOrderId: Int) {
//        APIClient.completeOrder(draftOrderId: draftOrderId) { result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let response):
//                    if let completed = response.draft_order {
//                        self.completedOrders.insert(completed, at: 0)
//                        self.saveCompletedOrdersToUserDefaults() // ✅ Save after update
//                        UserDefaults.standard.set(completed.id, forKey: "lastCompletedOrderId")
//                        print("✅ Order completed and saved: \(completed.id ?? 0)")
//                    }
//                case .failure(let error):
//                    print("❌ Failed to complete order: \(error)")
//                }
//            }
//        }
//    }
//
//    func fetchOrders() {
//        APIClient.getDraftOrders { result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let response):
//                    // Filter only completed orders
//                    self.completedOrders = response.draft_orders.filter { $0.status == "completed" }
//                case .failure(let error):
//                    print("❌ Error fetching orders: \(error.localizedDescription)")
//                }
//            }
//        }
//    }
//}

//class OrderViewModel: ObservableObject {
//    @Published var completedOrder: DraftOrder?
//
//    func fetchCompletedOrderById(id: Int, completion: @escaping () -> Void = {}) {
//        APIClient.getDraftOrderById(dtaftOrderId: id) { result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let orderItem):
//                    self.completedOrder = orderItem.draft_order
//                    print("✅ Completed order fetched: \(orderItem.draft_order?.id ?? 0)")
//                    completion()
//                case .failure(let error):
//                    print("❌ Failed to fetch order by ID: \(error)")
//                    completion()
//                }
//            }
//        }
//    }
//}
//class OrderViewModel: ObservableObject {
//    @Published var allOrders: [DraftOrder] = []
//    @Published var completedOrders: [DraftOrder] = []
//
//    func fetchOrders() {
//        APIClient.getDraftOrders { [weak self] result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let response):
//                    self?.allOrders = response.draft_orders
//                    self?.completedOrders = response.draft_orders.filter { $0.completed_at != nil }
//                case .failure(let error):
//                    print("Error fetching orders: \(error.localizedDescription)")
//                }
//            }
//        }
//    }
//
//    func completeOrder(draftOrderId: Int) {
//        APIClient.completeOrder(draftOrderId: draftOrderId) { [weak self] result in
//            switch result {
//            case .success:
//                print("Order completed successfully")
//                self?.fetchOrders()
//            case .failure(let error):
//                print("Failed to complete order: \(error.localizedDescription)")
//            }
//        }
//    }
//}
//class OrderViewModel: ObservableObject {
//    
//    @Published var allOrders: [DraftOrder] = []
//    @Published var completedOrders: [DraftOrder] = []
//    
//    func fetchOrders() {
//        APIClient.getDraftOrders { [weak self] result in
//            switch result {
//            case .success(let orders):
//                DispatchQueue.main.async {
//                    self?.allOrders = orders.draft_orders
//                    self?.completedOrders = orders.draft_orders.filter { $0.completed_at != nil }
//                }
//            case .failure(let error):
//                print("Error: \(error.localizedDescription)")
//            }
//        }
//    }
//}
//
//class OrderViewModel: ObservableObject {
//    @Published var orders: [DraftOrder] = []
//    @Published var error: String?
//
//    func fetchOrders() {
//        APIClient.getDraftOrders { [weak self] result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let response):
//                    self?.orders = response.draft_orders
//                case .failure(let error):
//                    self?.error = error.localizedDescription
//                }
//            }
//        }
//    }
//}
