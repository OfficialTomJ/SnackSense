//
//  LoginView.swift
//  SnackSense
//
//  Created by Tom on 27/5/2025.
//

import SwiftUI
import Auth0

struct LoginView: View {
    @State private var isAuthenticated = false
    @State private var accessToken: String?
    @State private var loginError: String?
    @State private var navigateToStart = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("SnackSense Login")
                    .font(.title)
                    .fontWeight(.bold)

                if isAuthenticated {

                    Button("Log Out") {
                        Auth0.webAuth().clearSession { result in
                            isAuthenticated = false
                            UserDefaults.standard.set(false, forKey: "isLoggedIn")
                            accessToken = nil
                        }
                    }
                } else {
                    Button("Login with Auth0") {
                        Auth0.webAuth()
                            .start { result in
                                switch result {
                                case .success(let credentials):
                                    self.isAuthenticated = true
                                    self.accessToken = credentials.accessToken
                                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                                    print("✅ Access token: \(credentials.accessToken ?? "")")
                                    self.navigateToStart = true
                                case .failure(let error):
                                    self.loginError = error.localizedDescription
                                    print("❌ Login failed: \(error)")
                                }
                            }
                    }
                    .buttonStyle(.borderedProminent)
                }
                NavigationLink(destination: StartView(), isActive: $navigateToStart) {
                    EmptyView()
                }
                .hidden()
            }
            .padding()
            .onAppear {
                let loggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
                self.isAuthenticated = loggedIn
                self.navigateToStart = loggedIn
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
