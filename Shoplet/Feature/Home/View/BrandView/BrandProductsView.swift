//
//  BrandProductsView.swift
//  Shoplet
//
//  Created by Farid on 09/06/2025.
//

import SwiftUI

struct BrandProductsView: View {
    let brandName: String
    @StateObject private var viewModel = BrandProductsViewModel()
    var body: some View {
        
        ScrollView {
                   LazyVStack {
                       ForEach(viewModel.products, id: \.id) { product in
                           NavigationLink(destination: ProductDetailsView(productId: product.id ?? 1)) {
                               VStack(alignment: .leading, spacing: 8) {
                                   ImageCarouselView(imageURLs: product.images?.compactMap { $0.src } ?? [])

                                   Text(product.title ?? "")
                                       .font(.headline)
                                       .foregroundColor(.primaryColor)

                                   Text("Vendor: \(product.vendor ?? "")")
                                       .font(.subheadline)
                                       .foregroundColor(.secondary)

                                   Text("Type: \(product.productType ?? "")")
                                       .font(.subheadline)
                                       .foregroundColor(.secondary)

                                   if let price = product.variants?.first?.price {
                                       Text("Price: \(price) USD")
                                           .foregroundColor(.red)
                                           .fontWeight(.bold)
                                   }
                               }
                               .padding()
                               .background(Color.white)
                               .cornerRadius(10)
                               .shadow(radius: 4)
                               .padding(.horizontal)
                           }
                       }
                   }
               }
               .navigationTitle(brandName)
               .onAppear {
                   viewModel.fetchProducts(for: brandName)
               }
           }
       }

#Preview {
   BrandProductsView(brandName: "Nike")
}
