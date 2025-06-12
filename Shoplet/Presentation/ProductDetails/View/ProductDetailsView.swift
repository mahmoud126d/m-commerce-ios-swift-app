//
//  ProductDetailsView.swift
//  Shoplet
//
//  Created by Macos on 05/06/2025.
//

import SwiftUI

struct ProductDetailsView: View {
    let product: ProductModel
    @StateObject var viewModel : ProductViewModel
    @State private var selectedColor: String = ""
    @State private var selectedSize: String = ""
    @State private var showFullDescription: Bool = false
    @State private var quantity: Int = 1
    
    var colorOptions: [String] {
        product.options?.first(where: { $0.name.lowercased() == "color" })?.values ?? []
    }

    var sizeOptions: [String] {
        product.options?.first(where: { $0.name.lowercased() == "size" })?.values ?? []
    }


    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                if let images = product.images, !images.isEmpty {
                    TabView {
                        ForEach(images, id: \.id) { img in
                            if let url = URL(string: img.src ?? "") {
                                AsyncImage(url: url) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(maxWidth: .infinity)
                                } placeholder: {
                                    ProgressView()
                                }
                            }
                        }
                    }
                    .frame(height: 400)
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                } else if let fallback = product.image?.src, let url = URL(string: fallback) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(height: 300)
                }

                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text(product.title ?? "No Title")
                            .font(.title2)
                            .bold()

                        Spacer()

                        HStack(spacing: 12) {
                            Button(action: {
                                if quantity > 1 {
                                    quantity -= 1
                                    viewModel.selectedQuantity = quantity
                                }
                            }) {
                                Image(systemName: "minus")
                                    .frame(width: 30, height: 30)
                                    .background(Circle().fill(Color.primaryColor))
                                    .foregroundColor(.white)
                            }

                            Text("\(quantity)")
                                .font(.headline)
                                .frame(width: 24)
                            Button(action: {
                                quantity += 1
                                viewModel.selectedQuantity = quantity
                            }) {
                                Image(systemName: "plus")
                                    .frame(width: 30, height: 30)
                                    .background(Circle().fill(Color.primaryColor))
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.horizontal, 6)
                        .background(Color.primaryColor.opacity(0.1))
                        .cornerRadius(20)
                    }

                    HStack {
                        Label("4.8", systemImage: "star.fill")
                            .foregroundColor(.yellow)
                        Text("(320 Reviews)")
                        Spacer()
                        Text("Available in stock")
                            .font(.subheadline)
                            .foregroundColor(.green)
                    }

                    VStack(alignment: .leading) {
                        Text("Color")
                            .font(.headline)
                        
                        HStack(spacing: 10) {
                            ForEach(colorOptions, id: \.self) { color in
                                Circle()
                                    .fill(Color.from(name: color))
                                    .frame(width: 30, height: 30)
                                    .overlay(
                                        Circle()
                                            .stroke(selectedColor == color ? Color.primaryColor : Color.clear, lineWidth: 3)
                                    )
                                    .onTapGesture {
                                        selectedColor = color
                                        viewModel.selectedColor = selectedColor
                                        
                                    }
                            }
                        }
                    }
                    VStack(alignment: .leading) {
                        Text("Size")
                            .font(.headline)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(sizeOptions, id: \.self) { size in
                                    Text(size)
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 12)
                                        .background(selectedSize == size ? Color.primaryColor : Color.gray.opacity(0.2))
                                        .foregroundColor(.black)
                                        .cornerRadius(10)
                                        .onTapGesture {
                                            selectedSize = size
                                            viewModel.selectedSize = Int(selectedSize) ?? 32
                                        }
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Description")
                            .font(.headline)

                        Text(product.bodyHTML ?? "No Description")
                            .font(.body)
                            .lineLimit(showFullDescription ? nil : 3)

                        Button(action: {
                            showFullDescription.toggle()
                        }) {
                            Text(showFullDescription ? "Read Less" : "Read More")
                                .font(.subheadline)
                                .foregroundColor(.blue)
                        }
                    }

                    HStack {
                        Text(String(format: "$%.2f", getPrice()))
                            .font(.title2)
                            .bold()

                        Spacer()

                        Button(action: {
                            // TODO: Add to Cart Logic
                            
                            viewModel.addToCart(product: product)
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "cart.fill")
                                Text("Add to Cart")
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 12)
                            .background(Color.primaryColor)
                            .foregroundColor(.white)
                            .cornerRadius(25)
                        }
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(30)
                .offset(y: -30)
            }
        }
        .background(Color(.systemGroupedBackground))
        .edgesIgnoringSafeArea(.top)
        .navigationTitle("Detail Product")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func getPrice() -> Double {
        let basePrice = product.variants?.first?.price ?? "35.8"
        return (Double(basePrice) ?? 0.0) * Double(quantity)
    }
}

#Preview {
    ProductDetailsView(product: ProductModel(
        id: 12111,
        title: "Elegant Handbag",
        bodyHTML: "A beautifully crafted leather handbag perfect for any occasion. Spacious, stylish, and durable.",
        vendor: "Luxury Co.",
        productType: "Bag",
        tags: nil,
        status: nil,
        variants: [Variant(id: 1, productId: 12121, title: nil, price: "99.99", sku: nil, position: nil, compareAtPrice: nil, inventoryItemId: nil, inventoryQuantity: nil, oldInventoryQuantity: nil, imageId: nil)],
        options: nil,
        images: nil,
        image: nil
        
    ),viewModel: ProductViewModel())
}

struct ImageModel: Identifiable, Codable {
    let id: Int
    let src: String?
}
