//
//  Product.swift
//  Shoplet
//
//  Created by Macos on 04/06/2025.
//

import Foundation

struct ProductResponse: Codable {
    let products: [ProductModel]
}

struct ProductModel: Codable ,Identifiable{
    let id: Int?
    let title: String?
    let bodyHTML: String?
    let vendor: String?
    let productType: String?
    let tags: String?
    let status: String?
    let variants: [Variant]?
    let options: [Option]?
    let images: [ProductImage]?
    let image: ProductImage?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case bodyHTML = "body_html"
        case vendor
        case productType = "product_type"
        case tags
        case status
        case variants
        case options
        case images
        case image
    }
}

struct Variant: Codable {
    let id: Int?
    let productId: Int?
    let title: String?
    let price: String?
    let sku: String?
    let position: Int?
    let compareAtPrice: String?
    let inventoryItemId: Int?
    let inventoryQuantity: Int?
    let oldInventoryQuantity: Int?
    let imageId: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case productId = "product_id"
        case title
        case price
        case sku
        case position
        case inventoryItemId = "inventory_item_id"
        case inventoryQuantity = "inventory_quantity"
        case oldInventoryQuantity = "old_inventory_quantity"
        case imageId = "image_id"
        case compareAtPrice = "compare_at_price"

    }
}

struct Option: Codable {
    let id: Int
    let productId: Int
    let name: String
    let position: Int
    let values: [String]

    enum CodingKeys: String, CodingKey {
        case id
        case productId = "product_id"
        case name
        case position
        case values
    }
}

struct ProductImage: Codable {
    let id: Int
    let alt: String?
    let position: Int
    let productId: Int
    let width: Int
    let height: Int
    let src: String?
    let variantIds: [Int]

    enum CodingKeys: String, CodingKey {
        case id
        case alt
        case position
        case productId = "product_id"
        case width
        case height
        case src
        case variantIds = "variant_ids"
    }
}


struct ProductEntity {
    let userId: String?
    let productId: String?
    let variantId: String?
    let title: String?
    let bodyHTML: String?
    let vendor: String?
    let productType: String?
    let inventoryQuantity: String?
    let tags: String?
    let price: String?
    let images: [String]?
    var isFav: Bool? = false
}
