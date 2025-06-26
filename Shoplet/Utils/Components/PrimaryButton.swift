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

struct TransparentBorderButton: View {
    var title: String
    var action: () -> Void
    var cornerRadius: CGFloat = 18
    var height: CGFloat = 50
    var font: Font = .headline

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(font)
                .foregroundColor(.primaryColor)
                .frame(maxWidth: .infinity, minHeight: height)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(Color.primaryColor, lineWidth: 2)
                )
        }
        .background(Color.clear)
        .cornerRadius(cornerRadius)
        .padding(.horizontal, 30)
    }
}


#Preview {
    PrimaryButton(title: "Continue", action: {})
}
