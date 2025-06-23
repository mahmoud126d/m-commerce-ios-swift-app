//
//  FavoriteItem.swift
//  Shoplet
//
//  Created by Macos on 17/06/2025.
//

import SwiftUI

struct FavoriteProductCard: View {
    var product: CDProduct

    @ObservedObject private var favoriteVM = AppViewModels.sharedFavoriteVM
    @State private var showDeleteAlert = false
    @State private var isFavorite = true 

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack(alignment: .topTrailing) {
                if let images = product.images as? Set<CDImage>,
                   let firstImage = images.sorted(by: { $0.position < $1.position }).first,
                   let imageUrl = firstImage.src,
                   let url = URL(string: imageUrl) {

                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView().frame(height: 180)
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(height: 180)
                                .cornerRadius(12)
                                .clipped()
                        case .failure:
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 180)
                                .foregroundColor(.gray)
                        @unknown default:
                            EmptyView()
                        }
                    }

                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 180)
                        .foregroundColor(.gray)
                }

                Button(action: {
                    if isFavorite {
                        showDeleteAlert = true
                    }
                }) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(.primaryColor)
                        .padding(8)
                        .background(Color.white.opacity(0.9))
                        .clipShape(Circle())
                        .shadow(radius: 3)
                }
                .padding([.top, .trailing], 10)
                .alert("Remove from Favorites", isPresented: $showDeleteAlert) {
                    Button("Remove", role: .destructive) {
                        favoriteVM.removeFromFavorites(productId: Int(product.productId))
                        isFavorite = false
                    }
                    Button("Cancel", role: .cancel) {}
                } message: {
                    Text("Are you sure you want to remove this product from your favorites?")
                }
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(product.title ?? "No Title")
                    .font(.headline)
                    .lineLimit(2)

                if let variants = product.variants as? Set<CDVariant>,
                   let variant = variants.first {
                    Text("Price: \(variant.price ?? "0.00") USD")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                } else {
                    Text("Price: 0.00 USD")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal)
        }
        .padding(.bottom)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(radius: 4)
        .padding(.horizontal)
        .onAppear {
            isFavorite = favoriteVM.isFavorite(productId: Int(product.productId))
        }
    }
}
