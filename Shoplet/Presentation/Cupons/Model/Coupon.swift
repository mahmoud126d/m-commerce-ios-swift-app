//
//  Coupon.swift
//  Shoplet
//
//  Created by Macos on 08/06/2025.
//

import Foundation

struct CouponResponse: Codable{
    var discount_codes : [Coupon]
}

struct Coupon : Codable{
    var id : Int
    var price_rule_id : Int
    var code : String
    var usage_count : Int
}
