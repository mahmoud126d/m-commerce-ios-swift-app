//
//  HomeRepository.swift
//  Shoplet
//
//  Created by Farid on 09/06/2025.
//

import Foundation
protocol HomeRepository {
    func getAllBrands(completion: @escaping (Result<[SmartCollection], Error>) -> Void)
    func getBestSellers(completion: @escaping (Result<[PopularProductItem], Error>) -> Void)
}
