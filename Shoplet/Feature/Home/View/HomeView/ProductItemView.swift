//
//  ProductItemView.swift
//  Shoplet
//
//  Created by Farid on 09/06/2025.
//

import SwiftUI

struct ProductItemView: View {
    let product: PopularProductItem
    
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
                let price = Double(priceStr) {

                 if let compareAt = variant.compareAtPrice,
                    !compareAt.isEmpty,
                    compareAt != priceStr {
                     HStack(spacing: 6) {
                         
                         Text("\(priceStr) USD")
                             .foregroundColor(.red)
                             .fontWeight(.bold)
                         
                         Text("\(compareAt) USD")
                             .strikethrough()
                             .foregroundColor(.gray)

                     }
                     .font(.subheadline)
                 } else {
                     let originalPrice = price * 1.10
                     HStack(spacing: 6) {
                         
                         Text(String(format: "%.2f USD", price))
                             .foregroundColor(.red)
                             .fontWeight(.bold)
                         
                         Text(String(format: "%.2f USD", originalPrice))
                             .strikethrough()
                             .foregroundColor(.gray)

                     }
                     .font(.subheadline)
                 }
             }
         }
     }

#Preview {
    ProductItemView(product: PopularProductItem(
        id: 1,
        title: "Sample Product",
        bodyHtml: nil,
        vendor: "Demo Vendor",
        productType: nil,
        createdAt: nil,
        handle: nil,
        updatedAt: nil,
        publishedAt: nil,
        templateSuffix: nil,
        tags: nil,
        adminGraphqlApiId: nil,
        status: nil,
        variants: [PopularVariant(
            id: 1,
            productId: 1,
            title: "Variant",
            price: "19.99",
            sku: nil,
            position: nil,
            inventoryPolicy: nil,
            compareAtPrice: "29.99",
            fulfillmentService: nil,
            inventoryManagement: nil,
            option1: nil,
            option2: nil,
            option3: nil,
            createdAt: nil,
            updatedAt: nil,
            taxable: nil,
            barcode: nil,
            grams: nil,
            imageId: nil,
            weight: nil,
            weightUnit: nil,
            inventoryItemId: nil,
            inventoryQuantity: nil,
            oldInventoryQuantity: nil,
            requiresShipping: nil,
            adminGraphqlApiId: nil
        )],
        options: nil,
        images: [PopularProductImage(
            id: 1,
            productId: 1,
            position: nil,
            createdAt: nil,
            updatedAt: nil,
            alt: nil,
            width: nil,
            height: nil,
            src: "https://via.placeholder.com/150",
            variantIds: nil,
            adminGraphqlApiId: nil
        )],
        image: PopularProductImage(
            id: 1,
            productId: 1,
            position: nil,
            createdAt: nil,
            updatedAt: nil,
            alt: nil,
            width: nil,
            height: nil,
            src: "https://via.placeholder.com/150",
            variantIds: nil,
            adminGraphqlApiId: nil
        )
    ))
}
