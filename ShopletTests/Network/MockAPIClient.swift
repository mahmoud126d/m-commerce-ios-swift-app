//
//  MockAPIClient.swift
//  ShopletTests
//
//  Created by Macos on 27/06/2025.
//

import Foundation
@testable import Shoplet

class MockAPIClient : APIClientType{
    static func getProducts(completion: @escaping (Result<Shoplet.ProductResponse, Shoplet.NetworkError>) -> Void) {
        
        let product = ProductModel(id: 1, title: "Mock Product", bodyHTML: nil, vendor: nil, productType: nil, tags: nil, status: nil, variants:nil, options: nil, images: nil, image: nil)
        let productRespone = ProductResponse(products: [product])
        completion(.success(productRespone))
    }
    
    static func getProductsByIds(ids: [String], completion: @escaping (Result<Shoplet.ProductResponse, Shoplet.NetworkError>) -> Void) {
        
    }
    
    static func getPopularProducts(completion: @escaping (Result<Shoplet.ProductResponse, Shoplet.NetworkError>) -> Void) {
        
    }
    
    static func getBrands(completion: @escaping (Result<Shoplet.BrandsResponse, Shoplet.NetworkError>) -> Void) {
        
    }
    
    static func getPriceRules(completion: @escaping (Result<Shoplet.PriceRuleResponse, Shoplet.NetworkError>) -> Void) {
        
    }
    
    static func getPriceRulesById(priceRuleId: Int, completion: @escaping (Result<Shoplet.SinglePriceRuleResponse, Shoplet.NetworkError>) -> Void) {
        
    }
    
    static func getCoupons(id: Int, completion: @escaping (Result<Shoplet.CouponResponse, Shoplet.NetworkError>) -> Void) {
        
    }
    
    static func createDraftOrder(draftOrder: Shoplet.DraftOrderItem, completion: @escaping (Result<Shoplet.DraftOrderItem, Shoplet.NetworkError>) -> Void) {
        
    }
    
    static func updateDraftOrder(draftOrder: Shoplet.DraftOrderItem, dtaftOrderId: Int, completion: @escaping (Result<Shoplet.DraftOrderItem, Shoplet.NetworkError>) -> Void) {
        
    }
    
    static func getDraftOrderById(dtaftOrderId: Int, completion: @escaping (Result<Shoplet.DraftOrderItem, Shoplet.NetworkError>) -> Void) {
        
    }
    
    static func getDraftOrders(completion: @escaping (Result<Shoplet.DraftOrdersResponse, Shoplet.NetworkError>) -> Void) {
        
    }
    
    static func deleteDraftOrder(dtaftOrderId: Int, completion: @escaping (Result<Shoplet.EmptyResponse, Shoplet.NetworkError>) -> Void) {
        
    }
    
    static func createCustomer(customer: Shoplet.CustomerRequest, completion: @escaping (Result<Shoplet.CustomerAuthResponse, Shoplet.NetworkError>) -> Void) {
        
    }
    
    static func getCustomerById(id: Int, completion: @escaping (Result<Shoplet.CustomerAuthResponse, Shoplet.NetworkError>) -> Void) {
        
    }
    
    static func getAllCustomers(completion: @escaping (Result<Shoplet.CustomerListResponse, Shoplet.NetworkError>) -> Void) {
        
    }
    
    static func updateCustomer(customerId: Int, customer: Shoplet.CustomerRequest, completion: @escaping (Result<Shoplet.CustomerAuthResponse, Shoplet.NetworkError>) -> Void) {
        
    }
    
    static func createAddress(address: Shoplet.AddressRequest, customerId: Int, completion: @escaping (Result<Shoplet.AddressRequest, Shoplet.NetworkError>) -> Void) {
        
    }
    
    static func getUserAddresses(customerId: Int, completion: @escaping (Result<Shoplet.AddressResponse, Shoplet.NetworkError>) -> Void) {
        
    }
    
    static func markAddresseDefault(customerId: Int, addressId: Int, completion: @escaping (Result<Shoplet.AddressRequest, Shoplet.NetworkError>) -> Void) {
        
    }
    
    static func deleteAddresse(customerId: Int, addressId: Int, completion: @escaping (Result<Shoplet.EmptyResponse, Shoplet.NetworkError>) -> Void) {
        
    }
    
    static func getEgyptCities(completion: @escaping (Result<Shoplet.Cities, Shoplet.NetworkError>) -> Void) {
        
    }
    
    static func getCurrencies(completion: @escaping (Result<Shoplet.CurrencyExChange, Shoplet.NetworkError>) -> Void) {
        
    }
    
    static func completeOrder(draftOrderId: Int, completion: @escaping (Result<Shoplet.DraftOrderItem, Shoplet.NetworkError>) -> Void) {
        
    }
    
    func fetchAllOrders(completion: @escaping (Result<[Shoplet.ShopifyOrder], Error>) -> Void) {
        
    }
    
    
}
