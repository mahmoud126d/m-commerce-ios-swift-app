//
//  Support.swift
//  Shoplet
//
//  Created by Farid on 10/06/2025.
//

import Foundation
struct Support {
    
    static let shopName = "ios1-ism"
    static let accessToken = "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"
    static let apiKey = "eb41b2a7fcfd647779c4b29cb454bdfa"
    static let apiVersion = "/admin/api/2024-10/"
    static let baseURL = "https://\(apiKey):\(accessToken)@\(shopName).myshopify.com"
}


enum ShopifyResource {
    case products
    case smartCollections
    case priceRules
    case getPriceRule
    case discounts
    case createDraftOrder
    case updateDraftOrder
    case getDraftOrderById
    case getAllDraftOrders
    case deleteDraftOrder
    case customers
    case getAddress
    case updateAddress
    case createAddress
    case getuserAddresses
    case markAddressDefault
    case deleteAddress

    var endpoint: String {
        switch self {
        case .products:
            return "products"
        case .smartCollections: return "smart_collections"
        case .priceRules, .getPriceRule:
            return "price_rules"
        case .discounts:
            return "discount_codes"
        case .createDraftOrder, .updateDraftOrder, .getDraftOrderById, .deleteDraftOrder, .getAllDraftOrders:
            return "draft_orders"
        case .customers: return "customers"
        case .createAddress, .getAddress, .updateAddress, .getuserAddresses, .deleteAddress:
            return "addresses"
        case .markAddressDefault:
            return "default"

        }
    }
}


enum HTTPHeaderField: String {
    case contentType = "Content-Type"
    case authorization = "Authorization"
    case password = "X-Shopify-Access-Token"
}

enum ContentType: String {
    case json = "application/json"
}


enum AuthorizationType {
    case basic
    case apiKey
    
    func headerValue() -> String {
        switch self {
        case .basic:
            let credentialData = "\(Support.apiKey):\(Support.accessToken)".data(using: .utf8)!
            let base64Credentials = credentialData.base64EncodedString()
            return "Basic \(base64Credentials)"
        case .apiKey:
            return Support.accessToken
        }
    }
}

struct Constants {
    static let baseUrl = Support.baseURL
}
