//
//  ProductRepositoryImpl.swift
//  Shoplet
//
//  Created by Macos on 04/06/2025.
//

import Foundation

final class ProductRepositoryImpl: ProductRepository {
    
    func getProductById(_ id: String, completion: @escaping (Result<ProductModel, Error>) -> Void) {
        APIClient.getProductsByIds(ids: [id]) { result in
            switch result {
            case .success(let response):
                if let product = response.products.first {
                    completion(.success(product))
                } else {
                    completion(.failure(NetworkError.invalidResponse))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getAllProducts(completion: @escaping (Result<[ProductModel], Error>) -> Void) {
        APIClient.getProducts { result in
            switch result {
            case .success(let response):
                completion(.success(response.products))   
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    func getAllBrands(completion: @escaping (Result<[SmartCollection], Error>) -> Void) {
           APIClient.getBrands { result in
               switch result {
               case .success(let response):
                   if let brands = response.smart_collections {
                       completion(.success(brands))
                   } else {
                       completion(.failure(NetworkError.invalidResponse))
                   }
               case .failure(let error):
                   completion(.failure(error))
               }
           }
       }

       func getBestSellers(completion: @escaping (Result<[ProductModel], Error>) -> Void) {
           APIClient.getPopularProducts { result in
               switch result {
               case .success(let response):
                   if response.products.isEmpty {
                       completion(.failure(NetworkError.invalidResponse))
                   } else {
                       completion(.success(response.products))
                   }
               case .failure(let error):
                   completion(.failure(error))
               }
           }
       }
    func getPriceRules(completion: @escaping (Result<[PriceRule], NetworkError>) -> Void) {
        APIClient.getPriceRules { res in
            switch res{
            case .success(let res):
                completion(.success(res.price_rules))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    func getCoupons(id: Int, completion: @escaping (Result<[Coupon], NetworkError>) -> Void) {
        APIClient.getCoupons(id: id){
            res in
            switch res{
            case .success(let res):
                completion(.success(res.discount_codes))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
