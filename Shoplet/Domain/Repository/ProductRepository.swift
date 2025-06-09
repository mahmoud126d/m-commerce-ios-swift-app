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
}
