//
//  Order.swift
//  Shoplet
//
//  Created by Farid on 23/06/2025.
//

import Foundation
struct OrderResponse: Codable {
    let order: Order
}

struct Order: Codable {
    let id: Int?
    let email: String?
    let total_price: String?
    let name: String?
    let created_at: String?
    let line_items: [LineItem]?
    let shipping_address: AddressDetails?
    let billing_address: AddressDetails?
}
