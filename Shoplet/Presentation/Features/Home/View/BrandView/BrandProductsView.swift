//
//  BrandProductsView.swift
//  Shoplet
//
//  Created by Farid on 10/06/2025.
//

import SwiftUI

struct BrandProductsView: View {
    let brandName: String
    @State private var selectedProduct: ProductModel? = nil

    @StateObject private var viewModel = BrandProductsViewModel()
    @State private var favorites: Set<Int> = []

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.products, id: \.id) { product in
                    Button {
                        selectedProduct = product
                    } label: {
                        VStack(alignment: .leading, spacing: 8) {
                            ZStack(alignment: .topTrailing) {
                                ImageCarouselView(imageURLs: product.images?.compactMap { $0.src } ?? [])

                                Button(action: {
                                    toggleFavorite(productId: product.id ?? 0)
                                }) {
                                    Image(systemName: favorites.contains(product.id ?? 0) ? "heart.fill" : "heart")
                                        .foregroundColor(favorites.contains(product.id ?? 0) ? .primaryColor : .gray)
                                        .padding(10)
                                        .background(Color.white.opacity(0.8))
                                        .clipShape(Circle())
                                        .shadow(radius: 2)
                                }
                                .padding(8)
                            }

                            Text(product.title ?? "")
                                .font(.headline)
                                .foregroundColor(.primaryColor)

                            Text("Vendor: \(product.vendor ?? "")")
                                .font(.subheadline)
                                .foregroundColor(.secondary)

                            Text("Type: \(product.productType ?? "")")
                                .font(.subheadline)
                                .foregroundColor(.secondary)

                            if let price = product.variants?.first?.price {
                                HStack {
                                    Text("Price: \(price) USD")
                                        .foregroundColor(.red)
                                        .fontWeight(.bold)

                                    Spacer()

                                    Button(action: {
                                        // TODO: Handle add to cart logic
                                        print("Add to cart tapped for \(product.title ?? "")")
                                    }) {
                                        Label("Add to Cart", systemImage: "cart.badge.plus")
                                            .font(.subheadline)
                                            .foregroundColor(.white)
                                            .padding(.horizontal)
                                            .padding(.vertical, 6)
                                            .background(Color.primaryColor)
                                            .cornerRadius(8)
                                    }
                                }
                                .padding(.top, 8)
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 4)
                        .padding(.horizontal)
                    }
                }
            }
        }
        .navigationTitle(brandName)
        .onAppear {
            viewModel.fetchProducts(for: brandName)
        }
        .sheet(item: $selectedProduct) { product in
            ProductDetailsView(product: product, viewModel: ProductViewModel())
                .presentationDetents([.medium, .large])
        }
    }

    private func toggleFavorite(productId: Int) {
        if favorites.contains(productId) {
            favorites.remove(productId)
        } else {
            favorites.insert(productId)
        }
    }
}

#Preview {
   BrandProductsView(brandName: "Nike")
}
