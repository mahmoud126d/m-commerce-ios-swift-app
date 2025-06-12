//
//  UserDefaultManager.swift
//  Shoplet
//
//  Created by Macos on 11/06/2025.
//

import Foundation

class UserDefaultManager{
    
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
    
}
