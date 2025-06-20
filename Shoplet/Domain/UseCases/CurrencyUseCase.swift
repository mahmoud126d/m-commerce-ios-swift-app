//
//  CurrencyUseCase.swift
//  Shoplet
//
//  Created by Macos on 20/06/2025.
//

import Foundation

class CurrencyUseCase{
    private let repo: CurrencyRepository
    init(repo: CurrencyRepository) {
        self.repo = repo
    }
    func excute(completion: @escaping(Result<CurrencyExChange, NetworkError>)->Void){
        repo.getCurrencies(completion: completion)
    }
}
