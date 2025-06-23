//
//  HomeView.swift
//  Shoplet
//
//  Created by Farid on 10/06/2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
       @State private var selectedProduct: ProductModel? = nil
       @State private var showAllBestSellers = false
       
       var body: some View {
           NavigationView {
               ScrollView {
                   VStack(alignment: .leading, spacing: 10) {
                       
                       HStack(spacing: 12) {
                                           Image("app_logo")
                                               .resizable()
                                               .frame(width: 60, height: 60)
                                               .clipShape(RoundedRectangle(cornerRadius: 8))

                                           HStack() {
                                               Text("Hello,")
                                                   .font(.subheadline)
                                                   .foregroundColor(.gray)
                                               Text(viewModel.customerName)
                                                   .font(.title3)
                                                   .fontWeight(.semibold)
                                                   .foregroundColor(.primaryColor)
                                           }

                                           Spacer()
                                       }
                                       .padding(.horizontal)
                                       .padding(.top, 8)

                       
                       CouponsView()
                           .padding(.vertical)
                       
                       // Brands Section
                       Text("Popular Brands")
                           .font(.headline)
                           .padding(.horizontal)
                           .foregroundColor(.primaryColor)
                       
                       ScrollView(.horizontal, showsIndicators: false) {
                           HStack(spacing: 14) {
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
                       HStack {
                           Text("Best Sellers")
                               .font(.headline)
                               .foregroundColor(.primaryColor)
                           Spacer()
                           if !viewModel.bestSellers.isEmpty {
                               Button("See More") {
                                   showAllBestSellers = true
                               }
                               .foregroundColor(.primaryColor)
                               .font(.subheadline)
                               .fontWeight(.medium)
                           }
                       }
                       .padding(.horizontal)
                       
                       LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                           ForEach(viewModel.bestSellers.prefix(4), id: \.id) { product in
                               Button {
                                   selectedProduct = product
                               } label: {
                                   ProductItemView(product: product)
                               }
                           }
                       }
                       .padding(.horizontal)
                       
                   }
                   .padding(.top)
               }
               .onAppear {
                   viewModel.fetchBrands()
                   viewModel.fetchBestSellers()
                   viewModel.getAllDraftOrders()
                   viewModel.fetchCustomerName()
               }
               .sheet(item: $selectedProduct) { product in
                   ProductDetailsView(product: product, viewModel: ProductViewModel())
                       .presentationDetents([.medium, .large])
               }
               .sheet(isPresented: $showAllBestSellers) {
                   BestSellersView(products: viewModel.bestSellers)
               }
           }
       }
   }
#Preview {
    HomeView()
}

