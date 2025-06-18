//
//  CoreDataManager.swift
//  Shoplet
//
//  Created by Macos on 18/06/2025.
//

import Foundation
import CoreData

import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()

    let persistentContainer: NSPersistentContainer
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    private init() {
        persistentContainer = NSPersistentContainer(name: "Shoplet")
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
    }

    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
                print("Context saved.")
            } catch {
                print("Failed to save context: \(error)")
            }
        }
    }

    func delete(_ object: NSManagedObject) {
        context.delete(object)
        saveContext()
    }
}
