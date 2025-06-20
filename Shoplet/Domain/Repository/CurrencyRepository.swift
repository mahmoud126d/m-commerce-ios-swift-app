//
//  CurrencyRepository.swift
//  Shoplet
//
//  Created by Macos on 20/06/2025.
//

import Foundation

protocol CurrencyRepository{
    func getCurrencies(completion: @escaping(Result<CurrencyExChange, NetworkError>)->Void)
}
