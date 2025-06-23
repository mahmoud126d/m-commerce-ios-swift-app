import SwiftUI

struct CurrencyView: View {
    @StateObject var currencyViewModel = CurrencyViewModel()

    var body: some View {
        ZStack {
            VStack {
                Text("Currency")
                    .font(.title2)
                    .bold()
                    .padding(.top, 16)

                TextField("Search currency...", text: $currencyViewModel.searchText)
                    .padding(12)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .padding(.top, 8)

                Spacer(minLength: 12)

                if currencyViewModel.isLoading {
                    ProgressView()
                    Spacer()
                } else {
                    ScrollView(showsIndicators: false) {
                        ForEach(currencyViewModel.filteredCurrencies(), id: \.key) { key, value in
                            HStack {
                                Text("\(key) - \(currencyViewModel.currencyNames[key] ?? "Unknown")")
                                Spacer()
                                Text(String(format: "%.2f", Double(value) ?? 0.0))
                                    .foregroundColor(.gray)
                            }
                            .padding(14)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(12)
                            .onTapGesture {
                                currencyViewModel.selectCurrency(code: key, rate: value)
                            }
                        }
                        .padding(.bottom, 100)
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                }
            }
            .onAppear {
                currencyViewModel.getCurrencies()
            }

            if currencyViewModel.showToast {
                VStack {
                    Spacer()
                    Text("Currency updated to \(currencyViewModel.selectedCurrencyName)")
                        .font(.subheadline)
                        .padding()
                        .background(Color.primaryColor)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .padding(.bottom, 50)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                withAnimation {
                                    currencyViewModel.showToast = false
                                }
                            }
                        }
                }
                .animation(.easeInOut, value: currencyViewModel.showToast)
            }
        }
    }
}

#Preview {
    CurrencyView()
}
