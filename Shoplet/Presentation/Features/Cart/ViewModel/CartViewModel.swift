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
            draftOrderUseCase.getById(dtaftOrderId: userDefault.draftOrderId) { [weak self] res in
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
    func updateLineItemQuantity(lineItem : LineItem){
        
        if lineItem.quantity ?? 1 < 1{
            draftOrder?.line_items?.removeAll(where: {$0.product_id == lineItem.product_id})
        }
        if draftOrder?.line_items?.count == 0{
            deleteDraftOrder()
        }
        else{
            let draftOrderItem = DraftOrderItem(draft_order: draftOrder)
            updateDraftOrder(draftOrderItem: draftOrderItem)
        }
    }
    
    func deleteItemLine(lineItem : LineItem){
        draftOrder?.line_items?.removeAll(where: {
            $0.product_id == lineItem.product_id &&
           ( $0.properties?[0].value == lineItem.properties?[0].value ||
             $0.properties?[2].value == lineItem.properties?[2].value)
            
        })
        if draftOrder?.line_items?.count == 0{
            deleteDraftOrder()
        }
        else{
            let draftOrderItem = DraftOrderItem(draft_order: draftOrder)
            updateDraftOrder(draftOrderItem: draftOrderItem)
        }
    }
    
    
    func updateDraftOrder(draftOrderItem : DraftOrderItem){
        draftOrderUseCase.update(draftOrder: draftOrderItem, dtaftOrderId: userDefault.draftOrderId) { res in
            DispatchQueue.main.async {
                switch res {
                case .success(let draftOrder):
                    print("updated \(String(describing: draftOrder.id))")
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    func deleteDraftOrder(){
        draftOrderUseCase.delete(dtaftOrderId: userDefault.draftOrderId) {
            print("deleted")
            self.userDefault.hasDraftOrder = false
            self.userDefault.draftOrderId = 0
        }
    }
}
