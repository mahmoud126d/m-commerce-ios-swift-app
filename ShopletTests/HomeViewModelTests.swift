//
//  HomeViewModelTests.swift
//  ShopletTests
//
//  Created by Farid on 26/06/2025.
//

import Foundation
import XCTest
@testable import Shoplet

final class HomeViewModelTests: XCTestCase {
    var viewModel: HomeViewModel!
    var mockRepository: MockProductRepository!

    override func setUp() {
        super.setUp()
        mockRepository = MockProductRepository()
        viewModel = HomeViewModel(repository: mockRepository)
    }

    func testFetchBrandsSuccess() {
        // Given
        let expectation = self.expectation(description: "Fetch Brands")

        // When
        viewModel.fetchBrands()

        // Wait a short time for the async operation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // Then
            XCTAssertEqual(self.viewModel.brands.count, 2)
            XCTAssertEqual(self.viewModel.brands.first?.title, "Brand A")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0)
    }

    func testFetchBrandsFailure() {
        // Given
        mockRepository.shouldReturnError = true
        let expectation = self.expectation(description: "Fetch Brands Failure")

        // When
        viewModel.fetchBrands()

        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertNotNil(self.viewModel.errorMessage)
            XCTAssertEqual(self.viewModel.brands.count, 0)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0)
    }


    func testFetchBestSellersSuccess() {
        // Given
        let expectation = self.expectation(description: "Fetch Best Sellers Success")

        // When
        viewModel.fetchBestSellers()

        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.viewModel.bestSellers.count, 1)
            XCTAssertEqual(self.viewModel.bestSellers.first?.title, "Running Shoes")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0)
    }


    func testFetchBestSellersFailure() {
        // Given
        mockRepository.shouldReturnError = true
        let expectation = self.expectation(description: "Fetch Best Sellers Failure")

        // When
        viewModel.fetchBestSellers()

        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertNotNil(self.viewModel.errorMessage)
            XCTAssertEqual(self.viewModel.bestSellers.count, 0)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0)
    }

}
