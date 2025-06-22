//
//  DraftOrderUseCase.swift
//  Shoplet
//
//  Created by Macos on 11/06/2025.
//

import Foundation

class DraftOrderUseCase{
    var repo : ProductRepository
    
    init(repo: ProductRepository) {
        self.repo = repo
    }
    
    func create(draftOrder:DraftOrderItem,completion: @escaping (Result<DraftOrder, NetworkError>) -> Void){
        repo.createDraftOrder(draftOrder: draftOrder, completion: completion)
    }
    func update(draftOrder : DraftOrderItem, dtaftOrderId: Int, completion: @escaping (Result<DraftOrder, NetworkError>) -> Void){
        repo.updateDraftOrder(draftOrder: draftOrder, dtaftOrderId: dtaftOrderId, completion: completion)
    }
    func getById(dtaftOrderId: Int, completion: @escaping (Result<DraftOrder, NetworkError>) -> Void){
        repo.getDraftOrderById(dtaftOrderId: dtaftOrderId, completion: completion)
    }
    func delete(dtaftOrderId: Int, completion: @escaping () -> Void){
        repo.deleteDraftOrder(dtaftOrderId: dtaftOrderId, completion: completion)
    }
    func getDraftOrders(completion: @escaping (Result<[DraftOrder], NetworkError>) -> Void)
    {
        repo.getDraftOrders(completion:completion)
    }
    func completeOrder(draftOrderId: Int, completion: @escaping(Result<DraftOrderItem, NetworkError>)->Void)
    {
        repo.completeOrder(draftOrderId: draftOrderId, completion: completion)
    }

}
