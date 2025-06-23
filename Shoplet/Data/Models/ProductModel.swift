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
    let option1: String?
    let option2: String?
    let option3: String?

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
        case option1, option2, option3

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
        let variantList: [Variant] = (self.variants as? Set<CDVariant>)?.compactMap { cdVariant in
            // dummy default values
            let defaultVariant = Variant(
                id: 0,
                productId: 0,
                title: "Unknown",
                price: "0.0",
                sku: "N/A",
                position: 0,
                compareAtPrice: nil,
                inventoryItemId: 0,
                inventoryQuantity: 0,
                oldInventoryQuantity: 0,
                imageId: nil,
                option1: nil,
                option2: nil,
                option3: nil
            )

            guard let price = cdVariant.price else {
                return defaultVariant
            }

            let imageIdInt: Int? = {
                if let imageIdStr = cdVariant.imageId {
                    return Int(imageIdStr)
                }
                return nil
            }()

            return Variant(
                id: Int(cdVariant.id),
                productId: Int(cdVariant.productId),
                title: cdVariant.title ?? "Untitled",
                price: price,
                sku: cdVariant.sku ?? "N/A",
                position: Int(cdVariant.position),
                compareAtPrice: cdVariant.compareAtPrice,
                inventoryItemId: Int(cdVariant.inventoryItemId),
                inventoryQuantity: Int(cdVariant.inventoryQuantity),
                oldInventoryQuantity: Int(cdVariant.oldInventoryQuantity),
                imageId: imageIdInt,
                option1: "",
                option2: "",
                option3: ""
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
