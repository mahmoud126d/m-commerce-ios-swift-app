//
//  SplashScreen.swift
//  Shoplet
//
//  Created by Macos on 07/06/2025.
//

import SwiftUI

struct SplashScreen: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var hasSeenSplash: Bool

    var body: some View {
        VStack {
            Image(imageName)
                .resizable()
                .frame(width: 500, height: 500)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(backgroundColor)
        .ignoresSafeArea()
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    hasSeenSplash = true
                }
            }
        }
    }

    private var imageName: String {
        colorScheme == .dark ? "2" : "1"
    }

    private var backgroundColor: Color {
        colorScheme == .dark
            ? Color(red: 111/255, green: 79/255, blue: 56/255)
            : Color.white
    }
}


#Preview {
    SplashScreen(hasSeenSplash: .constant(false))
}
