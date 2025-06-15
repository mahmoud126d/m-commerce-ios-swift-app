//
//  CartViewModel.swift
//  Shoplet
//
//  Created by Macos on 11/06/2025.
//

import Foundation

class CartViewModel : ObservableObject{
    private var draftOrderUseCase : DraftOrderUseCase
    private var priceRuleUseCase : PriceRulesUseCase
    private var userDefault = UserDefaultManager.shared
    @Published var draftOrder : DraftOrder?
    @Published var subTotal : String?
    @Published var tax: String?
    @Published var total: String?
    @Published var selectedPriceRule: PriceRule?
    @Published var discountValue: String?
    
    init(repo :ProductRepository = ProductRepositoryImpl()) {
        self.draftOrderUseCase = DraftOrderUseCase(repo: repo)
        self.priceRuleUseCase = PriceRulesUseCase(repo: repo)
    }
    
    func getDraftOrderById(){
        if userDefault.hasDraftOrder == true{
            draftOrderUseCase.getById(dtaftOrderId: userDefault.draftOrderId) { [weak self] res in
                DispatchQueue.main.async {
                    switch res{
                    case .success(let draftOrder):
                        self?.draftOrder = draftOrder
                        self?.subTotal = draftOrder.subtotal_price
                        self?.tax = draftOrder.total_tax
                        self?.total = draftOrder.total_price
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
        draftOrderUseCase.update(draftOrder: draftOrderItem, dtaftOrderId: userDefault.draftOrderId) {[weak self] res in
            DispatchQueue.main.async {
                switch res {
                case .success(let draftOrder):
                    print("updated \(String(describing: draftOrder.id))")
                    self?.userDefault.cartItems = draftOrder.line_items?.count ?? 0
                    self?.subTotal = draftOrder.subtotal_price
                    self?.tax = draftOrder.total_tax
                    self?.total = draftOrder.total_price
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
            self.userDefault.cartItems =  0
            self.getDraftOrderById()
        }
    }
    
    func applayDiscount(priceRule: PriceRule){
        let rawValue = priceRule.value ?? "0"
        let cleanedValue = rawValue.replacingOccurrences(of: "-", with: "")

        let amount = calculateDiscountAmount(value: cleanedValue, type: priceRule.value_type)

        let applied_discount = AppliedDiscount(
            description: priceRule.title ?? "Discount",
            value: cleanedValue,
            value_type: priceRule.value_type ?? "percentage",
            amount: amount
        )

        draftOrder?.applied_discount = applied_discount
        print(applied_discount)
        let draftOrderItem = DraftOrderItem(draft_order: draftOrder)
        updateDraftOrder(draftOrderItem: draftOrderItem)
    }
    func calculateDiscountAmount(value: String, type: String?) -> String {
        guard let value = Double(value),
              let subtotalStr = draftOrder?.subtotal_price,
              let subtotal = Double(subtotalStr) else {
            return "0.00"
        }

        let discountAmount: Double
        if type == "percentage" {
            discountAmount = subtotal * (value / 100)
        } else if type == "fixed_amount" {
            discountAmount = value
        } else {
            discountAmount = 0.0
        }

        return String(format: "%.2f", discountAmount)
    }

    func getPriceRuleById(){
        guard let priceRuleId = userDefault.priceRuleId else {return}
        priceRuleUseCase.getPriceRulesById(priceRuleId: priceRuleId) {[weak self] res in
            switch res{
            case .success(let priceRule):
                DispatchQueue.main.async{
                    self?.selectedPriceRule = priceRule
                    self?.discountValue = priceRule.value
                    self?.applayDiscount(priceRule: priceRule)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
