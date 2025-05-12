//
//  CameraView.swift
//  SnackSense
//
//  Created by Tom on 30/4/2025.
//

import SwiftUI
import AVFoundation
import SwiftData


@Model
class ExtractedTextEntry {
    var id: UUID
    var content: String
    var timestamp: Date
    var imagePath: String

    init(content: String, imagePath: String) {
        self.id = UUID()
        self.content = content
        self.timestamp = Date()
        self.imagePath = imagePath
    }
}


struct CameraPageView: View {
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var cameraModel: CameraViewModel
    @State private var showImagePicker = false
    @State private var inputImage: UIImage?
    @State private var showResultView = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if let inputImage = inputImage {
                    Image(uiImage: inputImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                        .ignoresSafeArea()
                        .zIndex(-1)
                } else {
    #if targetEnvironment(simulator)
                    Color.black
                        .ignoresSafeArea()
                        .overlay(
                            VStack {
                                Spacer()
                                Text("Camera Unavailable\nin Simulator")
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.white)
                                    .font(.headline)
                                    .padding()
                                    .frame(width: 200)
                                Spacer()
                            }
                        )
    #else
                    CameraPreview(session: cameraModel.session)
                        .ignoresSafeArea()
    #endif
                }

                VStack {
                    ZStack {
                        Color.white
                        Image("snacksense logo horizontal")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 128)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 0)
                    .padding(.top, 36)
                    .background(Color.white)

                    Spacer()

                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white.opacity(0.8), lineWidth: 3)
                        .frame(width: geometry.size.width * 0.5, height: geometry.size.height * 0.4)

                    Text("Position the food label within the frame.")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.top, 16)

                    Spacer()

                    if inputImage != nil {
                        HStack {
                            Spacer()

                            Button("Use Photo") {
                                if let image = inputImage {
                                    if let url = cameraModel.saveImageToDocuments(image: image) {
                                        cameraModel.savedImageURL = url
                                        cameraModel.extractText(from: image) { text in
                                            DispatchQueue.main.async {
                                                print("Extracted Text:\n\(text)")
                                                cameraModel.extractedText = text
                                                showResultView = true
                                            }
                                        }
                                    }
                                }
                            }
                            .padding()
                            .background(Color.white)
                            .foregroundColor(.black)
                            .cornerRadius(10)

                            Button("Retake") {
                                inputImage = nil
                            }
                            .padding()
                            .background(Color.gray.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(10)

                            Spacer()
                        }
                        .padding(.horizontal, 30)
                        .padding(.bottom, 30)
                    } else {
                        HStack {
                            Button(action: {
                                showImagePicker = true
                            }) {
                                Image(systemName: "photo.on.rectangle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: geometry.size.width * 0.07, height: geometry.size.width * 0.07)
                                    .foregroundColor(.white)
                            }

                            Spacer()

                            Button(action: {
                                cameraModel.takePhoto()
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(Color.white.opacity(0.2))
                                        .frame(width: geometry.size.width * 0.18, height: geometry.size.width * 0.18)

                                    Circle()
                                        .stroke(Color.white, lineWidth: 4)
                                        .frame(width: geometry.size.width * 0.15, height: geometry.size.width * 0.15)
                                }
                            }

                            Spacer()
                        }
                        .padding(.horizontal, 40)
                        .padding(.bottom, 40)
                    }
                }
            }
        }
        .onAppear {
            if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != "1" {
                cameraModel.configure()
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $inputImage)
        }
        .sheet(isPresented: $showResultView) {
            ResultView(rawText: cameraModel.extractedText, imageURL: cameraModel.savedImageURL)
        }
    }
}

struct CameraPreview: UIViewRepresentable {
    let session: AVCaptureSession

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = view.frame
        view.layer.addSublayer(previewLayer)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

// SwiftUI Preview Provider for CameraPageView
struct CameraPageView_Previews: PreviewProvider {
    static var previews: some View {
        let mockModel = CameraViewModel()
        // Assign a placeholder image to simulate a captured image
        mockModel.capturedImage = UIImage(systemName: "photo")

        return CameraPageView(cameraModel: mockModel)
            .previewDevice("iPhone 15 Pro")
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            picker.dismiss(animated: true)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}
