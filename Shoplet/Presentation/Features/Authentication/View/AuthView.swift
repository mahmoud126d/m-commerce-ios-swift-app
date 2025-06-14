//
//  AuthView.swift
//  Shoplet
//
//  Created by Macos on 14/06/2025.
//

import SwiftUI

struct AuthView: View {
    @State private var currentScreen: AuthScreen = .signIn
    @AppStorage("isUserLoggedIn") private var isUserLoggedIn = false
    @State private var exploreAsGuest = false

    var body: some View {
        NavigationStack {
            VStack {
                switch currentScreen {
                case .signIn:
                    SignInView(
                        switchToCreateAccount: {
                            currentScreen = .createAccount
                        },
                        onSuccessfulLogin: {
                            isUserLoggedIn = true
                        },
                        onExploreAsGuest: {
                            UserDefaultManager.shared.isUserLoggedIn = false
                            UserDefaultManager.shared.customerId = nil
                            exploreAsGuest = true
                        }
                    )

                case .createAccount:
                    CreateAccountView(
                        switchToSignIn: {
                            currentScreen = .signIn
                        },
                        onSuccessfulCreation: {
                            isUserLoggedIn = true
                        }
                    )
                }

                NavigationLink(
                    destination: CustomeTabBarView(homeViewModel: HomeViewModel(), userDefaultManager: UserDefaultManager.shared),
                    isActive: $exploreAsGuest
                ) {
                    EmptyView()
                }
            }
        }
    }
}


#Preview {
    AuthView()
}
