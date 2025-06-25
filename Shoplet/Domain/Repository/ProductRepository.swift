//
//  ProductRepository.swift
//  Shoplet
//
//  Created by Macos on 04/06/2025.
//

import Foundation

protocol ProductRepository {
    func getProductById(_ id: String, completion: @escaping (Result<ProductModel, Error>) -> Void)
    func getAllProducts(completion: @escaping (Result<[ProductModel], Error>) -> Void)
    func getAllBrands(completion: @escaping (Result<[SmartCollection], Error>) -> Void)
    func getBestSellers(completion: @escaping (Result<[ProductModel], Error>) -> Void)
    func getPriceRules(completion: @escaping (Result<[PriceRule], NetworkError>) -> Void)
     func getPriceRulesById(priceRuleId:Int, completion: @escaping (Result<PriceRule, NetworkError>) -> Void)
    func getCoupons(id: Int, completion: @escaping (Result<[Coupon], NetworkError>) -> Void)
    func createDraftOrder(draftOrder:DraftOrderItem,completion: @escaping (Result<DraftOrder, NetworkError>) -> Void)
    func updateDraftOrder(draftOrder : DraftOrderItem, dtaftOrderId: Int, completion: @escaping (Result<DraftOrder, NetworkError>) -> Void)
    func  getDraftOrderById(dtaftOrderId: Int, completion: @escaping (Result<DraftOrder, NetworkError>) -> Void)
     func deleteDraftOrder(dtaftOrderId: Int, completion: @escaping () -> Void)
     func getDraftOrders(completion: @escaping (Result<[DraftOrder], NetworkError>) -> Void)
    func completeOrder(draftOrderId: Int, completion: @escaping(Result<DraftOrderItem, NetworkError>)->Void)
   // func getOrdersForCustomer(customerId: Int, completion: @escaping (Result<[ShopifyOrder], Error>) -> Void)
   // func getOrdersForCustomer(customerId: Int, completion: @escaping (Result<[ShopifyOrder], Error>) -> Void)
}
