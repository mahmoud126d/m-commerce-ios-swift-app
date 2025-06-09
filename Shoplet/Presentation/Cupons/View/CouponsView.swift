//
//  CouponsView.swift
//  Shoplet
//
//  Created by Macos on 08/06/2025.
//

import SwiftUI

struct CouponsView: View {
    @StateObject private var viewModel = CouponViewModel()
    var body: some View {
        NavigationView{
            ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(viewModel.priceRules, id: \.id) { item in
                                NavigationLink(destination: {
                                    Coupons(PriceRuleId: item.id)
                                },
                                              label: {
                                   PriceRuleCard(priceRule: item.value)
                                       .frame(width: 300)
                               })
                            }
                        }
                    }
        }
                    .onAppear{
                        viewModel.getPriceRules()
                    }
        }
    }


#Preview {
    CouponsView()
}
