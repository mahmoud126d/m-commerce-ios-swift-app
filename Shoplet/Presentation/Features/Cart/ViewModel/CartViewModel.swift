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
    private var ordersUseCase: GetCustomerOrdersUseCase
    private var copunsUseCase: CouponsUseCase
    private var userDefault = UserDefaultManager.shared
    @Published var draftOrder : DraftOrder?
    @Published var subTotal : String?
    @Published var cartSubTotal : String?
    @Published var tax: String?
    @Published var total: String?
    @Published var selectedPriceRule: PriceRule?
    @Published var discountValue: String?
    @Published var shippingAddress: AddressDetails?
    @Published var address: AddressDetails?
    @Published var allPriceRules: [PriceRule]?
    @Published var isOrderFinishCompleted: Bool = true
    private var isCopunsPerCustomer: Bool?

    init(repo :ProductRepository = ProductRepositoryImpl(), cusRepo: CustomerRepository = CustomerRepositoryImpl(), orderRepo: OrdersRepository = OrdersRepositoryImpl()) {
        self.draftOrderUseCase = DraftOrderUseCase(repo: repo)
        self.priceRuleUseCase = PriceRulesUseCase(repo: repo)
        self.copunsUseCase = CouponsUseCase(repo: repo)
        self.getCustomerUseCase = DefaultGetCustomerByIdUseCase(repository: cusRepo)
        self.ordersUseCase = DefaultGetCustomerOrdersUseCase(repository: orderRepo)
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
           ( $0.properties?[0].value == lineItem.properties?[0].value &&
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
                    self?.draftOrder = draftOrder
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
            self.userDefault.isUsedACopuns = false
            self.getDraftOrderById()
        }
    }
    
    func applayDiscount(discount: String){
        let rawValue = selectedPriceRule?.value
        let cleanedValue = rawValue?.replacingOccurrences(of: "-", with: "")

        let amount = calculateDiscountAmount(value: cleanedValue ?? "0.0", type: selectedPriceRule?.value_type)

        let applied_discount = AppliedDiscount(
            title: discount,
            description: selectedPriceRule?.title ?? "Discount",
            value: cleanedValue,
            value_type: selectedPriceRule?.value_type ,
            amount: amount
        )
        print("discount \(discount)")

        draftOrder?.applied_discount = applied_discount
        print(applied_discount)
        let draftOrderItem = DraftOrderItem(draft_order: draftOrder)
        updateDraftOrder(draftOrderItem: draftOrderItem)
    }
    
    
    func validateDiscount(discount: String, completion: @escaping (Bool) -> Void) {
        guard let priceRules = allPriceRules, !priceRules.isEmpty else {
            completion(false)
            return
        }

        let group = DispatchGroup()
        var isFound = false

        for priceRule in priceRules {
            group.enter()
            copunsUseCase.excute(id: priceRule.id) { res in
                defer { group.leave() }

                switch res {
                case .success(let coupons):
                    if coupons.contains(where: { $0.code == discount }) {
                        if !isFound {
                            isFound = true
                            self.selectedPriceRule = priceRule
                            self.discountValue = priceRule.value
                            self.isCopunsPerCustomer = priceRule.once_per_customer
                            completion(true)
                        }
                    }
                case .failure:
                    break
                }
            }
        }

        group.notify(queue: .main) {
            if !isFound {
                completion(false)
            }
        }
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

  
    
    func getAllPriceRules(){
        priceRuleUseCase.repo.getPriceRules {[weak self] res in
            switch res{
            case .success(let priceRules):
                self?.allPriceRules = priceRules
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
        isOrderFinishCompleted = false
        draftOrderUseCase.completeOrder(draftOrderId: userDefault.draftOrderId) { [weak self] res in
            switch res{
            case .success(let draft_order):
                DispatchQueue.main.async{
                    self?.isOrderFinishCompleted = true
                    print("completed \(draft_order.draft_order?.id)")
                    
                    self?.deleteDraftOrder()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    func calcCartSubTotal()->Double{
            guard let items = draftOrder?.line_items else { return 0 }

            var total: Double = 0

            for item in items {
                let price = Double(item.price ?? "0") ?? 0
                let quantity = Double(item.quantity ?? 0)
                total += price * quantity
            }

            return total
    }
    
    func checkCouponsUsedLater(copuns: String, completion: @escaping (Bool) -> Void) {
        ordersUseCase.execute(customerId: userDefault.customerId ?? -1) { res in
            switch res {
            case .success(let orders):
                for order in orders {
                    if order.discount_codes.contains(where: { $0.code == copuns }) {
                        completion(true)
                        return
                    }
                }
                completion(false)

            case .failure(let error):
                print(error.localizedDescription)
                completion(false)
            }
        }
    }

}
