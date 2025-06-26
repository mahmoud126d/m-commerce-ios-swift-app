//
//  GuestModeProfileView.swift
//  Shoplet
//
//  Created by Macos on 26/06/2025.
//

import SwiftUI

struct GuestModeProfileView: View {
    var body: some View {
        VStack(spacing: 40) {
            Spacer()

            LottieView(animationName: "profile-lottie")
                .frame(width: 250, height: 250)

            Text("You're in Guest Mode")
                .font(.title3)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)

            NavigationLink(destination: SignInWrapperView()) {
                Text("Sign In")
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.primaryColor)
                    .cornerRadius(12)
                    .padding(.horizontal, 40)
            }

            Spacer()
        }
        .navigationTitle("Guest Profile")
    }
}


#Preview {
    GuestModeProfileView()
}
