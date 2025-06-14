//
//  CategoryView.swift
//  Shoplet
//
//  Created by Farid on 10/06/2025.
//

import SwiftUI

struct CategoryView: View {
    @StateObject private var viewModel = CategoryViewModel()
       
       @State private var selectedCategory: ProductCategory = .all
       @State private var selectedFilter: ProductFilter?
       @State private var selectedPriceFilter: PriceFilter = .all
       @State private var searchText = ""
       @State private var showFilterOptions = false
       
       @State private var selectedProduct: ProductModel? = nil
       
       private let gridColumns = [GridItem(.flexible()), GridItem(.flexible())]
       
       var body: some View {
           NavigationView {
               VStack(spacing: 8) {
                   
                   // Search Bar + Filter Button
                   HStack {
                       TextField("Search products...", text: $searchText)
                           .padding(10)
                           .background(Color(.systemGray6))
                           .cornerRadius(8)
                           .onChange(of: searchText) { newText in
                               viewModel.search(text: newText)
                           }
                       
                       Button {
                           withAnimation {
                               showFilterOptions.toggle()
                           }
                       } label: {
                           Image(systemName: "line.3.horizontal.decrease.circle")
                               .font(.title2)
                               .foregroundColor(.primary)
                               .padding(6)
                       }
                   }
                   .padding(.horizontal)
                   
                   // Category Tabs
                   ScrollView(.horizontal, showsIndicators: false) {
                       HStack(spacing: 10) {
                           ForEach(ProductCategory.allCases, id: \.self) { category in
                               Button {
                                   selectedCategory = category
                                   selectedFilter = nil
                                   selectedPriceFilter = .all
                                   searchText = ""
                                   viewModel.updateCategory(category)
                                   viewModel.clearFilter()
                                   viewModel.updatePriceFilter(.all)
                               } label: {
                                   Text(category.rawValue)
                                       .font(.subheadline)
                                       .foregroundColor(selectedCategory == category ? .white : .primary)
                                       .padding(.horizontal, 12)
                                       .padding(.vertical, 8)
                                       .background(selectedCategory == category ? Color.primaryColor : Color.gray.opacity(0.2))
                                       .cornerRadius(12)
                               }
                           }
                       }
                       .padding(.horizontal)
                   }
                   
                   // Filter options
                   if showFilterOptions {
                       VStack(spacing: 4) {
                           // Product Filter
                           ScrollView(.horizontal, showsIndicators: false) {
                               HStack(spacing: 10) {
                                   ForEach(ProductFilter.allCases, id: \.self) { filter in
                                       Button {
                                           if selectedFilter == filter {
                                               selectedFilter = nil
                                               viewModel.clearFilter()
                                           } else {
                                               selectedFilter = filter
                                               searchText = ""
                                               viewModel.updateFilter(filter)
                                           }
                                       } label: {
                                           Text(filter.rawValue)
                                               .font(.subheadline)
                                               .foregroundColor(selectedFilter == filter ? .white : .primary)
                                               .padding(.horizontal, 12)
                                               .padding(.vertical, 8)
                                               .background(selectedFilter == filter ? Color.primaryColor : Color.gray.opacity(0.2))
                                               .cornerRadius(12)
                                       }
                                   }
                               }
                               .padding(.horizontal)
                           }
                           
                           // Price Filter
                           ScrollView(.horizontal, showsIndicators: false) {
                               HStack(spacing: 10) {
                                   ForEach(PriceFilter.allCases, id: \.self) { priceOption in
                                       Button {
                                           selectedPriceFilter = priceOption
                                           viewModel.updatePriceFilter(priceOption)
                                       } label: {
                                           Text(priceOption.rawValue)
                                               .font(.subheadline)
                                               .foregroundColor(selectedPriceFilter == priceOption ? .white : .primary)
                                               .padding(.horizontal, 12)
                                               .padding(.vertical, 8)
                                               .background(selectedPriceFilter == priceOption ? Color.primaryColor : Color.gray.opacity(0.2))
                                               .cornerRadius(12)
                                       }
                                   }
                               }
                               .padding(.horizontal)
                           }
                       }
                       .transition(.opacity.combined(with: .slide))
                   }
                   
                   // Loading / Error / Grid
                   if viewModel.isLoading {
                       Spacer()
                       ProgressView()
                       Spacer()
                   } else if let errorMessage = viewModel.errorMessage {
                       Spacer()
                       Text(errorMessage)
                           .foregroundColor(.red)
                           .multilineTextAlignment(.center)
                           .padding()
                       Spacer()
                   } else {
                       ScrollView {
                           LazyVGrid(columns: gridColumns, spacing: 16) {
                               ForEach(viewModel.filteredProducts, id: \.id) { product in
                                   Button {
                                       selectedProduct = product
                                   } label: {
                                       ProductCardView(product: product)
                                   }
                               }
                           }
                           .padding(.horizontal)
                           .padding(.top)
                       }
                   }
               }
               .navigationTitle("Categories")
               .navigationBarTitleDisplayMode(.inline)
           }
           .sheet(item: $selectedProduct) { product in
               ProductDetailsView(product: product, viewModel: ProductViewModel())
                   .presentationDetents([.medium, .large])
           }
       }
   }

   #Preview {
       CategoryView()
   }
