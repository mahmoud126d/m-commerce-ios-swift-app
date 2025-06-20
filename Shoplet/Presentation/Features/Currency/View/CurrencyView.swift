//
//  CurrencyView.swift
//  Shoplet
//
//  Created by Macos on 20/06/2025.
//

import SwiftUI

struct CurrencyView: View {
    var currencies:[String:String] = ["EG":"14.10", "USD":"14.10", "AGLD":"14.10"]
    @StateObject var currencyViewModel = CurrencyViewModel()
    var body: some View {
        VStack{
            Text("Currency")
            Spacer()
            if currencyViewModel.isLoading{
                ProgressView()
                Spacer()
            }else{
                ScrollView(showsIndicators: false){
                    ForEach(Array(currencyViewModel.currencies?.enumerated() ?? [:].enumerated()), id: \.element.key){
                        index, item in
                        HStack{
                            Text("\(item.key) - \(currencyViewModel.currencyNames[item.key] ?? "UnKown")")
                            Spacer()
                            Text(String(format: "%.2f", Double(item.value) ?? 0.0))
                                .foregroundColor(.gray)
                        }
                        .padding(14)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(12)
                        .onTapGesture {
                            UserDefaultManager.shared.currency = item.key
                            UserDefaultManager.shared.currencyRate = item.value
                        }
                    }.padding(.bottom, 100)
                }.padding(.horizontal)
                    .padding(.top, 24)
            }
                
                
        }.onAppear{
            currencyViewModel.getCurrencies()
        }
    }
}

#Preview {
    CurrencyView()
}
