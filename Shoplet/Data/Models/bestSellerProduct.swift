//
//  bestSellerProduct.swift
//  Shoplet
//
//  Created by Farid on 10/06/2025.
//

import Foundation
struct PopularProductsResponse: Codable {
    let products: [PopularProductItem]?
}


struct PopularProductItem: Codable, Identifiable {
    let id: Int?
    let title: String?
    let bodyHtml: String?
    let vendor: String?
    let productType: String?
    let createdAt: String?
    let handle: String?
    let updatedAt: String?
    let publishedAt: String?
    let templateSuffix: String?
    let tags: String?
    let adminGraphqlApiId: String?
    let status: String?                       // added from ProductsModel
    let variants: [PopularVariant]?
    let options: [PopularOption]?
    let images: [PopularProductImage]?
    let image: PopularProductImage?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case bodyHtml = "body_html"
        case vendor
        case productType = "product_type"
        case createdAt = "created_at"
        case handle
        case updatedAt = "updated_at"
        case publishedAt = "published_at"
        case templateSuffix = "template_suffix"
        case tags
        case adminGraphqlApiId = "admin_graphql_api_id"
        case status
        case variants
        case options
        case images
        case image
    }
}


struct PopularVariant: Codable {
    let id: Int?
    let productId: Int?
    let title: String?
    let price: String?
    let sku: String?
    let position: Int?
    let inventoryPolicy: String?
    let compareAtPrice: String?
    let fulfillmentService: String?
    let inventoryManagement: String?
    let option1: String?
    let option2: String?
    let option3: String?
    let createdAt: String?
    let updatedAt: String?
    let taxable: Bool?
    let barcode: String?
    let grams: Int?
    let imageId: Int?
    let weight: Double?
    let weightUnit: String?
    let inventoryItemId: Int?
    let inventoryQuantity: Int?
    let oldInventoryQuantity: Int?
    let requiresShipping: Bool?
    let adminGraphqlApiId: String?

    enum CodingKeys: String, CodingKey {
        case id
        case productId = "product_id"
        case title
        case price
        case sku
        case position
        case inventoryPolicy = "inventory_policy"
        case compareAtPrice = "compare_at_price"
        case fulfillmentService = "fulfillment_service"
        case inventoryManagement = "inventory_management"
        case option1
        case option2
        case option3
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case taxable
        case barcode
        case grams
        case imageId = "image_id"
        case weight
        case weightUnit = "weight_unit"
        case inventoryItemId = "inventory_item_id"
        case inventoryQuantity = "inventory_quantity"
        case oldInventoryQuantity = "old_inventory_quantity"
        case requiresShipping = "requires_shipping"
        case adminGraphqlApiId = "admin_graphql_api_id"
    }
}

struct PopularOption: Codable {
    let id: Int?
    let productId: Int?
    let name: String?
    let position: Int?
    let values: [String]?

    enum CodingKeys: String, CodingKey {
        case id
        case productId = "product_id"
        case name
        case position
        case values
    }
}

struct PopularProductImage: Codable {
    let id: Int?
    let productId: Int?
    let position: Int?
    let createdAt: String?
    let updatedAt: String?
    let alt: String?
    let width: Int?
    let height: Int?
    let src: String?
    let variantIds: [Int]?
    let adminGraphqlApiId: String?

    enum CodingKeys: String, CodingKey {
        case id
        case productId = "product_id"
        case position
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case alt
        case width
        case height
        case src
        case variantIds = "variant_ids"
        case adminGraphqlApiId = "admin_graphql_api_id"
    }
}
