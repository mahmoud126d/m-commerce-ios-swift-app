//
//  FavoriteViewModel.swift
//  Shoplet
//
//  Created by Macos on 17/06/2025.
//

import Foundation
import CoreData
import SwiftUI

class FavoriteViewModel: ObservableObject {
    @Published var favoriteProducts: [CDProduct] = []

    private let context: NSManagedObjectContext
    private var userId: Int {
       UserDefaultManager.shared.customerId ?? 0
    }

    init(context: NSManagedObjectContext = CoreDataManager.shared.context) {
        self.context = context
        fetchFavorites()
    }

    // MARK: - Fetch Favorites
    func fetchFavorites() {
        let allRequest: NSFetchRequest<CDProduct> = CDProduct.fetchRequest()
        do {
            let allProducts = try context.fetch(allRequest)
            print("All products count: \(allProducts.count)")
            for product in allProducts {
                print("Product ID: \(product.productId), isFav: \(product.isFav), userId: \(product.userId), title: \(product.title ?? "")")
            }
        } catch {
            print("Failed to fetch all products: \(error)")
        }

        let request: NSFetchRequest<CDProduct> = CDProduct.fetchRequest()
        print("USERRRRRRRRRR \(userId)")
        request.predicate = NSPredicate(format: "userId == %lld AND isFav == true", userId)

        do {
            favoriteProducts = try context.fetch(request)
            print("Fetched \(favoriteProducts.count) favorite products")
            for fav in favoriteProducts {
                favoritesMap[Int(fav.productId)] = true
            }
        } catch {
            print("Failed to fetch favorites: \(error)")
        }
    }



    // MARK: - Check Favorite
    func isFavorite(productId: Int) -> Bool {
        let request: NSFetchRequest<CDProduct> = CDProduct.fetchRequest()
        request.predicate = NSPredicate(format: "productId == %lld AND userId == %lld AND isFav == true", productId, userId)
        return ((try? context.count(for: request)) ?? 0) > 0
    }

    // MARK: - Add Favorite
    func addToFavorites(product: ProductModel) {
        guard !isFavorite(productId: product.id ?? 0) else { return }

        let cdProduct = CDProduct(context: context)
        cdProduct.productId = Int64(product.id ?? 0)
        cdProduct.title = product.title
        cdProduct.bodyHTML = product.bodyHTML
        cdProduct.vendor = product.vendor
        cdProduct.productType = product.productType
        cdProduct.tags = product.tags
        cdProduct.status = product.status
        cdProduct.userId = Int64(userId)
        cdProduct.isFav = true

        product.images?.forEach { image in
            let cdImage = CDImage(context: context)
            cdImage.id = Int64(image.id)
            cdImage.src = image.src
            cdImage.position = Int64(image.position)
            cdImage.product = cdProduct
        }

        if let variant = product.variants?.first {
            let cdVariant = CDVariant(context: context)
            cdVariant.id = Int64(variant.id ?? 0)
            cdVariant.title = variant.title
            cdVariant.price = variant.price
            cdVariant.product = cdProduct
        }

        saveContext()
        print("Saving product with ID: \(cdProduct.productId), isFav: \(cdProduct.isFav), userId: \(cdProduct.userId)")
        fetchFavorites()
    }

    // MARK: - Remove Favorite
    func removeFromFavorites(productId: Int) {
        let request: NSFetchRequest<CDProduct> = CDProduct.fetchRequest()
        request.predicate = NSPredicate(format: "productId == %lld AND userId == %lld", productId, userId)
        
        do {
            if let product = try context.fetch(request).first {
                context.delete(product)
                try context.save()
                favoritesMap[productId] = false
                
                fetchFavorites()
            }
        } catch {
            print("Failed to remove favorite: \(error)")
        }
    }



    // MARK: - Toggle Favorite
    @Published var favoritesMap: [Int: Bool] = [:]

    func toggleFavorite(product: ProductModel) {
        let id = product.id ?? 0
        if isFavorite(productId: id) {
            removeFromFavorites(productId: id)
            favoritesMap[id] = false
        } else {
            addToFavorites(product: product)
            favoritesMap[id] = true
        }
    }

    // MARK: - Save Changes
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Failed to save Core Data context: \(error)")
        }
    }
}



