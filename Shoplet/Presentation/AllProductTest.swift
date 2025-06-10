//
//  AllProductTest.swift
//  Shoplet
//
//  Created by Macos on 07/06/2025.
//

import SwiftUI

//struct AllProductTest: View {
//    @StateObject private var viewModel = ProductViewModel()
//    var body: some View {
//        NavigationView {
//            List(viewModel.allProducts, id: \.id) { product in
//                NavigationLink(destination: ProductDetailsView(product: product)) {
//                    VStack(alignment: .leading) {
//                        Text(product.title ?? "")
//                            .font(.headline)
//                        Text("ID: \(product.id ?? 0)")
//                            .font(.subheadline)
//                    }
//                }
//            }
//            .navigationTitle("Products")
//            .onAppear {
//                viewModel.fetchAllProducts()
//            }
//        }
//    }
//}
//
//#Preview {
//    AllProductTest()
//}
