// CreateAccountView.swift

import SwiftUI

struct CreateAccountView: View {
    var switchToSignIn: () -> Void
    var onSuccessfulCreation: () -> Void

    @State private var email = ""
    @State private var phone = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var password = ""
    @State private var confirmPassword = ""

    @StateObject private var viewModel = CustomerViewModel(
        createCustomerUseCase: DefaultCreateCustomerUseCase(repository: CustomerRepositoryImpl()),
        getAllCustomersUseCase: DefaultGetAllCustomersUseCase(repository: CustomerRepositoryImpl())
    )

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.white.ignoresSafeArea()

                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Create Account")
                            .font(.largeTitle).bold()
                            .foregroundColor(.primaryColor)

                        Text("Start shopping by creating your account in Shoplet")
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
                        guard !email.isEmpty,
                              !firstName.isEmpty,
                              !lastName.isEmpty,
                              !phone.isEmpty,
                              !password.isEmpty,
                              password == confirmPassword else {
                            viewModel.errorMessage = "Please fill all fields and ensure passwords match."
                            return
                        }

                        let request = CustomerRequest(
                            customer: Customer(
                                id: nil,
                                email: email,
                                created_at: nil,
                                updated_at: nil,
                                first_name: firstName,
                                last_name: lastName,
                                orders_count: nil,
                                state: nil,
                                total_spent: nil,
                                last_order_id: nil,
                                note: nil,
                                verified_email: true,
                                multipass_identifier: nil,
                                tax_exempt: nil,
                                tags: nil,
                                last_order_name: nil,
                                currency: nil,
                                phone: phone,
                                addresses: nil,
                                tax_exemptions: nil,
                                email_marketing_consent: nil,
                                sms_marketing_consent: nil,
                                admin_graphql_api_id: nil,
                                default_address: nil,
                                password: password,
                                password_confirmation: confirmPassword
                            )
                        )
                        viewModel.registerUserWithFirebaseAndShopify(email: email, password: password, customerRequest: request)
                    }

                    HStack {
                        Text("Already have an account?")
                            .foregroundColor(.gray)

                        Button(action: switchToSignIn) {
                            Text("Sign In")
                                .foregroundColor(.primaryColor)
                                .bold()
                        }
                    }

                    Spacer()
                }
                .padding()
                .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
            }
        }
        .onReceive(viewModel.$customer) { customer in
            if customer != nil {
                onSuccessfulCreation()
            }
        }
    }
}

