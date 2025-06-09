//
//  OnboardingScreen.swift
//  Shoplet
//
//  Created by Macos on 07/06/2025.
//

import SwiftUI

struct OnboardingScreen: View {
    let onboardingItems = [
        OnboardingItem(imageName: "bag1", title: "Various Collections Of The Latest Products", subtitle: "Urna amet, suspendisse ullamcorper ac elit diam facilisis cursus vestibulum."),
        OnboardingItem(imageName: "bag2", title: "Complete Collection Of Colors And Sizes", subtitle: "Urna amet, suspendisse ullamcorper ac elit diam facilisis cursus vestibulum."),
        OnboardingItem(imageName: "bag3", title: "Find The Most Suitable Outfit For You", subtitle: "Urna amet, suspendisse ullamcorper ac elit diam facilisis cursus vestibulum.")
    ]
    
    @State private var currentIndex = 0
    @State private var isNextScreenActive = false
    
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
                NavigationLink(
                    destination: AllProductTest(),
                    isActive: $isNextScreenActive
                ) {
                    Button(action: {
                        isNextScreenActive = true
                    }) {
                        Text("Create Account")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.primaryColor)
                            .foregroundColor(.white)
                            .cornerRadius(25)
                            .padding(.horizontal, 30)
                    }
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


#Preview {
    OnboardingScreen()
}
