//
//  CartItem.swift
//  Shoplet
//
//  Created by Macos on 11/06/2025.
//

import SwiftUI

struct CartItem: View {
    var lineItem: LineItem
    @StateObject var cartViewModel = CartViewModel()
    var onQuantityChange: (Int) -> Void
    var onDeleteLineItem: () -> Void
    @State var showAlert = false
    @State var showToast = false
    var body: some View {
        VStack(spacing: 12) {
            ZStack(alignment: .topTrailing) {
                AsyncImage(url: URL(string: lineItem.properties?[1].value ?? "")) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity, minHeight:120, maxHeight: 180)
                        .clipped()
                        .cornerRadius(16)
                        .padding()
                } placeholder: {
                    ProgressView()
                        .frame(height: 120)
                        .frame(maxWidth: .infinity)
                }

                Button(action: {
                showAlert = true
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                        .padding()
                }

                VStack {
                    Spacer()
                    HStack {
                        let maxQuantity = lineItem.maxAvailableQuantity ?? 10
                        let limitThreshold = maxQuantity / 3
                        HStack(spacing: 8) {
                            Button(action: {
                                if let quantity = lineItem.quantity {
                                    onQuantityChange(quantity - 1)
                                }
                            }) {
                                Image(systemName: "minus")
                                    .font(.system(size: 12))
                                    .frame(width: 24, height: 24)
                                    .background(Circle().fill(Color.primaryColor))
                                    .foregroundColor(.white)
                            }.disabled( lineItem.quantity == 1)

                            Text("\(lineItem.quantity ?? 1)")
                                .font(.subheadline)
                                .frame(width: 20)
                                .bold()

                            Button(action: {
                                let quantity = lineItem.quantity ?? 1
                               
                                if lineItem.quantity ?? 1 > limitThreshold {
                                    showToast = true
                                }else{
                                    onQuantityChange(quantity + 1)
                                }
                            }) {
                                Image(systemName: "plus")
                                    .font(.system(size: 12))
                                    .frame(width: 24, height: 24)
                                    .background(Circle().fill(Color.primaryColor))
                                    .foregroundColor(.white)
                            }
                            
                        }
                        .padding(6)
                        .background(Color.primaryColor.opacity(0.1))
                        .cornerRadius(16)

                        Spacer()
                    }
                    .padding(.leading, 16)
                    .padding(.bottom, 12)
                }
            }
            .background(Color.white)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.primaryColor, lineWidth: 2)
            )
            .padding(.horizontal)

            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(lineItem.title ?? "No Title")
                        .fontWeight(.bold)
                    HStack {
                        Text("Color:")
                            .foregroundColor(.gray)
                        Text(lineItem.properties?[0].value ?? "No Color")
                            .padding(.leading, 4)
                    }
                }

                Spacer()

                Text("\(String(format: "%.2f %@", (Double(lineItem.price ?? "0.00") ?? 0.00) * Double(lineItem.quantity ?? 1) * (Double(UserDefaultManager.shared.currencyRate ?? "1.0") ?? 1.0), UserDefaultManager.shared.currency ?? "USD"))")
                    .bold()

            }
            .padding()
        }.alert(isPresented: $showAlert){
            Alert(
                title: Text("Delete Product"),
                message: Text("Are you sure you want to delete this product from cart?"),
                primaryButton: .destructive(Text("Delete")) {
                    onDeleteLineItem()
                },
                secondaryButton: .cancel()
            )
        }
        .overlay(
            Group {
                if showToast {
                    Text("You exceeds your limit")
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(Color.black.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .transition(.move(edge: .top))
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                showToast = false
                            }
                        }
                        .padding(.top, 50)
                }
            },
            alignment: .top
        )

    }
}

/*#Preview {
    CartItem()
}*/
