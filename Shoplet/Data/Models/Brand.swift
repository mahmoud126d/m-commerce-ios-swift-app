//
//  Brand.swift
//  Shoplet
//
//  Created by Farid on 10/06/2025.
//

import Foundation
struct BrandsResponse: Codable {
    let smart_collections: [SmartCollection]?
}

struct SmartCollection: Codable, Identifiable, Hashable {
    let id: Int?
    let title: String?
    let image: BrandImage?
    
    var brandID: Int { id ?? 0 }
    var imageURL: String { image?.src ?? "" }
}

struct BrandImage: Codable, Hashable {
    let src: String?
    let alt: String?
    let width: Int?
    let height: Int?
}
