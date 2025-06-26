//
//  SignInView.swift
//  Shoplet
//
//  Created by Macos on 14/06/2025.
//

import Foundation
import SwiftUI

struct SignInView: View {
    var switchToCreateAccount: () -> Void
    var onSuccessfulLogin: () -> Void
    var onExploreAsGuest: () -> Void

    @State private var email = ""
    @State private var password = ""

    @StateObject private var viewModel = CustomerViewModel(
        createCustomerUseCase: DefaultCreateCustomerUseCase(repository: CustomerRepositoryImpl()),
        getAllCustomersUseCase: DefaultGetAllCustomersUseCase(repository: CustomerRepositoryImpl())
    )

    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Sign In")
                            .font(.largeTitle).bold()
                            .foregroundColor(.primaryColor)
                        Text("Welcome back!")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    CustomTextField(placeholder: "Email", text: $email, keyboardType: .emailAddress)
                    CustomSecureField(placeholder: "Password", text: $password)

                    if viewModel.isLoading {
                        ProgressView()
                    }

                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                    }

                    PrimaryButton(title: "Sign In") {
                        guard !email.isEmpty, !password.isEmpty else {
                            viewModel.errorMessage = "Enter both email and password"
                            return
                        }

                        viewModel.signInWithFirebaseAndShopify(email: email, password: password) { success in
                            if success {
                                onSuccessfulLogin()
                            }
                        }
                    }

                    HStack {
                        Text("Don't have an account?").foregroundColor(.gray)
                        Button(action: switchToCreateAccount) {
                            Text("Create one").foregroundColor(.primaryColor).bold()
                        }
                    }
                }
                .padding()
            }

            Spacer()

            Button(action: {
                onExploreAsGuest()
            }) {
                Text("Explore as Guest")
                    .font(.headline)
                    .foregroundColor(.primaryColor)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(Color.primaryColor, lineWidth: 2)
                    )
            }
            .background(Color.white)
            .cornerRadius(18)
            .padding(.horizontal, 30)
            .padding(.bottom, 20)
        }
        .ignoresSafeArea(.keyboard)
    }
}

struct SignInWrapperView: View {
    @Environment(\.dismiss) var dismiss
    @State private var navigateToCreateAccount = false

    var body: some View {
        VStack {
            SignInView(
                switchToCreateAccount: {
                    navigateToCreateAccount = true
                },
                onSuccessfulLogin: {
                },
                onExploreAsGuest: {
                    dismiss()
                }
            )
            .navigationBarBackButtonHidden(true)

            NavigationLink(
                destination: CreateAccountView(
                    switchToSignIn: {},
                    onSuccessfulCreation: {}
                ),
                isActive: $navigateToCreateAccount
            ) {
                EmptyView()
            }
        }
    }
}
