//
//  CurrencyRepositoryImpl.swift
//  Shoplet
//
//  Created by Macos on 20/06/2025.
//

import Foundation

class CurrencyRepositoryImpl: CurrencyRepository{
    func getCurrencies(completion: @escaping(Result<CurrencyExChange, NetworkError>)->Void){
        APIClient.getCurrencies(completion: completion)
    }
}
