//
//  CouponViewModel.swift
//  Shoplet
//
//  Created by Macos on 08/06/2025.
//

import Foundation


class CouponViewModel : ObservableObject{
    let priceRuleUseCase : PriceRulesUseCase
    let couponUseCase : CouponsUseCase
    @Published var priceRules : [PriceRule] = []
    @Published var coupons :[Coupon] = []
    init(repository: ProductRepository = ProductRepositoryImpl()) {
        self.priceRuleUseCase = PriceRulesUseCase(repo: repository)
        self.couponUseCase = CouponsUseCase(repo: repository)
    }
    
    func getPriceRules(){
        priceRuleUseCase.execute{[weak self]
            res in
            DispatchQueue.main.async {
                switch res{
                case .success(let price):
                    print("Fetched price rules: \(price)")
                    self?.priceRules = price
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func getCoupons(id : Int){
        couponUseCase.excute(id: id){[weak self]
            res in
            DispatchQueue.main.async {
                switch res{
                case .success(let coupons):
                    self?.coupons = coupons
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
}
