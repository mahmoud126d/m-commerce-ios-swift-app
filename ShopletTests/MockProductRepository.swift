//
//  MockProductRepository.swift
//  ShopletTests
//
//  Created by Farid on 26/06/2025.
//

import Foundation
import Foundation
@testable import Shoplet

class MockProductRepository: ProductRepository {
    var shouldReturnError = false
    
    let mockBrands: [SmartCollection] = [
        SmartCollection(
            id: 1,
            title: "Brand A",
            image: BrandImage(src: "https://example.com/brandA.png", alt: "Brand A", width: 200, height: 200)
        ),
        SmartCollection(
            id: 2,
            title: "Brand B",
            image: BrandImage(src: "https://example.com/brandB.png", alt: "Brand B", width: 200, height: 200)
        )
    ]

    let mockBestSellers: [ProductModel] = [
        ProductModel(
            id: 1,
            title: "Running Shoes",
            bodyHTML: "<p>Comfortable and stylish</p>",
            vendor: "Nike",
            productType: "Shoes",
            tags: "running, sport",
            status: "active",
            variants: [
                Variant(
                    id: 101,
                    productId: 1,
                    title: "Size 42",
                    price: "99.99",
                    sku: "RS-42",
                    position: 1,
                    compareAtPrice: "129.99",
                    inventoryItemId: 1001,
                    inventoryQuantity: 50,
                    oldInventoryQuantity: 60,
                    imageId: nil,
                    option1: nil,
                    option2: nil,
                    option3: nil
                )
            ],
            options: [
                Option(
                    id: 201,
                    productId: 1,
                    name: "Size",
                    position: 1,
                    values: ["40", "41", "42"]
                )
            ],
            images: [
                ProductImage(
                    id: 301,
                    alt: "Front view",
                    position: 1,
                    productId: 1,
                    width: 500,
                    height: 500,
                    src: "https://example.com/shoes1.png",
                    variantIds: []
                )
            ],
            image: ProductImage(
                id: 301,
                alt: "Front view",
                position: 1,
                productId: 1,
                width: 500,
                height: 500,
                src: "https://example.com/shoes1.png",
                variantIds: []
            )
        )
    ]
    var productsToReturn: [ProductModel] = []
     // var shouldReturnError: Bool = false

      func getAllProducts(completion: @escaping (Result<[ProductModel], Error>) -> Void) {
          if shouldReturnError {
              completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Mock error"])))
          } else {
              completion(.success(productsToReturn))
          }
      }

    func getAllBrands(completion: @escaping (Result<[SmartCollection], Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(NSError(domain: "", code: 1)))
        } else {
            completion(.success(mockBrands))
        }
    }

    func getBestSellers(completion: @escaping (Result<[ProductModel], Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(NSError(domain: "", code: 2)))
        } else {
            completion(.success(mockBestSellers))
        }
    }

    // Stub other methods if needed (empty implementations)
    func getProductById(_ id: String, completion: @escaping (Result<ProductModel, Error>) -> Void) {}
   // func getAllProducts(completion: @escaping (Result<[ProductModel], Error>) -> Void) {}
    func getPriceRules(completion: @escaping (Result<[PriceRule], NetworkError>) -> Void) {}
    func getPriceRulesById(priceRuleId: Int, completion: @escaping (Result<PriceRule, NetworkError>) -> Void) {}
    func getCoupons(id: Int, completion: @escaping (Result<[Coupon], NetworkError>) -> Void) {}
    func createDraftOrder(draftOrder: DraftOrderItem, completion: @escaping (Result<DraftOrder, NetworkError>) -> Void) {}
    func updateDraftOrder(draftOrder: DraftOrderItem, dtaftOrderId: Int, completion: @escaping (Result<DraftOrder, NetworkError>) -> Void) {}
    func getDraftOrderById(dtaftOrderId: Int, completion: @escaping (Result<DraftOrder, NetworkError>) -> Void) {}
    func deleteDraftOrder(dtaftOrderId: Int, completion: @escaping () -> Void) {}
    func getDraftOrders(completion: @escaping (Result<[DraftOrder], NetworkError>) -> Void) {}
    func completeOrder(draftOrderId: Int, completion: @escaping (Result<DraftOrderItem, NetworkError>) -> Void) {}
}
