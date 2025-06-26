//
//  UserDefaultManager.swift
//  Shoplet
//
//  Created by Macos on 11/06/2025.
//

import Foundation

class UserDefaultManager:ObservableObject{
    
    static let shared = UserDefaultManager()
    private init(){}
    
    var draftOrderId : Int {
        get{
            return UserDefaults.standard.integer(forKey: "draftOrderId")
        }
        set{
            UserDefaults.standard.setValue(newValue, forKey: "draftOrderId")
        }
    }
    var hasDraftOrder : Bool{
        get{
            return UserDefaults.standard.bool(forKey: "hasDraftOrder")
        }
        set{
            UserDefaults.standard.setValue(newValue, forKey: "hasDraftOrder")
        }
    }
    @Published var cartItems: Int = 0 {
            didSet {
                UserDefaults.standard.setValue(cartItems, forKey: "cartItems")
            }
        }

    func getNumOfCartItems()->Int{
            return UserDefaults.standard.integer(forKey: "cartItems")
        }
       
    var isUserLoggedIn: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "isUserLoggedIn")
        }
    }

    var customerId: Int? {
        get {
            let id = UserDefaults.standard.integer(forKey: "customerId")
            return id == 0 ? nil : id
        }
        set {
            if let newValue = newValue {
                UserDefaults.standard.setValue(newValue, forKey: "customerId")
            } else {
                UserDefaults.standard.removeObject(forKey: "customerId")
            }
        }
    }
    
    var priceRuleId: Int?{
        set{
            UserDefaults.standard.setValue(newValue, forKey: "priceRuleId")
        }
        get{
            UserDefaults.standard.integer(forKey: "priceRuleId")
        }
    }
    var isNotDefaultAddress: Bool?{
        get {
            return UserDefaults.standard.bool(forKey: "isNotDefaultAddress")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "isNotDefaultAddress")
        }
    }
    
    var currency:String?{
        set{
            UserDefaults.standard.setValue(newValue, forKey: "currency")
        }
        get{
            UserDefaults.standard.string(forKey: "currency")

        }
    }
    var currencyRate:String?{
        set{
            UserDefaults.standard.setValue(newValue, forKey: "currencyRate")
        }
        get{
            UserDefaults.standard.string(forKey: "currencyRate")

        }
    }
    
    func clearUserDefaults() {
            customerId = nil
            isUserLoggedIn = false
            hasDraftOrder = false
            draftOrderId = 0
            cartItems = 0
            priceRuleId = nil
            currency = nil
            currencyRate = nil
            isNotDefaultAddress = false
        }
}
