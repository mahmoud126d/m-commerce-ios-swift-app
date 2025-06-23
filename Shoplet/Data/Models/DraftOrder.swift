//
//  DraftOrder.swift
//  Shoplet
//
//  Created by Macos on 11/06/2025.
//

import Foundation

struct DraftOrdersResponse : Codable{
    var draft_orders : [DraftOrder]
}

struct DraftOrderItem : Codable{
    var draft_order : DraftOrder?
}

struct DraftOrder: Codable {
    var id: Int?
    var name: String?
    var customer: DraftOrderCustomer?
    var shipping_address: AddressDetails?
    var billing_address: AddressDetails?
    var note: String?
    var email: String?
    var currency: String?
    var invoice_sent_at: String?
    var invoice_url: String?
    var line_items: [LineItem]?
    var payment_terms: String?
    var shipping_line: String?
    var source_name: String?
    var tags: String?
    var tax_exempt: Bool?
    var tax_exemptions: [String]?
    var tax_lines: [TaxLine]?
    var applied_discount: AppliedDiscount?
    var taxes_included: Bool?
    var total_tax: String?
    var subtotal_price: String?
    var total_price: String?
    var completed_at: String?
    var created_at: String?
    var updated_at: String?
    var status: String?
    var admin_graphql_api_id: String?

}

struct DraftOrderCustomer:Codable {
    var id: Int?
    var email: String?
    var accepts_marketing: Bool?
    var created_at: String?
    var updated_at: String?
    var first_name: String?
    var last_name: String?
    var orders_count: Int?
    var state: String?
    var total_spent: String?
    var last_order_id: Int?
    var note: String?
    var verified_email: Bool?
    var multipass_identifier: String?
    var tax_exempt: Bool?
    var tax_exemptions: [String]?
    var phone: String?
    var tags: String?
    var last_order_name: String?
    var currency: String?
    var admin_graphql_api_id: String?
    var addresses: [AddressDetails]?
    var default_address: AddressDetails?
}



struct LineItem: Codable {
    var custom: Bool?
    var fulfillment_service: String?
    var grams: Int?
    var id: Int?
    var price: String?
    var product_id: Int?
    var quantity: Int?
    var requires_shipping: Bool?
    var sku: String?
    var title: String?
    var variant_id: Int?
    var variant_title: String?
    var vendor: String?
    var name: String?
    var gift_card: Bool?
    var properties: [Property]?
    var taxable: Bool?
    var tax_lines: [TaxLine]?
    var applied_discount: AppliedDiscount?
    var admin_graphql_api_id: String?
    var maxAvailableQuantity: Int? = nil
}

struct Property: Codable {
    var name: String?
    var value: String?
}

struct TaxLine: Codable {
    var title: String?
    var rate: Double?
    var price: String?
}

struct AppliedDiscount: Codable {
    var title: String?
    var description: String?
    var value: String?
    var value_type: String?
    var amount: String?
}


struct ShippingLine: Codable {
    var handle: String?
    var price: String?
    var title: String?
}

