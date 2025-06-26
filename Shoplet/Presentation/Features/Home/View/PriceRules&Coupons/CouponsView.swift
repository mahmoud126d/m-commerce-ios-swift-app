//
//  CouponsView.swift
//  Shoplet
//
//  Created by Macos on 08/06/2025.
//

import SwiftUI

struct CouponsView: View {
    @StateObject private var viewModel = CouponViewModel()
    private let images = ["adsImage", "adsImage2"]
    var body: some View {
            TabView {
                ForEach(viewModel.priceRules, id: \.id) { item in
                    NavigationLink(destination: {
                        Coupons(PriceRuleId: item.id)
                    }, label: {
                        PriceRuleCard(priceRule: item.value, imageName: images.randomElement() ?? "adsImage")
                            .frame(width: UIScreen.main.bounds.width - 40)
                            .padding(.horizontal, 20)
                    })
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .automatic))
            .frame(height: 200)
            .onAppear {
                viewModel.getPriceRules()
            }
        }
    }


#Preview {
    CouponsView()
}
