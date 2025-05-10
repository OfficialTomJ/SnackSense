import SwiftUI
import SwiftData

struct ResultView: View {
    @Environment(\.dismiss) var dismiss
    @Query var scanDataList: [ScanData]
    @StateObject private var viewModel = ResultViewModel()
    @State private var showFullImage = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if let scan = scanDataList.last {
                    // Nutrition Label Image
                    AsyncImage(url: scan.imageUrl) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(12)
                                .shadow(radius: 4)
                                .onTapGesture {
                                    showFullImage.toggle()
                                }
                                .sheet(isPresented: $showFullImage) {
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .padding()
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
                    } else if viewModel.insights.isEmpty {
                        Text("No insights found for this label.")
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                    } else {
                        VStack(alignment: .leading, spacing: 15) {
                            ForEach(viewModel.insights, id: \.self) { insight in
                                Text(insight)
                                    .font(.body)
                            }
                        }
                        .padding(.horizontal)
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
            if let text = scanDataList.last?.rawText {
                viewModel.fetchInsights(from: text)
            }
        }
        .navigationTitle("SnackSense")
        .navigationBarTitleDisplayMode(.inline)
    }
}
