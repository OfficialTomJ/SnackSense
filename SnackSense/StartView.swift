//
//  StartView.swift
//  SnackSense
//
//  Created by Ronan Soh  on 03/05/2025.
//

import SwiftUI

struct StartView: View {
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // Logo Image Size
            Image("snacksense logo cropped")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .foregroundColor(Color.green)
                
            //Name of App
            Text("SnackSense")
                .font(.system(size: 36, weight: .semibold ))
                .foregroundColor(.primary)
            
            //Sub-text
            Text("Make smarter dietary choices by scanning food labels with ease.")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
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


            Spacer()
        }
        .navigationBarHidden(true)
    }
}
#Preview {
    StartView()
}
