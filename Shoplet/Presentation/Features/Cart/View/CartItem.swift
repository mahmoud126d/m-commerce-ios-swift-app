//
//  CartItem.swift
//  Shoplet
//
//  Created by Macos on 11/06/2025.
//

import SwiftUI

struct CartItem: View {
     var lineItem : LineItem
    @StateObject var cartViewModel = CartViewModel()
    var onQuantityChange: (Int) -> Void
    var onDeleteLineItem: () -> Void
    var body: some View {
        VStack{
            ZStack(alignment: .topTrailing) {
                AsyncImage(url: URL(string: lineItem.properties?[1].value ?? "")) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 350, height: 100)
                        .cornerRadius(20)
                } placeholder: {
                    ProgressView()
                }
                .padding(.horizontal, 8)

                Button(action: {
                    onDeleteLineItem()
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                        .padding(.trailing, 30)
                }

                VStack {
                    Spacer()
                    HStack {
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
                            }

                            Text("\(lineItem.quantity ?? 1)")
                                .font(.subheadline)
                                .frame(width: 20)

                            Button(action: {
                                let quantity = lineItem.quantity ?? 1
                                onQuantityChange(quantity + 1)

                            }) {
                                Image(systemName: "plus")
                                    .font(.system(size: 12))
                                    .frame(width: 24, height: 24)
                                    .background(Circle().fill(Color.primaryColor))
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(4)
                        .background(Color.primaryColor.opacity(0.1))
                        .cornerRadius(16)


                        Spacer()
                    }
                    .padding(.leading, 24)
                    .padding(.bottom, 12)
                }
            }


            HStack{
                VStack{
                    Text(lineItem.title ?? "No Title")
                        .fontWeight(.bold)
                    HStack{
                        Text("Color: ")
                            .foregroundColor(.gray)
                        Text("\(lineItem.properties![0].value ?? "No Color")")
                            .padding(.leading, 8)
                    }
                }
                Text("\(String(format: "USD %.0.2f", (Double(lineItem.price ?? "0.00") ?? 0.00) * Double(lineItem.quantity ?? 1)))")
                    .bold()
            }
        }
    }
}

/*#Preview {
    CartItem()
}*/
