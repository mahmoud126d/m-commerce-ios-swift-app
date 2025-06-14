//
//  CategoryViewModel.swift
//  Shoplet
//
//  Created by Farid on 13/06/2025.
//

import Foundation
import Combine

//enum ProductCategory: String, CaseIterable {
//    case all = "All"
//    case kid = "Kid"
//    case men = "Men"
//    case women = "Women"
//    case sale = "SALE"
//}
//
//enum ProductFilter: String, CaseIterable {
//    case tshirt = "T-Shirt"
//    case accessories = "Accessories"
//    case shoes = "Shoes"
//}
//enum PriceFilter: String, CaseIterable {
//    case all = "All"
//    case lowToHigh = "Low to High"
//    case highToLow = "High to Low"
//}
//
//final class CategoryViewModel: ObservableObject {
//    // MARK: - Published Properties
//    @Published var allProducts: [ProductModel] = []
//    @Published var filteredProducts: [ProductModel] = []
//    @Published var isLoading: Bool = false
//    @Published var errorMessage: String? = nil
//    @Published var currentPriceFilter: PriceFilter = .all
//
//    
//    @Published var currentCategory: ProductCategory = .all
//       @Published var currentFilter: ProductFilter? = nil
//       @Published var currentSearchText: String = ""
//    
//    // MARK: - Dependencies
//    private let repository: ProductRepository
//
//    // MARK: - Init
//    init(repository: ProductRepository = ProductRepositoryImpl()) {
//        self.repository = repository
//        fetchProducts()
//    }
//
//    // MARK: - Public Methods
//    func fetchProducts() {
//        isLoading = true
//        errorMessage = nil
//
//        repository.getAllProducts { [weak self] result in
//            DispatchQueue.main.async {
//                guard let self = self else { return }
//                self.isLoading = false
//                switch result {
//                case .success(let products):
//                    self.allProducts = products
//                    self.applyFilters()
//                case .failure(let error):
//                    self.errorMessage = "Failed to load products: \(error.localizedDescription)"
//                }
//            }
//        }
//    }
//
//    func updateCategory(_ category: ProductCategory) {
//        currentCategory = category
//        currentFilter = nil // Clear filter when category changes
//        applyFilters()
//    }
//
//    func updateFilter(_ filter: ProductFilter) {
//        currentFilter = filter
//        applyFilters()
//    }
//
//    func clearFilter() {
//        currentFilter = nil
//        applyFilters()
//    }
//
//    func search(text: String) {
//        currentSearchText = text
//        applyFilters()
//    }
//    func updatePriceFilter(_ priceFilter: PriceFilter) {
//            currentPriceFilter = priceFilter
//            applyFilters()
//        }
//
//
//    // MARK: - Private Method
//    private func applyFilters() {
//            DispatchQueue.global(qos: .userInitiated).async {
//                var result = self.allProducts
//                
//                // Category filter
//                switch self.currentCategory {
//                case .all:
//                    break
//                case .kid:
//                    result = result.filter { $0.tags?.localizedCaseInsensitiveContains("kid") == true }
//                case .men:
//                    result = result.filter { $0.tags?.localizedCaseInsensitiveContains("men") == true }
//                case .women:
//                    result = result.filter { $0.tags?.localizedCaseInsensitiveContains("women") == true }
//                case .sale:
//                    result = result.filter { $0.tags?.localizedCaseInsensitiveContains("sale") == true }
//                }
//
//                // Product type filter
//                if let filter = self.currentFilter {
//                    result = result.filter {
//                        $0.productType?.localizedCaseInsensitiveContains(filter.rawValue) == true
//                    }
//                }
//
//                // Search text filter
//                if !self.currentSearchText.isEmpty {
//                    let searchText = self.currentSearchText.lowercased()
//                    result = result.filter {
//                        $0.title?.lowercased().contains(searchText) == true
//                    }
//                }
//
//                // Price sorting
//                switch self.currentPriceFilter {
//                case .lowToHigh:
//                    result = result.sorted {
//                        (Double($0.variants?.first?.price ?? "") ?? 0.0) < (Double($1.variants?.first?.price ?? "") ?? 0.0)
//                    }
//
//                case .highToLow:
//                    result = result.sorted {
//                        (Double($0.variants?.first?.price ?? "") ?? 0.0) > (Double($1.variants?.first?.price ?? "") ?? 0.0)
//                    }
//
//                case .all:
//                    break
//                }
//
//                DispatchQueue.main.async {
//                    self.filteredProducts = result
//                }
//            }
//        }
//    }
