//
//  UserDefaultManager.swift
//  Shoplet
//
//  Created by Macos on 13/06/2025.
//

import Foundation

class UserDefaultManager {
    
    static let shared = UserDefaultManager()
    private init() {}

    // MARK: - Draft Order
    var draftOrderId: Int {
        get {
            return UserDefaults.standard.integer(forKey: "draftOrderId")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "draftOrderId")
        }
    }
    
    var hasDraftOrder: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "hasDraftOrder")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "hasDraftOrder")
        }
    }

    // MARK: - User Session
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
}
