//
//  ProductDetailsView.swift
//  Shoplet
//
//  Created by Macos on 05/06/2025.
//

import SwiftUI

struct ProductDetailsView: View {
    let product: ProductModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(product.title ?? "No title")
                    .font(.largeTitle)
                    .bold()

                if let bodyHtml = product.bodyHTML{
                    Text(bodyHtml)
                        .font(.body)
                }

                if let vendor = product.vendor {
                    Text("Vendor: \(vendor)")
                        .font(.subheadline)
                }

                if let productType = product.productType{
                    Text("Type: \(productType)")
                        .font(.subheadline)
                }

                if let tags = product.tags {
                    Text("Tags: \(tags)")
                        .font(.subheadline)
                }

                if let images = product.images {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(images, id: \.id) { image in
                                AsyncImage(url: URL(string: image.src)) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 150)
                                } placeholder: {
                                    ProgressView()
                                }
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Product Details")
    }
}

#Preview {
    ProductDetailsView(product: ProductModel(id: 12121, title: "Adad", bodyHTML: "adaf", vendor: "Dgsg", productType: nil, tags: nil, status: nil, variants: nil, options: nil, images: nil, image: nil))
}
