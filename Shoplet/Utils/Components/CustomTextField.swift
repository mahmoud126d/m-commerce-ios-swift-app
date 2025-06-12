//
//  CustomTextField.swift
//  Shoplet
//
//  Created by Macos on 10/06/2025.
//

import SwiftUI

struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    @FocusState private var isFocused: Bool

    var body: some View {
        TextField(placeholder, text: $text)
            .keyboardType(keyboardType)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(isFocused ? Color.primaryColor : Color.gray.opacity(0.5), lineWidth: 2)
            )
            .focused($isFocused)
    }
}

struct CustomSecureField: View {
    var placeholder: String
    @Binding var text: String
    @FocusState private var isFocused: Bool

    var body: some View {
        SecureField(placeholder, text: $text)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(isFocused ? Color.primaryColor : Color.gray.opacity(0.5), lineWidth: 2)
            )
            .focused($isFocused)
    }
}

