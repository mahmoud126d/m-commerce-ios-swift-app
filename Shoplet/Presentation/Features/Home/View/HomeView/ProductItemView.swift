//
//  ProductItemView.swift
//  Shoplet
//
//  Created by Farid on 10/06/2025.
//

import SwiftUI

struct ProductItemView: View {
    let product: ProductModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            productImageSlider()

            Text(product.title ?? "No Title")
                .font(.headline)
                .lineLimit(1)
                .multilineTextAlignment(.leading)
                .foregroundColor(.brown)

            Text(product.productType ?? "")
                .font(.subheadline)
                .foregroundColor(.gray)

            productPriceView()
        }
        .padding()
        .frame(height: 250) // Consistent card height
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 2)
    }

    @ViewBuilder
    func productImageSlider() -> some View {
        if let images = product.images, !images.isEmpty {
            TabView {
                ForEach(images, id: \.id) { imageItem in
                    let src = imageItem.src
                    if let url = URL(string: src ?? "") {
                        AsyncImage(url: url) { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 120)
                                .clipped()
                        } placeholder: {
                            ProgressView().frame(height: 120)
                        }
                    }
                }
            }
            .frame(height: 120)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        } else if let imageURL = product.image?.src, let url = URL(string: imageURL) {
            AsyncImage(url: url) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 120)
                    .clipped()
            } placeholder: {
                ProgressView().frame(height: 120)
            }
        }
    }

    @ViewBuilder
    func productPriceView() -> some View {
        if let variant = product.variants?.first,
           let priceStr = variant.price,
           let price = Double(priceStr) {

            if let compareAt = variant.compareAtPrice,
               !compareAt.isEmpty,
               compareAt != priceStr {
                HStack(spacing: 6) {
                    Text("$\(priceStr)")
                        .foregroundColor(.red)
                        .fontWeight(.bold)

                    Text("$\(compareAt)")
                        .strikethrough()
                        .foregroundColor(.gray)
                }
                .font(.subheadline)
            } else {
                let originalPrice = price * 1.10
                HStack(spacing: 6) {
                    Text(String(format: "$%.2f", price))
                        .foregroundColor(.red)
                        .fontWeight(.bold)

                    Text(String(format: "$%.2f", originalPrice))
                        .strikethrough()
                        .foregroundColor(.gray)
                }
                .font(.subheadline)
            }
        }
    }
}
