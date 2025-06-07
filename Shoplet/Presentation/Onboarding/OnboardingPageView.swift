//
//  OnboardingPageView.swift
//  Shoplet
//
//  Created by Macos on 07/06/2025.
//

import SwiftUI

struct OnboardingItem: Identifiable {
    let id = UUID()
    let imageName: String
    let title: String
    let subtitle: String
}
struct OnboardingPageView: View {
    let item: OnboardingItem
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(spacing: 20) {
            Image(item.imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 450)
                .cornerRadius(20)
            
            Text(item.title)
                .font(.title2).bold()
                .multilineTextAlignment(.center)
                .foregroundColor(colorScheme == .dark ? .white : .black)
                .padding(.horizontal)
                .lineLimit(2)
            
            Text(item.subtitle)
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Spacer()
        }
        .padding(.top)
        .background(Color.adaptiveBackground(for: colorScheme))
        .ignoresSafeArea()
    }
}


