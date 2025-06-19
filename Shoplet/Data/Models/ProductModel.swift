//
//  Product.swift
//  Shoplet
//
//  Created by Macos on 04/06/2025.
//

import Foundation
import SwiftUI


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

extension CDProduct {
    func toProductModel() -> ProductModel? {
        guard let title = self.title else { return nil }

        let imageList: [ProductImage] = (self.images as? Set<CDImage>)?.sorted(by: { $0.position < $1.position }).compactMap {
            guard let src = $0.src else { return nil }
            return ProductImage(
                id: Int($0.id),
                alt: $0.alt,
                position: Int($0.position),
                productId: Int($0.productId),
                width: Int($0.width),
                height: Int($0.height),
                src: src,
                variantIds: []
            )
        } ?? []

        let variantList: [Variant] = (self.variants as? Set<CDVariant>)?.compactMap {
            guard let price = $0.price else { return nil }
            return Variant(
                id: Int($0.id),
                productId: Int($0.productId),
                title: $0.title,
                price: price,
                sku: $0.sku,
                position: Int($0.position),
                compareAtPrice: $0.compareAtPrice,
                inventoryItemId: Int($0.inventoryItemId),
                inventoryQuantity: Int($0.inventoryQuantity),
                oldInventoryQuantity: Int($0.oldInventoryQuantity),
                imageId: Int($0.imageId ?? "")
            )
        } ?? []


        return ProductModel(
            id: Int(self.productId),
            title: title,
            bodyHTML: self.bodyHTML,
            vendor: self.vendor,
            productType: self.productType,
            tags: self.tags,
            status: self.status,
            variants: variantList,
            options: [],
            images: imageList,
            image: imageList.first
        )
    }
}
