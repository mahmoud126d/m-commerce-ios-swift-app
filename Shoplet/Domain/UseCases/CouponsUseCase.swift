//
//  CouponsUseCase.swift
//  Shoplet
//
//  Created by Macos on 08/06/2025.
//

import Foundation

class CouponsUseCase{
    private let repo : ProductRepository
    
    init(repo: ProductRepository) {
        self.repo = repo
    }
    
    func excute(id: Int, completion: @escaping (Result<[Coupon] , NetworkError>)-> Void){
        repo.getCoupons(id: id, completion: completion)
    }
}
