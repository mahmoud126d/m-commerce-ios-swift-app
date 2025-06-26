import SwiftUI

struct MeView: View {
    @StateObject var profileViewModel: ProfileViewModel
    @State private var showLogoutAlert = false
    @State private var navigateToSignUp = false

    init(profileViewModel: ProfileViewModel = ProfileViewModel()) {
        _profileViewModel = StateObject(wrappedValue: profileViewModel)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {

                // MARK: - Header
                VStack(alignment: .leading, spacing: 16) {
                    HStack(spacing: 16) {
                        Image("avatar")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                            .shadow(radius: 4)

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Hello,")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.9))

                            Text("\(profileViewModel.customer?.first_name ?? "") \(profileViewModel.customer?.last_name ?? "")")
                                .font(.title2).bold()
                                .foregroundColor(.white)

                            Text(profileViewModel.customer?.email ?? "")
                                .font(.footnote)
                                .foregroundColor(.white.opacity(0.85))
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 60)
                .padding(.horizontal)
                .padding(.bottom, 24)
                .background(
                    Color.primaryColor
                        .clipShape(RoundedCorner(radius: 20, corners: [.bottomLeft, .bottomRight]))
                )

                // MARK: - List
                List {
                    Section(header: Text("Account")) {
                        HStack {
                            Text("Email")
                            Spacer()
                            Text(profileViewModel.customer?.email ?? "")
                                .foregroundColor(.gray)
                        }

                        HStack {
                            Text("Currency")
                            Spacer()
                            Text(UserDefaultManager.shared.currency ?? "USD")
                                .foregroundColor(.gray)
                        }
                    }

                    Section(header: Text("Settings")) {
                        if let customerId = profileViewModel.customer?.id {
                            NavigationLink(destination: OrdersListView(customerId: customerId)) {
                                Text("Orders")
                            }
                        
                           }
                        NavigationLink(destination: AddressesView(isCheckout: false)) {
                            Text("Addresses")
                        }
                        NavigationLink(destination: CurrencyView()) {
                            Text("Currency")
                        }
                    }

                    Section {
                        Text("About")
                        Text("Support")
                    }

                    Section {
                        Button(action: {
                            showLogoutAlert = true
                        }) {
                            Text("Logout")
                                .foregroundColor(.red)
                        }
                        .alert(isPresented: $showLogoutAlert) {
                            Alert(
                                title: Text("Confirm Logout"),
                                message: Text("Are you sure you want to logout?"),
                                primaryButton: .destructive(Text("Logout")) {
                                    UserDefaultManager.shared.clearUserDefaults()
                                    navigateToSignUp = true
                                },
                                secondaryButton: .cancel()
                            )
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())

                Spacer()

                NavigationLink(
                    destination: CreateAccountView(
                        switchToSignIn: {},
                        onSuccessfulCreation: {}
                    )
                    .navigationBarBackButtonHidden(true),
                    isActive: $navigateToSignUp
                ) {
                    EmptyView()
                }
            }
            .edgesIgnoringSafeArea(.top)
            .onAppear {
                profileViewModel.getCustomer()
            }
        }
    }
}


struct RoundedCorner: Shape {
    var radius: CGFloat = 25.0
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
