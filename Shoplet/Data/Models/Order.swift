//
//  Order.swift
//  Shoplet
//
//  Created by Farid on 25/06/2025.
//

import Foundation
struct ShopifyOrdersResponse: Codable {
    let orders: [ShopifyOrder]
}

struct ShopifyOrder: Codable ,Identifiable {
    let id: Int
    let created_at: String?
    let total_price: String?
    let line_items: [ShopifyLineItem]
    let customer: ShopifyCustomer?
    
    let financial_status: String?
    let fulfillment_status: String?

    // Computed properties
    var createdAt: Date? {
        guard let createdAt = created_at else { return nil }
        let formatter = ISO8601DateFormatter()
        return formatter.date(from: createdAt)
    }

    var totalPriceFormatted: String {
        return "$\(total_price ?? "0.00")"
    }

    var createdAtFormatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let createdAt = created_at,
           let date = formatter.date(from: createdAt) {
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            return formatter.string(from: date)
        }
        return "-"
    }

    var statusDisplay: String {
        if financial_status == "paid" || fulfillment_status == "fulfilled" {
            return "Completed"
        } else {
            return "Draft"
        }
    }
}

struct ShopifyLineItem: Codable {
    let id: Int
    let title: String
    let quantity: Int
    let price: String?
}

struct ShopifyCustomer: Codable {
    let id: Int
    let email: String?
    let first_name: String?
    let last_name: String?
}



//extension ShopifyOrder {
//    var statusDisplay: String {
//        if financial_status == "paid" || fulfillment_status == "fulfilled" {
//            return "Completed"
//        } else {
//            return "Draft"
//        }
//    }
//}
//
//extension ShopifyOrder {
//    var createdAtFormatted: String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
//        if let date = formatter.date(from: createdAt ?? "") {
//            formatter.dateStyle = .medium
//            formatter.timeStyle = .short
//            return formatter.string(from: date)
//        }
//        return createdAt ?? "-"
//    }
//
//    var totalPriceFormatted: String {
//        return "$\(total_price ?? "0.00")"
//    }
//}
//struct OrderListResponse: Codable {
//    let orders: [ShopifyOrder]
//}
//
//struct ShopifyOrder: Codable, Identifiable {
//    let id: Int
//    let created_at: String
//    let total_price: String
//    let line_items: [ShopifyLineItem]
//    let shipping_address: ShopifyAddress?
//}
//
//struct ShopifyLineItem: Codable {
//    let id: Int
//    let title : String
//    let quantity: Int
//    let price: String
//}
//
//struct ShopifyAddress: Codable {
//    let address1: String?
//    let city: String?
//    let country: String?
//    let zip: String?
//}
//struct ShopifyOrdersResponse: Codable {
//    let orders: [ShopifyOrder]
//}
//
//struct ShopifyOrder: Codable, Identifiable {
//    let id: Int
//    let name: String?
//    let createdAt: String
//    let updatedAt: String?
//    let totalPrice: String
//    let subtotalPrice: String?
//    let totalTax: String?
//    let currency: String
//    let financialStatus: String?
//    let fulfillmentStatus: String?
//    let orderStatusUrl: String?
//
//    let customer: ShopifyOrderCustomer?
//    let shippingAddress: ShopifyAddress?
//    let billingAddress: ShopifyAddress?
//    let lineItems: [ShopifyLineItem]
//
//    enum CodingKeys: String, CodingKey {
//        case id, name
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//        case totalPrice = "total_price"
//        case subtotalPrice = "subtotal_price"
//        case totalTax = "total_tax"
//        case currency
//        case financialStatus = "financial_status"
//        case fulfillmentStatus = "fulfillment_status"
//        case orderStatusUrl = "order_status_url"
//        case customer
//        case shippingAddress = "shipping_address"
//        case billingAddress = "billing_address"
//        case lineItems = "line_items"
//    }
//}
//
//struct ShopifyOrderCustomer: Codable {
//    let id: Int
//    let email: String?
//    let firstName: String?
//    let lastName: String?
//    let phone: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id, email
//        case firstName = "first_name"
//        case lastName = "last_name"
//        case phone
//    }
//}
//
//struct ShopifyAddress: Codable {
//    let firstName: String?
//    let lastName: String?
//    let address1: String?
//    let address2: String?
//    let city: String?
//    let province: String?
//    let country: String?
//    let zip: String?
//    let phone: String?
//    let company: String?
//
//    enum CodingKeys: String, CodingKey {
//        case firstName = "first_name"
//        case lastName = "last_name"
//        case address1, address2, city, province, country, zip, phone, company
//    }
//}
//
//struct ShopifyLineItem: Codable, Identifiable {
//    let id: Int
//    let variantId: Int?
//    let title: String?
//    let quantity: Int
//    let price: String
//    let sku: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case variantId = "variant_id"
//        case title, quantity, price, sku
//    }
//}
//struct OrderListResponse: Codable {
//    let orders: [Order]
//}
//
//struct Order: Codable, Identifiable {
//    let id: Int
//    let name: String
//    let created_at: String
//    let total_price: String
//    let line_items: [LineItem]
//    let shipping_address: AddressDetails?
//    // Add more fields as needed
//}
