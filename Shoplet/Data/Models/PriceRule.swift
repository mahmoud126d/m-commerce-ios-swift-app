//
//  PriceRule.swift
//  Shoplet
//
//  Created by Macos on 08/06/2025.
//

import Foundation

struct PriceRuleResponse : Codable{
    var price_rules : [PriceRule]
}
struct SinglePriceRuleResponse: Codable{
    var price_rule: PriceRule
}

struct PriceRule : Codable{
    var id : Int
    var value : String
    var value_type : String
    var starts_at : String
    var ends_at : String?
    var once_per_customer : Bool
    var title: String?
    var usage_limit : Int?
    var target_type : String?
    var target_selection : String?
    var prerequisite_product_ids : [Int]
    var prerequisite_variant_ids : [Int]
    var prerequisite_collection_ids : [Int]
    
}
