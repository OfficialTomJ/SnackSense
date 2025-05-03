import SwiftUI

struct ResultsView: View {
    @State private var showFullImage = false

    // Sample health insights
    let insights = [
        "High in protein (7g) — great for muscle repair and helps keep you full.",
        "Contains 12g of sugar — moderate. Try to limit added sugar for better metabolic health.",
        "250mg sodium — moderate. Suitable for most, but limit if you're on a low-sodium diet.",
        "Contains peanuts — a common allergen. Avoid if allergic.",
        "Low in fiber — consider pairing with a high-fiber food like fruit or oats."
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                // Enlarged label image with tap-to-expand
                Image("nutrition_label_sample")
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(12)
                    .shadow(radius: 4)
                    .onTapGesture {
                        showFullImage.toggle()
                    }
                    .sheet(isPresented: $showFullImage) {
                        Image("nutrition_label_sample")
                            .resizable()
                            .scaledToFit()
                            .padding()
                    }

                // Section Title
                Text("Health Insights")
                    .font(.title2)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                // Insight Bullets
                VStack(alignment: .leading, spacing: 15) {
                    ForEach(insights, id: \.self) { insight in
                        Text("• \(insight)")
                            .font(.body)
                    }
                }
                .padding(.horizontal)

                // Scan Another Button
                Button("Scan Another") {
                    // TODO: Add navigation logic to go back or to camera view
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal)

                Spacer(minLength: 40)
            }
            .padding(.top)
        }
        .navigationTitle("SnackSense")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ResultsView()
}
