//
//  GetOrdersForCustomerUseCase.swift
//  Shoplet
//
//  Created by Farid on 25/06/2025.
//

import Foundation


protocol GetCustomerOrdersUseCase {
    func execute(customerId: Int, completion: @escaping (Result<[ShopifyOrder], Error>) -> Void)
}

class DefaultGetCustomerOrdersUseCase: GetCustomerOrdersUseCase {
    private let repository: OrdersRepository

    init(repository: OrdersRepository = OrdersRepositoryImpl()) {
        self.repository = repository
    }

    func execute(customerId: Int, completion: @escaping (Result<[ShopifyOrder], Error>) -> Void) {
        repository.fetchAllOrders { result in
            switch result {
            case .success(let orders):
                let filtered = orders.filter { $0.customer?.id == customerId }
                completion(.success(filtered))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
//func execute(customerId: Int, completion: @escaping (Result<[ShopifyOrder], Error>) -> Void)
//}
//
//class DefaultGetOrdersForCustomerUseCase: GetOrdersForCustomerUseCase {
//   private let repository: OrderRepository
//
//   init(repository: OrderRepository) {
//       self.repository = repository
//   }
//
//   func execute(customerId: Int, completion: @escaping (Result<[ShopifyOrder], Error>) -> Void) {
//       repository.getOrdersForCustomer(customerId: customerId, completion: completion)
//   }
//}
