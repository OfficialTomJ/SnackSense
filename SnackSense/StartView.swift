//
//  StartView.swift
//  SnackSense
//
//  Created by Ronan Soh  on 03/05/2025.
//

import SwiftUI
import FirebaseAuth

struct StartView: View {
    @State private var shouldLogout = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                GeometryReader { geometry in
                    VStack(spacing: 40) {
                        Spacer()
                        
                        // Logo Image Size
                        Image("snacksense logo cropped")
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width * 0.4, height: geometry.size.width * 0.4)
                            .foregroundColor(Color.green)
                            
                        //Name of App
                        Text("SnackSense")
                            .font(.system(size: geometry.size.width > 600 ? 48 : 36, weight: .semibold))
                            .foregroundColor(.primary)
                        
                        //Sub-text
                        Text("Make smarter dietary choices by scanning food labels with ease.")
                            .font(.system(size: geometry.size.width > 600 ? 22 : 16))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, geometry.size.width * 0.1)
                            .foregroundColor(.secondary)

                        Spacer()
                        
                        //Scan food button sends to CameraPageView
                        NavigationLink(destination: CameraPageView(cameraModel: CameraViewModel())) {
                            Text("Scan Food Label")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, minHeight: 55)
                                .background(Color.green)
                                .cornerRadius(16)
                                .padding(.horizontal, 30)
                        }

                        NavigationLink(destination: ScanHistoryView()) {
                            Text("Scan History")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, minHeight: 55)
                                .background(Color.blue)
                                .cornerRadius(16)
                                .padding(.horizontal, 30)
                        }

                        Spacer()
                    }
                    .navigationBarHidden(true)
                }
                
                VStack {
                    HStack {
                        Spacer()
                        Button(action: logout) {
                            Text("Logout")
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(.red)
                                .padding()
                        }
                    }
                    Spacer()
                }
                
                NavigationLink(destination: LoginView(), isActive: $shouldLogout) {
                    EmptyView()
                }
            }
        }
    }
    
    private func logout() {
        do {
            try Auth.auth().signOut()
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
            shouldLogout = true
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}
#Preview {
    StartView()
}
