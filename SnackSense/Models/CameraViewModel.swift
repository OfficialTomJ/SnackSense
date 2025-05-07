//
//  CameraViewModel.swift
//  SnackSense
//
//  Created by Tom on 30/4/2025.
//

import Foundation
import AVFoundation
import UIKit
import Vision

class CameraViewModel: NSObject, ObservableObject {
    let session = AVCaptureSession()
    private let output = AVCapturePhotoOutput()
    private let queue = DispatchQueue(label: "cameraQueue")
    @Published var capturedImage: UIImage?
    @Published var savedImageURL: URL?
    @Published var extractedText: String = ""

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
            if let image = self.capturedImage {
                if let url = self.saveImageToDocuments(image: image) {
                    self.savedImageURL = url
                    self.extractText(from: image) { text in
                        DispatchQueue.main.async {
                            self.extractedText = text
                        }
                    }
                }
            }
        }
    }
}

extension CameraViewModel {
    func saveImageToDocuments(image: UIImage, name: String = "captured_label.jpg") -> URL? {
        guard let data = image.jpegData(compressionQuality: 0.9) else { return nil }
        let filename = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(name)
        do {
            try data.write(to: filename)
            return filename
        } catch {
            print("❌ Error saving image: \(error)")
            return nil
        }
    }

    func extractText(from image: UIImage, completion: @escaping (String) -> Void) {
        guard let cgImage = image.cgImage else {
            completion("")
            return
        }

        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNRecognizeTextRequest { (request, error) in
            guard let observations = request.results as? [VNRecognizedTextObservation], error == nil else {
                print("❌ Text recognition failed: \(error?.localizedDescription ?? "Unknown error")")
                completion("")
                return
            }

            let text = observations.compactMap { $0.topCandidates(1).first?.string }.joined(separator: "\n")
            completion(text)
        }

        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true

        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try requestHandler.perform([request])
            } catch {
                print("❌ Failed to perform text request: \(error)")
                completion("")
            }
        }
    }
}
