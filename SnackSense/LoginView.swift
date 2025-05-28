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

    var body: some View {
        VStack(spacing: 24) {
            Text("SnackSense Login")
                .font(.title)
                .fontWeight(.bold)

            if isAuthenticated {
                Text("✅ Logged in!")
                    .foregroundColor(.green)

                Button("Log Out") {
                    Auth0.webAuth().clearSession { result in
                        isAuthenticated = false
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
                                print("✅ Access token: \(credentials.accessToken ?? "")")
                            case .failure(let error):
                                self.loginError = error.localizedDescription
                                print("❌ Login failed: \(error)")
                            }
                        }
                }
                .buttonStyle(.borderedProminent)

                if let error = loginError {
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                }
            }
        }
        .padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
