//
//  ContentView.swift
//  Shoplet
//
//  Created by Macos on 04/06/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var hasSeenSplash = false
    @State private var hasCompletedOnboarding = false
    @AppStorage("isUserLoggedIn") private var isUserLoggedIn = false
    @StateObject var homeViewModel = HomeViewModel()
    var body: some View {
        Group {
            if !hasSeenSplash {
                SplashScreen(hasSeenSplash: $hasSeenSplash)
            } else if !hasCompletedOnboarding && !isUserLoggedIn{
                OnboardingScreen(hasCompletedOnboarding: $hasCompletedOnboarding)
            } else if !isUserLoggedIn {
                AuthView()
            }
            else {
                CustomeTabBarView(homeViewModel: homeViewModel, userDefaultManager: UserDefaultManager.shared)
            }
        }
    }
}


#Preview {
    ContentView()
}
