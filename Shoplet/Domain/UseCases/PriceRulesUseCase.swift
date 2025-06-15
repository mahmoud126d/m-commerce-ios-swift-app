//
//  PriceRulesUseCase.swift
//  Shoplet
//
//  Created by Macos on 08/06/2025.
//

import Foundation

class PriceRulesUseCase{
    
    let repo : ProductRepository
    
    init(repo: ProductRepository) {
        self.repo = repo
    }
    
    func execute(completion: @escaping (Result<[PriceRule], NetworkError>) -> Void) {
        repo.getPriceRules(completion: completion)
    }
    
    func getPriceRulesById(priceRuleId:Int, completion: @escaping (Result<PriceRule, NetworkError>) -> Void)
    {
        repo.getPriceRulesById(priceRuleId: priceRuleId, completion: completion)
    }
}
