//
//  PriceRuleCard.swift
//  Shoplet
//
//  Created by Macos on 08/06/2025.
//

import SwiftUI

struct PriceRuleCard: View{
    var priceRule : String
    var body: some View {
        let discount = abs(Int(Double(priceRule) ?? 0))
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.orange.opacity(0.9))
                .frame(height: 100)
                .shadow(radius: 4)
            
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
        .padding(.horizontal)
    }
}


#Preview {
    PriceRuleCard(priceRule: "5")
}
