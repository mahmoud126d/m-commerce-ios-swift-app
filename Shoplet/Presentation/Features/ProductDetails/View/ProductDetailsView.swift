//
//  ProductDetailsView.swift
//  Shoplet
//
//  Created by Macos on 05/06/2025.
//

import SwiftUI


struct ProductDetailsView: View {
    let product: ProductModel
    @StateObject var viewModel: ProductViewModel
    @ObservedObject private var favoriteVM = AppViewModels.sharedFavoriteVM
    @State private var selectedColor: String = ""
    @State private var selectedSize: String = ""
    @State private var toastMessage: String = ""
    @State private var showFullDescription: Bool = false
    @State private var quantity: Int = 1
    @State private var showDeleteAlert = false
    @State private var showToast = false
    @State private var showAuthAlert = false
    @State private var navigateToSignUp = false

    var maxQuantity: Int {
        selectedVariant?.inventoryQuantity  ?? 10
    }
    var selectedVariant: Variant? {
        product.variants?.first(where: { variant in
            variant.option1?.lowercased() == selectedSize.lowercased() &&
            variant.option2?.lowercased() == selectedColor.lowercased()
        })
    }

    var colorOptions: [String] {
        product.options?.first(where: { $0.name.lowercased() == "color" })?.values ?? []
    }

    var sizeOptions: [String] {
        product.options?.first(where: { $0.name.lowercased() == "size" })?.values ?? []
    }

    @State private var isFavorite: Bool = false


    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                productImagesSection

                VStack(alignment: .leading, spacing: 16) {
                    productTitleOnly

                    productRatings

                    quantityStepper

                    colorSelector

                    sizeSelector

                    descriptionSection

                    priceAndCart
                }
                .padding()
                .background(Color.white)
                .cornerRadius(30)
                .offset(y: -30)
            }
            .onAppear {
                isFavorite = favoriteVM.isFavorite(productId: product.id ?? 0)
            }
            .onChange(of: selectedSize) { _ in
                if let selectedVariant = selectedVariant {
                    quantity = 1
                    viewModel.selectedQuantity = quantity
                }
            }

            .onChange(of: selectedColor) { _ in
                if let selectedVariant = selectedVariant {
                    quantity = 1
                    viewModel.selectedQuantity = quantity
                }
            }


        }
        .background(Color(.systemGroupedBackground))
        .edgesIgnoringSafeArea(.top)
        .overlay(
            ZStack {
                if showToast {
                    VStack {
                        Text(toastMessage)
                            .font(.subheadline)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color.black.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .transition(.move(edge: .top))
                            .animation(.easeInOut, value: showToast)
                        Spacer()
                    }
                    .padding(.top, 50)
                }

                if showAuthAlert {
                    ZStack {
                        Color.black.opacity(0.4)
                            .edgesIgnoringSafeArea(.all)

                        AuthRestrictionAlert(
                            onDismiss: {
                                showAuthAlert = false
                            }
                        )
                        .padding(.horizontal, 16)
                    }
                    .transition(.opacity)
                    .animation(.easeInOut, value: showAuthAlert)
                }
            }
        )
        .navigationTitle("Detail Product")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var productImagesSection: some View {
        Group {
            if let images = product.images, !images.isEmpty {
                ZStack(alignment: .topTrailing) {
                    TabView {
                        ForEach(images, id: \.id) { img in
                            if let url = URL(string: img.src ?? "") {
                                AsyncImage(url: url) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .clipped()
                                        .frame(maxWidth: .infinity)
                                } placeholder: {
                                    ProgressView()
                                }
                            }
                        }
                    }
                    .frame(height: UIScreen.main.bounds.height * 0.45)
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))

                    Button {
                        if !UserDefaultManager.shared.isUserLoggedIn {
                                showAuthAlert = true
                                return
                            }

                            if isFavorite {
                                showDeleteAlert = true
                            } else {
                                favoriteVM.toggleFavorite(product: product)
                                isFavorite = true
                                toastMessage = "Added to favorites"
                                withAnimation { showToast = true }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    withAnimation { showToast = false }
                                }
                            }
                    } label: {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .foregroundColor(.primaryColor)
                            .padding()
                            .background(Color.white.opacity(0.9))
                            .clipShape(Circle())
                            .shadow(radius: 3)
                            .animation(.easeInOut, value: isFavorite)
                    }
                    .alert(isPresented: $showDeleteAlert) {
                        Alert(
                            title: Text("Remove from Favorites"),
                            message: Text("Are you sure you want to remove this product from your favorites?"),
                            primaryButton: .destructive(Text("Remove")) {
                                favoriteVM.toggleFavorite(product: product)
                                isFavorite = false
                                toastMessage = "Removed from favorites"
                                withAnimation {
                                    showToast = true
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    withAnimation {
                                        showToast = false
                                    }
                                }
                            },
                            secondaryButton: .cancel()
                        )
                    }
                    .padding(15)
                    .alert(isPresented: $showDeleteAlert) {
                        Alert(
                            title: Text("Remove from Favorites"),
                            message: Text("Are you sure you want to remove this product from your favorites?"),
                            primaryButton: .destructive(Text("Remove")) {
                                favoriteVM.toggleFavorite(product: product)
                                isFavorite = false
                            },
                            secondaryButton: .cancel()
                        )
                    }

                }
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
        }
    }

    private var productTitleOnly: some View {
        Text(product.title ?? "No Title")
            .font(.title2)
            .bold()
    }


    private var productRatings: some View {
        HStack {
            Label("4.8", systemImage: "star.fill")
                .foregroundColor(.yellow)
            Text("(320 Reviews)")
            Spacer()
            Text("Available in stock")
                .font(.subheadline)
                .foregroundColor(.green)
        }
    }

    private var colorSelector: some View {
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
                                .stroke(
                                    selectedColor == color ? Color.primaryColor : Color.gray.opacity(0.5),
                                    lineWidth: 2
                                )
                        )
                        .onTapGesture {
                            selectedColor = color
                            viewModel.selectedColor = selectedColor
                            quantity = 1
                        }
                }
            }
        }
    }

    private var quantityStepper: some View {
        Group {
            if selectedVariant != nil {
                HStack {
                    Text("Quantity")
                        .font(.headline)

                    Spacer()

                    HStack(spacing: 12) {
                        Button {
                            if quantity > 1 {
                                quantity -= 1
                                viewModel.selectedQuantity = quantity
                            }
                        } label: {
                            Image(systemName: "minus")
                                .frame(width: 30, height: 30)
                                .background(Circle().fill(Color.primaryColor))
                                .foregroundColor(.white)
                        }

                        Text("\(quantity)")
                            .font(.headline)
                            .frame(width: 24)

                        Button {
                            if quantity < maxQuantity {
                                quantity += 1
                                viewModel.selectedQuantity = quantity
                            } else {
                                toastMessage = "Only \(maxQuantity) item(s) available in stock"
                                showToast = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    showToast = false
                                }
                            }
                        } label: {
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
            } else {
                Text("Please select size and color first")
                    .foregroundColor(.red)
                    .font(.footnote)
            }
        }
    }


    private var sizeSelector: some View {
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
                                viewModel.selectedSize = Int(selectedSize) ?? 0
                                quantity = 1
                            }
                    }
                }
                .padding(.vertical, 4)
            }
        }
    }

    private var descriptionSection: some View {
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
    }

    private var priceAndCart: some View {
        HStack {
            Text(String(format: "\(String(describing: UserDefaultManager.shared.currency ?? "USD")) %.2f", getPrice()))
                .font(.title2)
                .bold()

            Spacer()

            Button(action: {
                if !UserDefaultManager.shared.isUserLoggedIn {
                    showAuthAlert = true
                    return
                }
                guard selectedVariant != nil else {
                    toastMessage = "Please select size and color first"
                    showToast = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        showToast = false
                    }
                    return
                }

                viewModel.addToCart(product: product)
                if viewModel.errorMessage != nil{
                    toastMessage = "you exceeds your limit"
                }else{
                    toastMessage = "Added to cart successfully"
                }
                showToast = true

                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    showToast = false
                }
            }){
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

    private func getPrice() -> Double {
        let priceString = selectedVariant?.price ?? product.variants?.first?.price ?? "1"
        let rate = Double(UserDefaultManager.shared.currencyRate ?? "1") ?? 1.0
        let basePrice = (Double(priceString) ?? 1.0) * rate
        return basePrice * Double(quantity)
    }

}
