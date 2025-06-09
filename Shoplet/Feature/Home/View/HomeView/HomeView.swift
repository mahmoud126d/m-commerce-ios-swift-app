//
//  HomeView.swift
//  Shoplet
//
//  Created by Farid on 09/06/2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    
                    TabView {
                        ZStack {
                            Image("best_product_banner")
                                .resizable()
                                .scaledToFill()
                                .frame(height: 180)
                                .clipped()
                            
                            VStack {
                                Text("BEST PRODUCT")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                Text("STARTED")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text("35% OFF")
                                    .font(.subheadline)
                                    .foregroundColor(.yellow)
                            }
                        }
                    }
                    .frame(height: 180)
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .cornerRadius(15)
                    .padding(.horizontal)
                    
                    // Brands Section
                    Text("Popular Brands")
                        .font(.headline)
                        .padding(.horizontal)
                        .foregroundColor(.primaryColor)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(viewModel.brands, id: \.id) { brand in
                                NavigationLink(destination: BrandProductsView(brandName: brand.title ?? "")) {
                                    VStack(spacing: 8) {
                                        if let imageUrl = brand.image?.src, let url = URL(string: imageUrl) {
                                            AsyncImage(url: url) { phase in
                                                switch phase {
                                                case .empty:
                                                    ProgressView()
                                                        .frame(width: 50, height: 50)
                                                case .success(let image):
                                                    image
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: 90, height: 80)
                                                      //.clipShape(Circle())
                                                case .failure(_):
                                                    Circle()
                                                        .fill(Color.gray)
                                                        .frame(width: 50, height: 50)
                                                @unknown default:
                                                    EmptyView()
                                                }
                                            }
                                        } else {
                                            Circle()
                                                .fill(Color.gray)
                                                .frame(width: 50, height: 50)
                                        }
                                        
                                        Text(brand.title ?? "")
                                            .font(.caption2)
                                            //.foregroundColor(.primary)
                                            .lineLimit(1)
                                            .foregroundColor(.primaryColor)

                                    }
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.white)
                                    .cornerRadius(12)
                                    .shadow(radius: 2)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Best Sellers Section
                    Text("Best Sellers")
                        .font(.headline)
                        .padding(.horizontal)
                        .foregroundColor(.primaryColor)

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                                            ForEach(viewModel.bestSellers, id: \.id) { product in
                                                NavigationLink(destination: ProductDetailsView(productId: product.id ?? 1)) {
                                                    ProductItemView(product: product)
                                                }
                                            }
                                        }
                                        .padding(.horizontal)
                                    }
                                    .padding(.top)
                                }
                                .navigationTitle("Home")
                                .navigationBarTitleDisplayMode(.inline)
                                .foregroundColor(.primaryColor)
                                .onAppear {
                                    viewModel.fetchBrands()
                                    viewModel.fetchBestSellers()
                                }
                            }
                        }
                    }
#Preview {
    HomeView()
}
