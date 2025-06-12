//
//  VerificationView.swift
//  Shoplet
//
//  Created by Macos on 10/06/2025.
//

import SwiftUI

struct VerificationView: View {
    let email: String
    @State private var code: [String] = ["", "", "", ""]
    @FocusState private var focusedIndex: Int?

    @State private var navigateToSuccess = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Verification Code")
                .font(.title2).bold()
            Text("We have sent the code to \(email)")
                .font(.subheadline)
                .foregroundColor(.gray)

            HStack(spacing: 12) {
                ForEach(0..<4) { index in
                    TextField("", text: $code[index])
                        .keyboardType(.numberPad)
                        .frame(width: 50, height: 50)
                        .multilineTextAlignment(.center)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .focused($focusedIndex, equals: index)
                        .onChange(of: code[index]) { _ in
                            if index < 3 && !code[index].isEmpty {
                                focusedIndex = index + 1
                            }
                        }
                }
            }

            Button("Submit") {
                navigateToSuccess = true
            }
            .buttonStyle(.borderedProminent)

            Button("Didn’t receive the code? Resend") {}
                .font(.footnote)
                .foregroundColor(.blue)

            NavigationLink(destination: RegisterSuccessView(), isActive: $navigateToSuccess) {
                EmptyView()
            }
        }
        .padding()
        .onAppear { focusedIndex = 0 }
    }
}

#Preview {
    VerificationView(email: "nadagharib2044@gmail.com")
}
