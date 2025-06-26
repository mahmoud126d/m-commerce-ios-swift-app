//
//  CategoryViewModelTests.swift
//  ShopletTests
//
//  Created by Farid on 26/06/2025.
//

import Foundation
import XCTest
@testable import Shoplet
final class CategoryViewModelTests: XCTestCase {
    
    var mockRepo: MockProductRepository!
    var viewModel: CategoryViewModel!
    
    override func setUp() {
        super.setUp()
        mockRepo = MockProductRepository()
        viewModel = CategoryViewModel(repository: mockRepo)
    }
    
    
    func testFetchProductsSuccess() {
        // Given
        mockRepo.productsToReturn = [
            ProductModel(id: 1, title: "Men T-Shirt", bodyHTML: nil, vendor: nil, productType: "T-Shirt", tags: "men", status: nil, variants: [Variant(price: "20.0")], options: nil, images: nil, image: nil),
            ProductModel(id: 2, title: "Kid Shoes", bodyHTML: nil, vendor: nil, productType: "Shoes", tags: "kid", status: nil, variants: [Variant(price: "15.0")], options: nil, images: nil, image: nil)
        ]
        
        let expectation = self.expectation(description: "Fetch Products Success")
        
        // When
        viewModel.fetchProducts()
        
        // Then (wait for async update to complete)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            XCTAssertEqual(self.viewModel.allProducts.count, 2)
            XCTAssertEqual(self.viewModel.filteredProducts.count, 2)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    
    func testUpdateCategoryMen() {
        // Given
        mockRepo.productsToReturn = [
            ProductModel(
                id: 1, title: "Men T-Shirt", bodyHTML: nil, vendor: nil,
                productType: "T-Shirt", tags: "men", status: nil,
                variants: [Variant(price: "20.0")],
                options: nil, images: nil, image: nil
            ),
            ProductModel(
                id: 2, title: "Women Dress", bodyHTML: nil, vendor: nil,
                productType: "Dress", tags: "women", status: nil,
                variants: [Variant(price: "30.0")],
                options: nil, images: nil, image: nil
            )
        ]
        
        let expectation = self.expectation(description: "Update Category to Men")
        
        // When
        viewModel.fetchProducts()
        
        // Wait for fetch to complete
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.viewModel.updateCategory(.men)
            
            // Wait for filters to apply
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                // Then
                XCTAssertEqual(self.viewModel.filteredProducts.count, 2)
                XCTAssertEqual(self.viewModel.filteredProducts.first?.title, "Men T-Shirt")
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 2.0)  // ⬅️ Increase timeout
    }
    
    
    func testUpdateFilterShoes() {
        // Given
        mockRepo.productsToReturn = [
            ProductModel(id: 1, title: "Running Shoes", bodyHTML: nil, vendor: nil, productType: "Shoes", tags: "men", status: nil, variants: [Variant(price: "50.0")], options: nil, images: nil, image: nil),
            ProductModel(id: 2, title: "Casual T-Shirt", bodyHTML: nil, vendor: nil, productType: "T-Shirt", tags: "men", status: nil, variants: [Variant(price: "20.0")], options: nil, images: nil, image: nil)
        ]
        
        let expectation = self.expectation(description: "Filter by Shoes")
        
        // When
        viewModel.fetchProducts()
        
        // Give time for products to load and filters to apply
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.viewModel.updateFilter(.shoes)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                // Then
                XCTAssertEqual(self.viewModel.filteredProducts.count, 1)
                XCTAssertEqual(self.viewModel.filteredProducts.first?.title, "Running Shoes")
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 2.0)
    }
    
    
    func testSearchTextFilters() {
        mockRepo.productsToReturn = [
            ProductModel(id: 1, title: "Elegant Dress", bodyHTML: nil, vendor: nil, productType: "Dress", tags: "women", status: nil, variants: [Variant(price: "40.0")], options: nil, images: nil, image: nil),
            ProductModel(id: 2, title: "Running Shoes", bodyHTML: nil, vendor: nil, productType: "Shoes", tags: "men", status: nil, variants: [Variant(price: "30.0")], options: nil, images: nil, image: nil)
        ]
        
        let expectation = self.expectation(description: "Search text filter")
        
        viewModel.fetchProducts()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.viewModel.search(text: "Dress")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                XCTAssertEqual(self.viewModel.filteredProducts.count, 1)
                XCTAssertEqual(self.viewModel.filteredProducts.first?.title, "Elegant Dress")
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 2.0)
    }
    
    func testPriceFilterLowToHigh() {
        mockRepo.productsToReturn = [
            ProductModel(id: 1, title: "Cheap Shoes", bodyHTML: nil, vendor: nil, productType: "Shoes", tags: "men", status: nil, variants: [Variant(price: "10.0")], options: nil, images: nil, image: nil),
            ProductModel(id: 2, title: "Expensive Shoes", bodyHTML: nil, vendor: nil, productType: "Shoes", tags: "men", status: nil, variants: [Variant(price: "100.0")], options: nil, images: nil, image: nil)
        ]
        
        let expectation = self.expectation(description: "Price filter low to high")
        
        viewModel.fetchProducts()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.viewModel.updatePriceFilter(.lowToHigh)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                XCTAssertEqual(self.viewModel.filteredProducts.first?.title, "Cheap Shoes")
                XCTAssertEqual(self.viewModel.filteredProducts.last?.title, "Expensive Shoes")
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 2.0)
    }
    
    func testFetchProductsFailure() {
        mockRepo.shouldReturnError = true
        
        let expectation = self.expectation(description: "Fetch products failure")
        
        viewModel.fetchProducts()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            XCTAssertNotNil(self.viewModel.errorMessage)
            XCTAssertEqual(self.viewModel.allProducts.count, 0)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2.0)
    }
}
    // In your test target
    extension Variant {
        init(price: String) {
            self.init(
                id: nil,
                productId: nil,
                title: nil,
                price: price,
                sku: nil,
                position: nil,
                compareAtPrice: nil,
                inventoryItemId: nil,
                inventoryQuantity: nil,
                oldInventoryQuantity: nil,
                imageId: nil,
                option1: nil,
                option2: nil,
                option3: nil
                
            )
        }
    }

