//
//  CustomerModel.swift
//  Shoplet
//
//  Created by Macos on 10/06/2025.
//

import Foundation

struct CustomerRequest: Codable {
    let customer: Customer
}

struct Customer: Codable {
    let id: Int?
    let email: String?
    let created_at: String?
    let updated_at: String?
    let first_name: String?
    let last_name: String?
    let orders_count: Int?
    let state: String?
    let total_spent: String?
    let last_order_id: Int?
    let note: String?
    let verified_email: Bool?
    let multipass_identifier: String?
    let tax_exempt: Bool?
    let tags: String?
    let last_order_name: String?
    let currency: String?
    let phone: String?
    let addresses: [Address]?
    let tax_exemptions: [String]?
    let email_marketing_consent: MarketingConsent?
    let sms_marketing_consent: SMSMarketingConsent?
    let admin_graphql_api_id: String?
    let default_address: Address?
    let password: String?
    let password_confirmation: String?
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

struct MarketingConsent: Codable {
    let state: String?
    let opt_in_level: String?
    let consent_updated_at: String?
}

struct SMSMarketingConsent: Codable {
    let state: String?
    let opt_in_level: String?
    let consent_updated_at: String?
    let consent_collected_from: String?
}

struct CustomerAuthResponse: Codable {
    let customer: Customer?
}

struct CustomerListResponse: Codable {
    let customers: [Customer]
}

