//
//  Address.swift
//  Shoplet
//
//  Created by Macos on 19/06/2025.
//

import Foundation

struct AddressRequest: Codable{
    var customer_address: AddressDetails?
}
struct AddressResponse: Codable{
    var addresses: [AddressDetails]?
}

struct AddressDetails: Codable {
    let id: Int?
    let customer_id: Int?
    let first_name: String?
    let last_name: String?
    let company: String?
    let address1: String?
    let address2: String?
    let city: String?
    let province: String?
    let country: String?
    let zip: String?
    let phone: String?
    let name: String?
    let province_code: String?
    let country_code: String?
    let country_name: String?
    let `default`: Bool?
}
