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
    static func getPriceRules(completion: @escaping (Result<PriceRuleResponse, NetworkError>) -> Void)
    static func getCoupons(id: Int, completion: @escaping (Result<CouponResponse, NetworkError>) -> Void)
    //add yours and implement it
   
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

    static func getProducts(completion: @escaping (Result<ProductResponse, NetworkError>) -> Void) {
        performRequest(route: .getProducts, completion: completion)
    }

    static func getProductsByIds(ids: [String], completion: @escaping (Result<ProductResponse, NetworkError>) -> Void) {
        performRequest(route: .getProductsByIds(ids: ids), completion: completion)
    }

    static func getPriceRules(completion: @escaping (Result<PriceRuleResponse, NetworkError>) -> Void){
        performRequest(route: .priceRules, completion: completion)
    }
    static func getCoupons(id: Int, completion: @escaping (Result<CouponResponse, NetworkError>) -> Void) {
        performRequest(route: .coupons(id: id), completion: completion)
    }
}

