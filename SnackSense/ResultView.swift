import SwiftUI
import SwiftData

struct ResultView: View {
    let rawText: String
    let imageURL: URL?

    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = ResultViewModel()
    @State private var showFullImage = false

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 20) {
                    if let imageURL = imageURL {
                        // Nutrition Label Image (smaller + tappable)
                        AsyncImage(url: imageURL) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image
                                    .resizable()
                                    .frame(height: geometry.size.height * 0.5)
                                    .frame(width: geometry.size.width * 0.75)
                                    .cornerRadius(10)
                                    .shadow(radius: 3)
                                    .onTapGesture {
                                        showFullImage.toggle()
                                    }
                                    .sheet(isPresented: $showFullImage) {
                                        ScrollView {
                                            VStack {
                                                image
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(maxWidth: geometry.size.width * 0.9)
                                                    .padding()
                                            }
                                        }
                                    }
                            default:
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .foregroundColor(.gray)
                            }
                        }

                        // Insights Header
                        Text("Health Insights")
                            .font(.title2)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)

                        // Insight Content
                        if viewModel.isLoading {
                            ProgressView("Generating insights...")
                                .padding(.horizontal)
                                .frame(maxWidth: .infinity)
                        } else if viewModel.insights.isEmpty {
                            Text("No insights found for this label.")
                                .foregroundColor(.secondary)
                                .font(.system(size: geometry.size.width > 600 ? 20 : 16))
                                .padding(.horizontal)
                                .frame(maxWidth: .infinity)
                        } else {
                            VStack(alignment: .leading, spacing: 15) {
                                ForEach(viewModel.insights, id: \.self) { insight in
                                    Text(insight)
                                        .font(.system(size: geometry.size.width > 600 ? 20 : 16))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity)
                        }

                        // Scan Another Button
                        Button("Scan Another") {
                            dismiss()
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                    } else {
                        Text("No scan data available.")
                            .foregroundColor(.secondary)
                            .padding()
                    }

                    Spacer(minLength: 40)
                }
                .padding()
            }
            .onAppear {
                print("DEBUG - rawText: \(rawText)")
                viewModel.fetchInsights(from: rawText)
            }
            .navigationTitle("SnackSense")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
