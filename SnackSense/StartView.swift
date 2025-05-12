//
//  StartView.swift
//  SnackSense
//
//  Created by Ronan Soh  on 03/05/2025.
//

import SwiftUI

struct StartView: View {
    var body: some View {
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
                    Text("View Scan History")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }


                Spacer()
            }
            .navigationBarHidden(true)
        }
    }
}
#Preview {
    StartView()
}
