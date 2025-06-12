//
//  RegisterSuccessView.swift
//  Shoplet
//
//  Created by Macos on 10/06/2025.
//

import SwiftUI

struct RegisterSuccessView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.green)

            Text("Register Success")
                .font(.title).bold()

            Text("Congratulations! Your account is created. Please login to get amazing experience.")
                .multilineTextAlignment(.center)
                .padding()

            Button("Go to Homepage") {
                // Navigate to home screen
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}


#Preview {
    RegisterSuccessView()
}
