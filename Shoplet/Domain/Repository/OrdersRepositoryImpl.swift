//
//  OrdersRepositoryImpl.swift
//  Shoplet
//
//  Created by Farid on 25/06/2025.
//

import Foundation
final class OrdersRepositoryImpl: OrdersRepository {
    func fetchAllOrders(completion: @escaping (Result<[ShopifyOrder], Error>) -> Void) {
        APIClient().fetchAllOrders(completion: completion)
    }
}
