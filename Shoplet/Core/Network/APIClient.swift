//
//  APIClient.swift
//  Shoplet
//
//  Created by Macos on 04/06/2025.
//

import Foundation
import Alamofire

struct Empty: Codable {}

protocol APIClientType {
    static func getProducts(completion: @escaping (Result<ProductResponse, NetworkError>) -> Void)
    static func getProductsByIds(ids: [String], completion: @escaping (Result<ProductResponse, NetworkError>) -> Void)
    static func getPopularProducts(completion: @escaping (Result<ProductResponse, NetworkError>) -> Void)
       
       static func getBrands(completion: @escaping (Result<BrandsResponse, NetworkError>) -> Void)
    static func getPriceRules(completion: @escaping (Result<PriceRuleResponse, NetworkError>) -> Void)
    static func getPriceRulesById(priceRuleId:Int, completion: @escaping (Result<SinglePriceRuleResponse, NetworkError>) -> Void)
    static func getCoupons(id: Int, completion: @escaping (Result<CouponResponse, NetworkError>) -> Void)
    static func createDraftOrder(draftOrder:DraftOrderItem,completion: @escaping (Result<DraftOrderItem, NetworkError>) -> Void)
    static func updateDraftOrder(draftOrder : DraftOrderItem, dtaftOrderId: Int, completion: @escaping (Result<DraftOrderItem, NetworkError>) -> Void)
    static func getDraftOrderById(dtaftOrderId: Int, completion: @escaping (Result<DraftOrderItem, NetworkError>) -> Void)
    static func getDraftOrders(completion: @escaping (Result<DraftOrdersResponse, NetworkError>) -> Void)
    static func deleteDraftOrder(dtaftOrderId: Int, completion: @escaping (Result<EmptyResponse, NetworkError>) -> Void)
    static func createCustomer(customer: CustomerRequest, completion: @escaping (Result<CustomerAuthResponse, NetworkError>) -> Void)
    static func getCustomerById(id: Int, completion: @escaping (Result<CustomerAuthResponse, NetworkError>) -> Void)
    static func getAllCustomers(completion: @escaping (Result<CustomerListResponse, NetworkError>) -> Void)
    static func updateCustomer(customerId: Int, customer: CustomerRequest, completion: @escaping (Result<CustomerAuthResponse, NetworkError>)->Void)
    static func createAddress(address: AddressRequest,customerId: Int, completion: @escaping (Result<AddressRequest, NetworkError>) -> Void)
    static func getUserAddresses(customerId: Int, completion: @escaping (Result<AddressResponse, NetworkError>) -> Void)
    static func markAddresseDefault(customerId: Int, addressId:Int, completion: @escaping (Result<AddressRequest, NetworkError>) -> Void)
    static func deleteAddresse(customerId: Int, addressId:Int, completion: @escaping (Result<EmptyResponse, NetworkError>) -> Void)
    static func getEgyptCities(completion: @escaping(Result<Cities, NetworkError>)->Void)
    static func getCurrencies(completion: @escaping(Result<CurrencyExChange, NetworkError>)->Void)
    static func completeOrder(draftOrderId: Int, completion: @escaping(Result<DraftOrderItem, NetworkError>)->Void)

}

class APIClient: APIClientType {

    private static func performRequest<T: Decodable>(route: APIRouter, completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard AppCommon.shared.isNetworkReachable() else {
            completion(.failure(.networkUnreachable))
            return
        }
        
        do {
            let urlRequest = try route.asURLRequest()
            print("URL: \(urlRequest.url?.absoluteString ?? "Invalid URL")")
        } catch {
            print("Error creating URLRequest: \(error)")
        }
        
        AF.request(route).validate()
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let model):
                    completion(.success(model))
                case .failure(let error):
                    print("Request failed: \(error.localizedDescription)")
                    if let data = response.data,
                       let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       json["Message"] != nil {
                        completion(.failure(.decodingError))
                    } else {
                        completion(.failure(.serverError(error.localizedDescription)))
                    }
                }
            }
    }
    static func getEgyptCities(completion: @escaping(Result<Cities, NetworkError>)->Void)
    {
        guard AppCommon.shared.isNetworkReachable() else {
            completion(.failure(.networkUnreachable))
            return
        }
        let url = "https://countriesnow.space/api/v0.1/countries/cities"
            
            let parameters: [String: Any] = [
                "country": "Egypt"
            ]
            
            AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .validate()
                .responseDecodable(of: Cities.self) { response in
                    switch response.result {
                    case .success(let result):
                        completion(.success(result))
                    case .failure(let error):
                        completion(.failure(.serverError(error.localizedDescription)))
                    }
                }
    }

    static func getProducts(completion: @escaping (Result<ProductResponse, NetworkError>) -> Void) {
        performRequest(route: .getProducts, completion: completion)
    }

    static func getProductsByIds(ids: [String], completion: @escaping (Result<ProductResponse, NetworkError>) -> Void) {
        performRequest(route: .getProductsByIds(ids: ids), completion: completion)
    }

    static func getPopularProducts(completion: @escaping (Result<ProductResponse, NetworkError>) -> Void) {
        performRequest(route: .getPopularProducts, completion: completion)
    }
    
    static func getBrands(completion: @escaping (Result<BrandsResponse, NetworkError>) -> Void) {
        performRequest(route: .getBrands, completion: completion)
    }
    static func getPriceRules(completion: @escaping (Result<PriceRuleResponse, NetworkError>) -> Void){
        performRequest(route: .priceRules, completion: completion)
    }
    static func getCoupons(id: Int, completion: @escaping (Result<CouponResponse, NetworkError>) -> Void) {
        performRequest(route: .coupons(id: id), completion: completion)
    }
    static func createDraftOrder(draftOrder:DraftOrderItem,completion: @escaping (Result<DraftOrderItem, NetworkError>) -> Void){
        performRequest(route: .createDraftOrder(draftOrder: draftOrder), completion: completion)
    }
    static func updateDraftOrder(draftOrder : DraftOrderItem, dtaftOrderId: Int, completion: @escaping (Result<DraftOrderItem, NetworkError>) -> Void){
        performRequest(route: .updateDraftOrder(draftOrder: draftOrder, dtaftOrderId: dtaftOrderId), completion: completion)
    }
    static func getDraftOrderById(dtaftOrderId: Int, completion: @escaping (Result<DraftOrderItem, NetworkError>) -> Void){
        performRequest(route: .getDraftOrderById(draftOrderId: dtaftOrderId), completion: completion)
    }
    static func deleteDraftOrder(dtaftOrderId: Int, completion: @escaping (Result<EmptyResponse, NetworkError>) -> Void)
    {
        performRequest(route: .deleteDraftOrder(draftOrderId: dtaftOrderId), completion:completion )
    }
    static func createCustomer(customer: CustomerRequest, completion: @escaping (Result<CustomerAuthResponse, NetworkError>) -> Void) {
        performRequest(route: .createCustomer(customer: customer), completion: completion)
    }
    static func getCustomerById(id: Int, completion: @escaping (Result<CustomerAuthResponse, NetworkError>) -> Void) {
        performRequest(route: .getCustomerById(id: id), completion: completion)
    }
    
    static func getAllCustomers(completion: @escaping (Result<CustomerListResponse, NetworkError>) -> Void) {
        performRequest(route: .getAllCustomers, completion: completion)
    }
    static func getPriceRulesById(priceRuleId:Int, completion: @escaping (Result<SinglePriceRuleResponse, NetworkError>) -> Void){
        performRequest(route: .getPriceRule(priceRule: priceRuleId), completion: completion)
    }
    static func getDraftOrders(completion: @escaping (Result<DraftOrdersResponse, NetworkError>) -> Void)
    {
        performRequest(route: .getAllDraftOrders, completion: completion)
    }
    static func updateCustomer(customerId: Int, customer: CustomerRequest, completion: @escaping (Result<CustomerAuthResponse, NetworkError>)->Void){
        performRequest(route: .updateCustomer(customer: customer, customerId: customerId), completion: completion)
    }
    static func createAddress(address: AddressRequest,customerId: Int, completion: @escaping (Result<AddressRequest, NetworkError>) -> Void){
        performRequest(route: .createAddress(address: address, customerId: customerId), completion: completion)
    }
    static func getUserAddresses(customerId: Int, completion: @escaping (Result<AddressResponse, NetworkError>) -> Void){
        performRequest(route: .getuserAddresses(customerId: customerId), completion: completion)
    }
    static func markAddresseDefault(customerId: Int, addressId:Int, completion: @escaping (Result<AddressRequest, NetworkError>) -> Void){
        performRequest(route: .markAddressDefault(customerId: customerId, addressId: addressId), completion: completion)
    }
    static func deleteAddresse(customerId: Int, addressId:Int, completion: @escaping (Result<EmptyResponse, NetworkError>) -> Void){
        performRequest(route: .deleteAddress(customerId: customerId, addressId: addressId), completion: completion)
    }
    static func getCurrencies(completion: @escaping(Result<CurrencyExChange, NetworkError>)->Void)
    {
        let url = "https://api.currencyfreaks.com/latest?apikey=\(Support.currencyApikey)"

                AF.request(url)
                    .validate()
                    .responseDecodable(of: CurrencyExChange.self) { response in
                        switch response.result {
                        case .success(let res):
                            completion(.success(res))
                        case .failure(let error):
                            completion(.failure(.serverError(error.localizedDescription)))
                        }
                    }
    }
    static func completeOrder(draftOrderId: Int, completion: @escaping(Result<DraftOrderItem, NetworkError>)->Void)
    {
        performRequest(route: .completeOrder(draftOrderId: draftOrderId), completion: completion)
    }
}

