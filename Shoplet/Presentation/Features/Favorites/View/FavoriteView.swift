//
//  FavoriteView.swift
//  Shoplet
//
//  Created by Farid on 10/06/2025.
//

import SwiftUI

struct FavoriteView: View {
    @ObservedObject private var viewModel = AppViewModels.sharedFavoriteVM
    @State private var selectedProduct: CDProduct? = nil


    var body: some View {
        NavigationView {
            VStack {
                if viewModel.favoriteProducts.isEmpty {
                    Text("No favorite products found.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            ForEach(viewModel.favoriteProducts, id: \.productId) { product in
                                FavoriteProductCard(
                                    product: product,
                                    onDelete: {
                                        withAnimation {
                                            viewModel.removeFromFavorites(productId: Int(product.productId))
                                        }
                                    }
                                )
                                .onTapGesture {
                                    selectedProduct = product
                                }
                            }
                        }
                        .padding(.vertical)
                    }
                }
            }
            .navigationTitle("Favorites")
            .sheet(item: $selectedProduct) { cdProduct in
                if let convertedProduct = cdProduct.toProductModel() {
                    ProductDetailsView(product: convertedProduct, viewModel: ProductViewModel())
                        .presentationDetents([.medium, .large])
                } else {
                    Text("Invalid product data.")
                }
            }
            .onAppear {
                print("FavoriteView appeared")
                viewModel.fetchFavorites()
            }

        }
    }
}
