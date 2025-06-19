//
//  FirestoreManager.swift
//  Shoplet
//
//  Created by Macos on 18/06/2025.
//

import Foundation
import FirebaseFirestore

class FirestoreManager {
    static let shared = FirestoreManager()
    private let db = Firestore.firestore()

    private init() {}

    func addFavorite(product: ProductModel, userId: Int, completion: ((Error?) -> Void)? = nil) {
        guard let productId = product.id else { return }

        let data: [String: Any] = [
            "productId": productId,
            "title": product.title ?? "",
            "bodyHTML": product.bodyHTML ?? "",
            "vendor": product.vendor ?? "",
            "productType": product.productType ?? "",
            "tags": product.tags ?? "",
            "status": product.status ?? "",
            "images": product.images?.map {
                ["id": $0.id, "src": $0.src ?? "", "position": $0.position]
            } ?? [],
            "variant": [
                "id": product.variants?.first?.id ?? 0,
                "title": product.variants?.first?.title ?? "",
                "price": product.variants?.first?.price ?? ""
            ]
        ]

        db.collection("users").document("\(userId)").collection("favorites").document("\(productId)").setData(data, completion: completion)
    }

    func deleteFavorite(productId: Int, userId: Int, completion: ((Error?) -> Void)? = nil) {
        db.collection("users").document("\(userId)").collection("favorites").document("\(productId)").delete(completion: completion)
    }

    func fetchFavorites(userId: Int, completion: @escaping ([[String: Any]]) -> Void) {
        db.collection("users").document("\(userId)").collection("favorites").getDocuments { snapshot, error in
            if let documents = snapshot?.documents {
                let data = documents.map { $0.data() }
                completion(data)
            } else {
                completion([])
            }
        }
    }
}
