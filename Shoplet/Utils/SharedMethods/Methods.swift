//
//  Methods.swift
//  Shoplet
//
//  Created by Macos on 11/06/2025.
//

import Foundation

class Methods{
    static func getPrice(product: ProductModel, quantity: Int) -> Double {
        let basePrice = product.variants?.first?.price ?? "35.8"
        return (Double(basePrice) ?? 0.0) * Double(quantity)
    }
}
