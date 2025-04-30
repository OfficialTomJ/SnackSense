//
//  CameraViewModel.swift
//  SnackSense
//
//  Created by Tom on 30/4/2025.
//

import Foundation
import AVFoundation
import UIKit

class CameraViewModel: NSObject, ObservableObject {
    let session = AVCaptureSession()
    private let output = AVCapturePhotoOutput()
    private let queue = DispatchQueue(label: "cameraQueue")
    @Published var capturedImage: UIImage?

    func configure() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            if granted {
                self.setupSession()
            } else {
                print("Camera access denied")
            }
        }
    }

    private func setupSession() {
        queue.async {
            self.session.beginConfiguration()
            guard let device = AVCaptureDevice.default(for: .video),
                  let input = try? AVCaptureDeviceInput(device: device),
                  self.session.canAddInput(input) else { return }

            self.session.addInput(input)

            if self.session.canAddOutput(self.output) {
                self.session.addOutput(self.output)
            }

            self.session.commitConfiguration()
            self.session.startRunning()
        }
    }

    func takePhoto() {
        let settings = AVCapturePhotoSettings()
        output.capturePhoto(with: settings, delegate: self)
    }
}

extension CameraViewModel: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else {
            print("Failed to get image data")
            return
        }

        DispatchQueue.main.async {
            self.capturedImage = image
        }
    }
}
