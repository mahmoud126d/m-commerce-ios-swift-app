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
    static let baseURL = "https://\(shopName).myshopify.com"
}

enum ShopifyResource {
    case products
    case smartCollections
    case priceRules
    case discounts
    case customers
    case createDraftOrder
    case updateDraftOrder
    case getDraftOrderById
    case deleteDraftOrder

    var endpoint: String {
        switch self {
        case .products: return "products"
        case .smartCollections: return "smart_collections"
        case .priceRules: return "price_rules"
        case .discounts: return "discount_codes"
        case .customers: return "customers"
        case .createDraftOrder, .updateDraftOrder, .getDraftOrderById, .deleteDraftOrder :
                    return "draft_orders"
        }
    }
}

enum HTTPHeaderField: String {
    case contentType = "Content-Type"
    case authorization = "Authorization"
    case shopifyAccessToken = "X-Shopify-Access-Token"
}


enum ContentType: String {
    case json = "application/json"
}

enum AuthorizationType {
    case basic
    case apiKey

    func header(for type: HTTPHeaderField) -> (field: String, value: String) {
        switch self {
        case .basic:
            let credentials = "\(Support.apiKey):\(Support.accessToken)"
            let base64 = Data(credentials.utf8).base64EncodedString()
            return (HTTPHeaderField.authorization.rawValue, "Basic \(base64)")
        case .apiKey:
            return (HTTPHeaderField.shopifyAccessToken.rawValue, Support.accessToken)
        }
    }
}




struct Constants {
    static let baseUrl = Support.baseURL
}
