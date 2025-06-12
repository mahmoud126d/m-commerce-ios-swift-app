//
//  CartViewModel.swift
//  Shoplet
//
//  Created by Macos on 11/06/2025.
//

import Foundation

class CartViewModel : ObservableObject{
    private var draftOrderUseCase : DraftOrderUseCase
    private var userDefault = UserDefaultManager.shared
    @Published var draftOrder : DraftOrder?
    init(repo :ProductRepository = ProductRepositoryImpl()) {
        self.draftOrderUseCase = DraftOrderUseCase(repo: repo)
    }
    
    func getDraftOrderById(){
        if userDefault.hasDraftOrder == true{
            draftOrderUseCase.getById(dtaftOrderId: userDefault.draftOrderId) { [weak self]res in
                DispatchQueue.main.async {
                    switch res{
                    case .success(let draftOrder):
                        self?.draftOrder = draftOrder
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }else{
            self.draftOrder = nil
        }
    }
}
