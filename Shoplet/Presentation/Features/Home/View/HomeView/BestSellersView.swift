//
//  BestSellersView.swift
//  Shoplet
//
//  Created by Farid on 13/06/2025.
//

import SwiftUI

struct BestSellersView: View {
    let products: [ProductModel]
        
        @State private var selectedProduct: ProductModel? = nil
        
        var body: some View {
            NavigationView {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(products, id: \.id) { product in
                            Button {
                                selectedProduct = product
                            } label: {
                                ProductItemView(product: product)
                            }
                        }
                    }
                    .padding()
                }
                .navigationTitle("Best Sellers")
                .navigationBarTitleDisplayMode(.inline)
                .sheet(item: $selectedProduct) { product in
                    ProductDetailsView(product: product, viewModel: ProductViewModel())
                        .presentationDetents([.medium, .large])
                }
            }
        }
    }
#Preview {
    BestSellersView(products: [
        ProductModel(
            id: 1,
            title: "Sample Product 1",
            bodyHTML: "<p>Description</p>",
            vendor: "Vendor A",
            productType: "Shoes",
            tags: "tag1, tag2",
            status: "active",
            variants: [
                Variant(
                    id: 101,
                    productId: 1,
                    title: "Variant A",
                    price: "49.99",
                    sku: "SKU001",
                    position: 1,
                    compareAtPrice: "59.99",
                    inventoryItemId: 201,
                    inventoryQuantity: 10,
                    oldInventoryQuantity: 15,
                    imageId: 301
                )
            ],
            options: [],
            images: [
                ProductImage(
                    id: 301,
                    alt: "Image",
                    position: 1,
                    productId: 1,
                    width: 300,
                    height: 300,
                    src: "https://via.placeholder.com/300",
                    variantIds: []
                )
            ],
            image: nil
        ),
        ProductModel(
            id: 2,
            title: "Sample Product 2",
            bodyHTML: "<p>Description</p>",
            vendor: "Vendor B",
            productType: "Bag",
            tags: "tag3, tag4",
            status: "active",
            variants: [
                Variant(
                    id: 102,
                    productId: 2,
                    title: "Variant B",
                    price: "29.99",
                    sku: "SKU002",
                    position: 1,
                    compareAtPrice: nil,
                    inventoryItemId: 202,
                    inventoryQuantity: 5,
                    oldInventoryQuantity: 8,
                    imageId: 302
                )
            ],
            options: [],
            images: [],
            image: ProductImage(
                id: 302,
                alt: "Image",
                position: 1,
                productId: 2,
                width: 300,
                height: 300,
                src: "https://via.placeholder.com/300",
                variantIds: []
            )
        )
    ])
    
}
