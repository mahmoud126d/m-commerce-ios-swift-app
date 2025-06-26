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


