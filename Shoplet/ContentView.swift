//
//  ContentView.swift
//  Shoplet
//
//  Created by Macos on 04/06/2025.
//

import SwiftUI

import SwiftUI

struct ContentView: View {
    @State private var hasSeenSplash = false
    @State private var hasCompletedOnboarding = false
    
    var body: some View {
        CustomeTabBarView()

        //currentView
        //AllProductTest()
    }

    @ViewBuilder
    private var currentView: some View {
        if !hasSeenSplash {
            SplashScreen(hasSeenSplash: $hasSeenSplash)
        } else if !hasCompletedOnboarding {
            OnboardingScreen()
        }
    }
}


#Preview {
    ContentView()
}
