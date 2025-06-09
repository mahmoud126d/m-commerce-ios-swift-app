//
//  HomeRepositoryImpl.swift
//  Shoplet
//
//  Created by Farid on 09/06/2025.
//

import Foundation
class HomeRepositoryImpl: HomeRepository {
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

       func getBestSellers(completion: @escaping (Result<[PopularProductItem], Error>) -> Void) {
           APIClient.getPopularProducts { result in
               switch result {
               case .success(let response):
                   if let products = response.products {
                       completion(.success(products))
                   } else {
                       completion(.failure(NetworkError.invalidResponse))
                   }
               case .failure(let error):
                   completion(.failure(error))
               }
           }
       }
}
