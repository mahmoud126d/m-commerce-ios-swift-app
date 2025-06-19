//
//  CitiesUseCase.swift
//  Shoplet
//
//  Created by Macos on 19/06/2025.
//

import Foundation

class CitiesUseCase{
    let repo: AddressesRepository
    
    init(repo: AddressesRepository) {
        self.repo = repo
    }
    
    func excute(completion: @escaping(Result<Cities, NetworkError>)->Void){
        repo.getEgyptCities(completion: completion)
    }
}
