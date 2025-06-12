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
    @State private var hasCreatedAccount = false

    var body: some View {
        Group {
            if !hasSeenSplash {
                SplashScreen(hasSeenSplash: $hasSeenSplash)
            } else if !hasCompletedOnboarding {
                OnboardingScreen(hasCompletedOnboarding: $hasCompletedOnboarding)
            } else if !hasCreatedAccount {
                CreateAccountView(hasCreatedAccount: $hasCreatedAccount)
            } else {
                CustomeTabBarView()
            }
        }
    }
}


#Preview {
    ContentView()
}
