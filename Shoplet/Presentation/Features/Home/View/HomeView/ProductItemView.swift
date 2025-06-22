//
//  ProductItemView.swift
//  Shoplet
//
//  Created by Farid on 10/06/2025.
//

import SwiftUI

struct ProductItemView: View {
    let product: ProductModel
    @State private var isFavorite: Bool = false

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .leading, spacing: 8) {
                productImageSlider()

                Text(product.title ?? "No Title")
                    .font(.subheadline)
                    .lineLimit(1)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.brown)

                Text(product.productType ?? "")
                    .font(.footnote)
                    .foregroundColor(.gray)

                productPriceView()
            }
            .padding()
            .frame(height: 250)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 2)

//            Button(action: {
//                isFavorite.toggle()
//            }) {
//                Image(systemName: isFavorite ? "heart.fill" : "heart")
//                    .resizable()
//                    .frame(width: 22, height: 22)
//                    .foregroundColor(isFavorite ? .primaryColor : .gray)
//                    .padding(8)
//            }
        }
    }

    @ViewBuilder
    func productImageSlider() -> some View {
        if let images = product.images, !images.isEmpty {
            TabView {
                ForEach(images, id: \.id) { imageItem in
                    if let src = imageItem.src, let url = URL(string: src) {
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

            if let compareAt = variant.compareAtPrice,
               let compareAtValue = Double(compareAt),
               compareAtValue != priceValue {

                let convertedCompareAt = compareAtValue * rate
                let formattedCompareAt = String(format: "%.2f", convertedCompareAt)

                HStack(spacing: 6) {
                    Text("\(formattedPrice) \(currency)")
                        .foregroundColor(.red)
                        .font(.footnote)
                        .fontWeight(.bold)

                    Text("\(formattedCompareAt) \(currency)")
                        .strikethrough()
                        .foregroundColor(.gray)
                        .font(.footnote)
                }
            } else {
                let originalPrice = price * 1.10
                let formattedOriginal = String(format: "%.2f", originalPrice)

                HStack(spacing: 6) {
                    Text("\(formattedPrice) \(currency)")
                        .foregroundColor(.red)
                        .font(.footnote)
                        .fontWeight(.bold)

                    Text("\(formattedOriginal) \(currency)")
                        .strikethrough()
                        .foregroundColor(.gray)
                        .font(.footnote)
                }
            }
        }
    }

}
