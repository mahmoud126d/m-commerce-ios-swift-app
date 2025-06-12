//
//  CustomerModel.swift
//  Shoplet
//
//  Created by Macos on 10/06/2025.
//

import Foundation

import Foundation

// CustomerRequest struct
struct CustomerRequest: Codable {
    let customer: Customer
}

// Customer struct
struct Customer: Codable {
    var password_confirmation: String? = ""
    let phone: String
    let password: String
    let last_name: String
    var send_email_welcome: Bool = false
    var verified_email: Bool = true
   // let addresses: [Address]
    let email: String
    let first_name: String
}
struct CustomerUpdateRequest:Codable{
    let customer:CustomerUpdateRequestBody?
}

struct CustomerUpdateRequestBody:Codable{
    let first_name: String?
    let last_name: String?
    let phone: String?
    let email: String?
}


struct Address: Codable {
    let phone: String?
    let country: String?
    var province: String? = ""
    var zip: String? = ""
    let address1: String?
    let first_name: String?
    let last_name: String?
    let city: String?
}
//
//struct CustomerList :Codable{
//    var customers:[Customer]
//}
