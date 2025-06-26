import Foundation
import CoreData
import SwiftUI

class FavoriteViewModel: ObservableObject {
    @Published var favoriteProducts: [CDProduct] = []
    @Published var favoritesMap: [Int: Bool] = [:]

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
        if AppCommon.shared.isNetworkReachable() {
            print("Fetching from Firestore")
            FirestoreManager.shared.fetchFavorites(userId: userId) { [weak self] data in
                DispatchQueue.main.async {
                    self?.syncWithLocalStorage(firestoreData: data)
                }
            }
        } else {
            print("Fetching from CoreData")
            fetchFromCoreData()
        }
    }

    private func fetchFromCoreData() {
        let request: NSFetchRequest<CDProduct> = CDProduct.fetchRequest()
        request.predicate = NSPredicate(format: "userId == %lld AND isFav == true", userId)

        do {
            let results = try context.fetch(request)
            DispatchQueue.main.async {
                self.favoriteProducts = results
                let validProducts = results.filter { $0.productId != 0 }
                self.favoritesMap = Dictionary(
                    validProducts.map { (Int($0.productId), true) },
                    uniquingKeysWith: { first, _ in first }
                )            }
        } catch {
            print("Failed to fetch favorites from Core Data: \(error)")
        }
    }

    private func syncWithLocalStorage(firestoreData: [[String: Any]]) {
        let fetchRequest: NSFetchRequest<CDProduct> = CDProduct.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "userId == %lld AND isFav == true", userId)

        do {
            let oldFavorites = try context.fetch(fetchRequest)
            oldFavorites.forEach(context.delete)
        } catch {
            print("Failed to clear old CoreData favorites: \(error)")
        }

        firestoreData.forEach { dict in
            let cdProduct = CDProduct(context: context)
            cdProduct.productId = Int64(dict["productId"] as? Int ?? 0)
            cdProduct.title = dict["title"] as? String
            cdProduct.bodyHTML = dict["bodyHTML"] as? String
            cdProduct.vendor = dict["vendor"] as? String
            cdProduct.productType = dict["productType"] as? String
            cdProduct.tags = dict["tags"] as? String
            cdProduct.status = dict["status"] as? String
            cdProduct.userId = Int64(userId)
            cdProduct.isFav = true

            if let imageDicts = dict["images"] as? [[String: Any]] {
                for imageDict in imageDicts {
                    let image = CDImage(context: context)
                    image.id = Int64(imageDict["id"] as? Int ?? 0)
                    image.src = imageDict["src"] as? String
                    image.position = Int64(imageDict["position"] as? Int ?? 0)
                    image.product = cdProduct
                }
            }

            if let variant = dict["variant"] as? [String: Any] {
                let cdVariant = CDVariant(context: context)
                cdVariant.id = Int64(variant["id"] as? Int ?? 0)
                cdVariant.title = variant["title"] as? String
                cdVariant.price = variant["price"] as? String
                cdVariant.product = cdProduct
            }
        }

        saveContext()
        fetchFromCoreData()
    }

    // MARK: - Add Favorite
    func addToFavorites(product: ProductModel) {
        guard UserDefaultManager.shared.isUserLoggedIn else {
            print("User must be logged in to add favorites.")
            return
        }

        guard !isFavorite(productId: product.id ?? 0) else { return }

        FirestoreManager.shared.addFavorite(product: product, userId: userId) { [weak self] error in
            if let error = error {
                print("Firestore add failed: \(error)")
                return
            }
            self?.saveToCoreData(product: product)
        }
    }


    private func saveToCoreData(product: ProductModel) {
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
        fetchFromCoreData()
    }

    // MARK: - Remove Favorite
    func removeFromFavorites(productId: Int) {
        favoriteProducts.removeAll(where: {$0.productId == productId})
        FirestoreManager.shared.deleteFavorite(productId: productId, userId: userId) { [weak self] error in
            if let error = error {
                print("Firestore delete failed: \(error)")
                return
            }
            self?.deleteFromCoreData(productId: productId)
            self?.fetchFavorites()
        }
    }

    private func deleteFromCoreData(productId: Int) {
        let request: NSFetchRequest<CDProduct> = CDProduct.fetchRequest()
        request.predicate = NSPredicate(format: "productId == %lld AND userId == %lld", productId, userId)

        do {
            let results = try context.fetch(request)
            if let product = results.first {
                context.delete(product)
                try context.save()

                DispatchQueue.main.async {
                    self.favoritesMap[productId] = false

                    let updatedList = self.favoriteProducts.filter { Int($0.productId) != productId }
                    self.favoriteProducts = updatedList
                    self.fetchFromCoreData()
                }

            } else {
                print("No favorite found in Core Data to delete.")
            }
        } catch {
            print("Failed to delete from Core Data: \(error)")
        }
    }



    // MARK: - Check Favorite
    func isFavorite(productId: Int) -> Bool {
        favoritesMap[productId] ?? false
    }

    // MARK: - Toggle Favorite
    func toggleFavorite(product: ProductModel) {
        let id = product.id ?? 0
        if isFavorite(productId: id) {
            removeFromFavorites(productId: id)
        } else {
            addToFavorites(product: product)
        }
    }

    // MARK: - Save Changes
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Failed to save Core Data: \(error)")
        }
    }
}


class AppViewModels {
    static let sharedFavoriteVM = FavoriteViewModel()
}
