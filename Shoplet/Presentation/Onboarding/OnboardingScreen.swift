//
//  OnboardingScreen.swift
//  Shoplet
//
//  Created by Macos on 07/06/2025.
//

import SwiftUI

struct OnboardingScreen: View {
    @Binding var hasCompletedOnboarding: Bool
    
    let onboardingItems = [
        OnboardingItem(
            imageName: "bag1",
            title: "Various Collections Of The Latest Products",
            subtitle: "Discover new arrivals from trusted global brands\nand shop with confidence every day."
        ),
        OnboardingItem(
            imageName: "bag2",
            title: "Complete Collection Of Colors And Sizes",
            subtitle: "Choose from a full range of colors and sizes that fit\nyour unique style and needs."
        ),
        OnboardingItem(
            imageName: "bag3",
            title: "Find The Most Suitable Outfit For You",
            subtitle: "Let your wardrobe speak with outfits made just for you\nfrom casual to classy looks."
        )
    ]

    @State private var currentIndex = 0

    var body: some View {
        VStack {
            TabView(selection: $currentIndex) {
                ForEach(0..<onboardingItems.count, id: \.self) { index in
                    OnboardingPageView(item: onboardingItems[index])
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            HStack(spacing: 8) {
                ForEach(0..<onboardingItems.count, id: \.self) { index in
                    Circle()
                        .fill(currentIndex == index ? Color.primaryColor : Color.gray.opacity(0.4))
                        .frame(width: 10, height: 10)
                }
            }
            .padding(.top, 20)

            if currentIndex == onboardingItems.count - 1 {
                Button(action: {
                    hasCompletedOnboarding = true
                }) {
                    Text("Create Account")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.primaryColor)
                        .foregroundColor(.white)
                        .cornerRadius(25)
                        .padding(.horizontal, 30)
                }
            } else {
                Button(action: {
                    withAnimation {
                        currentIndex += 1
                    }
                }) {
                    Text("Next")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.primaryColor)
                        .foregroundColor(.white)
                        .cornerRadius(25)
                        .padding(.horizontal, 30)
                }
            }

            Text("Already Have an Account")
                .foregroundColor(.primaryColor)
                .font(.footnote)
                .padding(.top, 10)
        }
        .padding(.top)
    }
}

//
//#Preview {
//    OnboardingScreen()
//}
