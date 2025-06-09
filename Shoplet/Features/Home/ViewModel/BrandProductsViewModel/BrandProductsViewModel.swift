//
//  BrandProductsViewModel.swift
//  Shoplet
//
//  Created by Farid on 10/06/2025.
//

import Foundation
import Combine

class BrandProductsViewModel: ObservableObject {
    @Published var products: [ProductModel] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    private let baseURL = "https://ios1-ism.myshopify.com/admin/api/2024-07"
    private let token = "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"
    
    func fetchProducts(for brand: String) {
        guard let url = URL(string: "\(baseURL)/products.json") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(token, forHTTPHeaderField: "X-Shopify-Access-Token")
        
        URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: ProductResponse.self, decoder: JSONDecoder())
            .map { $0.products.filter { $0.vendor == brand } ?? [] }
            .receive(on: DispatchQueue.main)
            .replaceError(with: [])
            .assign(to: \.products, on: self)
            .store(in: &cancellables)
    }
}

