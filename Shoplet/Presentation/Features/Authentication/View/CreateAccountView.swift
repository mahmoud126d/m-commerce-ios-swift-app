//
//  CreateAccountView.swift
//  Shoplet
//
//  Created by Macos on 10/06/2025.
//

import SwiftUI

import SwiftUI

struct CreateAccountView: View {
    @Binding var hasCreatedAccount: Bool

    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var phone = ""
    @State private var firstName = ""
    @State private var lastName = ""
    
    @State private var navigateToVerification = false

    @StateObject private var viewModel = CustomerViewModel(
        createCustomerUseCase: DefaultCreateCustomerUseCase(
            repository: CustomerRepositoryImpl()
        )
    )

    var body: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 8) {
                Spacer()
                Text("Create Account")
                    .font(.largeTitle).bold()
                    .foregroundColor(.primaryColor)

                Text("Start shopping with create your account in Shoplet")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            CustomTextField(placeholder: "First Name", text: $firstName)
            CustomTextField(placeholder: "Last Name", text: $lastName)
            CustomTextField(placeholder: "Phone Number", text: $phone, keyboardType: .phonePad)
            CustomTextField(placeholder: "Email", text: $email, keyboardType: .emailAddress)
            CustomSecureField(placeholder: "Password", text: $password)
            CustomSecureField(placeholder: "Confirm Password", text: $confirmPassword)

            if viewModel.isLoading {
                ProgressView()
            }

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
            }

            PrimaryButton(title: "Create Account") {
                guard password == confirmPassword else {
                    viewModel.errorMessage = "Passwords do not match"
                    return
                }

                let request = CustomerRequest(
                       customer: Customer(
                           password_confirmation: confirmPassword,
                           phone: phone,
                           password: password,
                           last_name: lastName,
                           send_email_welcome: false,
                           verified_email: true,
                           //addresses: [],
                           email: email,
                           first_name: firstName
                       )
                   )
                
                print(request)


                viewModel.createCustomer(request)
            }

            HStack {
                Spacer()
                Text("Or using other method")
                    .foregroundColor(.gray)
                Spacer()
            }

            Button("Sign Up with Google") {}
                .buttonStyle(.bordered)

            NavigationLink(
                destination: VerificationView(email: email),
                isActive: $navigateToVerification
            ) {
                EmptyView()
            }
        }
        .padding()
        .onReceive(viewModel.$customer) { customer in
            if customer != nil {
                navigateToVerification = true
            }
        }
    }
}

#Preview {
    CreateAccountView(hasCreatedAccount: .constant(false))
}


