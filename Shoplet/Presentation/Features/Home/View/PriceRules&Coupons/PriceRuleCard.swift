//
//  PriceRuleCard.swift
//  Shoplet
//
//  Created by Macos on 08/06/2025.
//

import SwiftUI

struct PriceRuleCard: View {
    var priceRule: String
    var imageName: String

    var body: some View {
        let discount = abs(Int(Double(priceRule) ?? 0))
        ZStack {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(height: 150)
                .clipped()
                .cornerRadius(20)
            
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("SALE")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.white)
                    
                    Text("Enjoy Discount Up To")
                        .font(.footnote)
                        .foregroundColor(.white.opacity(0.9))
                }
                
                Spacer()
                
                Text("\(discount)%")
                    .font(.system(size: 40, weight: .black))
                    .foregroundColor(.white)
                    .padding(.trailing, 10)
            }
            .padding(.horizontal)
        }
        .frame(height: 200)
        .padding(.horizontal)
        .shadow(radius: 4)
    }
}

#Preview {
    PriceRuleCard(priceRule: "5", imageName: "")
}
