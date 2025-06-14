//
//  PrimaryButton.swift
//  Shoplet
//
//  Created by Macos on 10/06/2025.
//

import SwiftUI

import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.primaryColor)
                .foregroundColor(.white)
                .cornerRadius(25)
                .padding(.horizontal, 30)
        }
    }
}

#Preview {
    PrimaryButton(title: "Continue", action: {})
}
