//
//  ShopletApp.swift
//  Shoplet
//
//  Created by Macos on 04/06/2025.
//

import SwiftUI

@main
struct ShopletApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
