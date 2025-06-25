//
//  OrdersRepository.swift
//  Shoplet
//
//  Created by Farid on 25/06/2025.
//

import Foundation
protocol OrdersRepository {
    func fetchAllOrders(completion: @escaping (Result<[ShopifyOrder], Error>) -> Void)
}
