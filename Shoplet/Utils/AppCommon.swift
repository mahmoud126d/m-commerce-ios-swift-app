//
//  AppCommon.swift
//  Shoplet
//
//  Created by Macos on 04/06/2025.
//

import Foundation
import Reachability

class AppCommon {
    static let shared = AppCommon()
    
    private let reachability: Reachability?
    
    private init() {
        reachability = try? Reachability()
        try? reachability?.startNotifier()
    }
    
    func isNetworkReachable() -> Bool {
        return reachability?.connection != .unavailable
    }
}


