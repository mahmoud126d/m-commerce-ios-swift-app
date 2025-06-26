//
//  AuthRestrictionAlert.swift
//  Shoplet
//
//  Created by Macos on 26/06/2025.
//

import SwiftUI

struct AuthRestrictionAlert: View {
    var onDismiss: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("Access Restricted")
                .font(.title2).bold()
                .foregroundColor(.primaryColor)

            Text("To access this feature, please go to the Profile tab to sign in or register.")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)

            Button(action: onDismiss) {
                Text("OK")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50)
                    .background(Color.primaryColor)
                    .cornerRadius(18)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
        .padding(30)
    }
}

