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
           let priceValue = Double(priceStr)
        {
            let rateStr = UserDefaultManager.shared.currencyRate ?? "1.0"
            let rate = Double(rateStr) ?? 1.0
            let currency = UserDefaultManager.shared.currency ?? "USD"
            let price = priceValue * rate
            let formattedPrice = String(format: "%.2f", price)

            HStack(spacing: 6) {
                // Final price
                Text("\(formattedPrice) \(currency)")
                    .foregroundColor(.red)
                    .font(.system(size: 10)) // Smaller font
                    .fontWeight(.bold)
                    .lineLimit(1)
                    .layoutPriority(1)

                // Original price with strikethrough
                if let compareAt = variant.compareAtPrice,
                   let compareAtValue = Double(compareAt),
                   compareAtValue != priceValue {

                    let convertedCompareAt = compareAtValue * rate
                    let formattedCompareAt = String(format: "%.2f", convertedCompareAt)

                    Text("\(formattedCompareAt) \(currency)")
                        .strikethrough()
                        .foregroundColor(.gray)
                        .fontWeight(.bold)

                        .font(.system(size: 10))
                    // Same small font
                        .lineLimit(1)

                } else {
                    let originalPrice = price * 1.10
                    let formattedOriginal = String(format: "%.2f", originalPrice)

                    Text("\(formattedOriginal) \(currency)")
                        .strikethrough()
                        .foregroundColor(.gray)
                        .fontWeight(.bold)

                        .font(.system(size: 10)) // Same small font
                        .lineLimit(1)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    }
