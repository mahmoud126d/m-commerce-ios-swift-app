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
    private var getCustomerUseCase: GetCustomerByIdUseCase
    private var userDefault = UserDefaultManager.shared
    @Published var draftOrder : DraftOrder?
    @Published var subTotal : String?
    @Published var tax: String?
    @Published var total: String?
    @Published var selectedPriceRule: PriceRule?
    @Published var discountValue: String?
    @Published var shippingAddress: AddressDetails?
    @Published var address: AddressDetails?

    init(repo :ProductRepository = ProductRepositoryImpl(), cusRepo: CustomerRepository = CustomerRepositoryImpl()) {
        self.draftOrderUseCase = DraftOrderUseCase(repo: repo)
        self.priceRuleUseCase = PriceRulesUseCase(repo: repo)
        self.getCustomerUseCase = DefaultGetCustomerByIdUseCase(repository: cusRepo)
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
                        self?.shippingAddress = draftOrder.shipping_address

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
            self.userDefault.isNotDefaultAddress = false
            self.getDraftOrderById()
        }
    }
    
    func applayDiscount(priceRule: PriceRule){
        let rawValue = priceRule.value 
        let cleanedValue = rawValue.replacingOccurrences(of: "-", with: "")

        let amount = calculateDiscountAmount(value: cleanedValue, type: priceRule.value_type)

        let applied_discount = AppliedDiscount(
            description: priceRule.title ?? "Discount",
            value: cleanedValue,
            value_type: priceRule.value_type ,
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
    func updateDraftOrderShippingAddressDefaultAddress(){
        draftOrder?.shipping_address = shippingAddress
        let draftOrderIttem = DraftOrderItem(draft_order: draftOrder)
        updateDraftOrder(draftOrderItem: draftOrderIttem)
        
    }
  
    func getCustomerShippingAddress(){
        getCustomerUseCase.execute(id: userDefault.customerId ?? -1) { [weak self] res in
            switch res{
            case .success(let customer):
                let customerDefaultAddress = customer.customer?.default_address
                
                let shipping_address = AddressDetails(id: customerDefaultAddress?.id, customer_id: customerDefaultAddress?.customer_id, first_name: customerDefaultAddress?.first_name, last_name: customerDefaultAddress?.last_name, company: customerDefaultAddress?.company, address1: customerDefaultAddress?.address1, address2: customerDefaultAddress?.address2, city: customerDefaultAddress?.city, province: customerDefaultAddress?.province, country: customerDefaultAddress?.country, zip: customerDefaultAddress?.zip, phone: customerDefaultAddress?.phone, name: customerDefaultAddress?.name, province_code: customerDefaultAddress?.province_code, country_code: customerDefaultAddress?.country_code, country_name: customerDefaultAddress?.country_name, default: customerDefaultAddress?.default)
                    
                                self?.shippingAddress = shipping_address
                self?.address = self?.shippingAddress
                                self?.draftOrder?.shipping_address = shipping_address
                                    /*let draftOrderItem = DraftOrderItem(draft_order: self?.draftOrder)
                                    self?.updateDraftOrder(draftOrderItem: draftOrderItem)*/
                                
                print(self?.shippingAddress as Any)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    func updateShipingAddress(address: AddressDetails){
        draftOrder?.shipping_address = address
        let draftOrderItem = DraftOrderItem(draft_order: draftOrder)
        draftOrderUseCase.update(draftOrder: draftOrderItem, dtaftOrderId: userDefault.draftOrderId) {[weak self]res in
            DispatchQueue.main.async {
                switch res {
                case .success(let draftOrder):
                    print("updated \(String(describing: draftOrder.id))")
                    self?.userDefault.isNotDefaultAddress = true
                    self?.getDraftOrderById()
                case .failure(let error):
                    print(error)
                }
            }
        }
        
    }
    func completeOrder(){
        draftOrderUseCase.completeOrder(draftOrderId: userDefault.draftOrderId) { [weak self] res in
            switch res{
            case .success(let draft_order):
                DispatchQueue.main.async{
                    print("completed \(draft_order.draft_order?.id)")
                    
                    self?.deleteDraftOrder()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
