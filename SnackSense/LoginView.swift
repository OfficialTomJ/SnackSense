//
//  LoginView.swift
//  SnackSense
//
//  Created by Tom on 27/5/2025.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State private var isAuthenticated = false
    @State private var loginError: String?
    @State private var navigateToStart = false
    @State private var email = ""
    @State private var password = ""
    @State private var isLoginMode = true

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text(isLoginMode ? "Login to SnackSense" : "Create an Account")
                    .font(.title)
                    .fontWeight(.bold)

                TextField("Email", text: $email)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)

                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)

                if let error = loginError {
                    Text("❌ \(error)")
                        .foregroundColor(.red)
                }

                Button(isLoginMode ? "Log In" : "Sign Up") {
                    if isLoginMode {
                        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                            if let error = error {
                                self.loginError = error.localizedDescription
                            } else {
                                self.isAuthenticated = true
                                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                                self.navigateToStart = true
                            }
                        }
                    } else {
                        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                            if let error = error {
                                self.loginError = error.localizedDescription
                            } else {
                                self.isAuthenticated = true
                                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                                self.navigateToStart = true
                            }
                        }
                    }
                }
                .buttonStyle(.borderedProminent)

                Button(isLoginMode ? "Don't have an account? Sign Up" : "Already have an account? Log In") {
                    isLoginMode.toggle()
                    loginError = nil
                }
                .font(.footnote)

                if isAuthenticated {
                    Button("Log Out") {
                        do {
                            try Auth.auth().signOut()
                            self.isAuthenticated = false
                            UserDefaults.standard.set(false, forKey: "isLoggedIn")
                        } catch let signOutError as NSError {
                            print("❌ Sign out error: \(signOutError)")
                        }
                    }
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
