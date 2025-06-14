//
//  CustomeTabBarView.swift
//  Shoplet
//
//  Created by Farid on 10/06/2025.
//

import SwiftUI

struct CustomeTabBarView: View {
    @State private var selectedTab: Tab = .home
    @ObservedObject var homeViewModel : HomeViewModel
    @ObservedObject var userDefaultManager : UserDefaultManager
    enum Tab {
        case home, category, cart, favorite, profile
    }
    var body: some View {
        ZStack(alignment: .bottom) {
                    // MARK: - Tab Screens
                    Group {
                        switch selectedTab {
                        case .home: HomeView()
                        case .category: CategoryView()
                        case .favorite: FavoriteView()
                        case .profile:  MeView()
                        case .cart: CartView()
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                    // MARK: - Custom Tab Bar
                    ZStack {
                        Rectangle()
                            .fill(Color.white)
                            .frame(height: 80)
                            .shadow(color: .gray.opacity(0.2), radius: 4, y: -2)

                        HStack {
                            TabButton(icon: "house", title: "Home", tab: .home, selectedTab: $selectedTab)
                            TabButton(icon: "square.grid.2x2", title: "Category", tab: .category, selectedTab: $selectedTab)

                            Spacer(minLength: 60) // Space for floating cart

                            TabButton(icon: "heart", title: "Favorite", tab: .favorite, selectedTab: $selectedTab)
                            TabButton(icon: "person", title: "Profile", tab: .profile, selectedTab: $selectedTab)
                        }
                        .padding(.horizontal, 0)
                        .padding(.top, 12)
                        .padding(.bottom, 10)

                        // MARK: - Floating Cart Button
                        ZStack {
                            Button(action: {
                                selectedTab = .cart
                            }) {
                                Image(systemName: "cart.fill")
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(20)
                                    .background(Color.primaryColor)
                                    .clipShape(Circle())
                                    .shadow(radius: 5)
                            }

                            if userDefaultManager.getNumOfCartItems() > 0 {
                                Text("\(userDefaultManager.getNumOfCartItems())")
                                    .font(.caption2)
                                    .foregroundColor(.white)
                                    .padding(8)
                                    .background(Color.red)
                                    .clipShape(Circle())
                                    .offset(x: 15, y: -25)
                            }
                        }
                        .offset(y: -35)
                    }
        }
                .ignoresSafeArea(edges: .bottom)
    }
        }

struct TabButton: View {
    var icon: String
    var title: String
    var tab: CustomeTabBarView.Tab
    @Binding var selectedTab: CustomeTabBarView.Tab

    var body: some View {
        Button(action: {
            selectedTab = tab
        }) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(selectedTab == tab ? .primaryColor : .gray)
                Text(title)
                    .font(.caption)
                    .foregroundColor(selectedTab == tab ? .primaryColor : .gray)
            }
            .frame(maxWidth: .infinity)
        }
    }
}
#Preview {
    CustomeTabBarView(homeViewModel: HomeViewModel(), userDefaultManager: UserDefaultManager.shared)
}
