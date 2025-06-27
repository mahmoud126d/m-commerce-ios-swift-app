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
    @ObservedObject private var favoriteVM = AppViewModels.sharedFavoriteVM
    @State private var selectedFavoriteProduct: ProductModel? = nil
    @State private var showToast = false
    @State private var showDeleteAlert = false
    @State private var favorites: Set<Int> = []
    @State private var showAuthAlert = false
    @State private var showAuthRestrictionAlert = false


    var body: some View {
        ScrollView {
            if viewModel.products.isEmpty {
                VStack(spacing: 16) {
                    LottieView(animationName: "empty", loopMode: .loop)
                        .frame(height: 250)
                    Text("No products found for this brand.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.top, 50)
            } else {
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.products, id: \.id) { product in
                        Button {
                            selectedProduct = product
                        } label: {
                            VStack(alignment: .leading, spacing: 8) {
                                ZStack(alignment: .topTrailing) {
                                    ImageCarouselView(imageURLs: product.images?.compactMap { $0.src } ?? [])
                                    
                                    Button(action: {
                                        if !UserDefaultManager.shared.isUserLoggedIn {
                                            viewModel.onGuestUserAction?()
                                            return
                                        }
                                        
                                        if favoriteVM.isFavorite(productId: product.id ?? 0) {
                                            selectedFavoriteProduct = product
                                            showDeleteAlert = true
                                        } else {
                                            favoriteVM.toggleFavorite(product: product)
                                            showToast = true
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                                showToast = false
                                            }
                                        }
                                    }) {
                                        Image(systemName: favoriteVM.isFavorite(productId: product.id ?? 0) ? "heart.fill" : "heart")
                                            .foregroundColor(.primaryColor)
                                            .padding(10)
                                            .background(Color.white.opacity(0.8))
                                            .clipShape(Circle())
                                            .shadow(radius: 2)
                                    }
                                    .alert(isPresented: $showDeleteAlert) {
                                        Alert(
                                            title: Text("Remove from Favorites"),
                                            message: Text("Are you sure you want to remove this product from your favorites?"),
                                            primaryButton: .destructive(Text("Remove")) {
                                                if let selected = selectedFavoriteProduct {
                                                    favoriteVM.toggleFavorite(product: selected)
                                                }
                                            },
                                            secondaryButton: .cancel()
                                        )
                                    }
                                    
                                }
                                Text(product.title ?? "")
                                    .font(.headline)
                                    .foregroundColor(.primaryColor)
                                
                                //                            Text("Vendor: \(product.vendor ?? "")")
                                //                                .font(.subheadline)
                                //                                .foregroundColor(.secondary)
                                
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
                                            viewModel.addToCart(product: product)
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
            }}
                .overlay(
                    Group {
                        if showToast {
                            Text("Added to favorites")
                                .font(.subheadline)
                                .padding()
                                .background(Color.black.opacity(0.8))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .padding(.top, 50)
                                .transition(.move(edge: .top))
                                .animation(.easeInOut, value: showToast)
                        }
                    },
                    alignment: .top
                )
            
                .navigationTitle(brandName)
                .onAppear {
                    viewModel.fetchProducts(for: brandName)
                    viewModel.onGuestUserAction = {
                        showAuthRestrictionAlert = true
                    }
                }
                .sheet(item: $selectedProduct) { product in
                    ProductDetailsView(product: product, viewModel: ProductViewModel())
                        .presentationDetents([.medium, .large])
                }
                .overlay(
                    Group {
                        if showAuthRestrictionAlert {
                            ZStack {
                                Color.black.opacity(0.4)
                                    .edgesIgnoringSafeArea(.all)
                                
                                AuthRestrictionAlert {
                                    showAuthRestrictionAlert = false
                                }
                                .padding(.horizontal, 16)
                            }
                            .transition(.opacity)
                            .animation(.easeInOut, value: showAuthRestrictionAlert)
                        }
                    }
                )
            
        
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
