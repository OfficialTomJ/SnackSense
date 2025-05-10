import Foundation

class ResultViewModel: ObservableObject {
    @Published var insights: [String] = []
    @Published var isLoading: Bool = false

    func fetchInsights(from nutritionText: String) {
        let prompt = """
        Analyze the following nutrition label and return 4-5 bullet points with health insights in plain English, aimed at everyday consumers:

        "\(nutritionText)"
        """

        let body: [String: Any] = [
            "model": "gpt-4",
            "messages": [["role": "user", "content": prompt]],
            "temperature": 0.7
        ]

        guard let url = URL(string: "https://api.openai.com/v1/chat/completions"),
              let jsonData = try? JSONSerialization.data(withJSONObject: body) else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        if let apiKey = loadEnvVariable("OPENAI_API_KEY") {
            request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        }
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        isLoading = true
        URLSession.shared.dataTask(with: request) { data, _, _ in
            DispatchQueue.main.async {
                self.isLoading = false
            }

            guard let data = data,
                  let result = try? JSONDecoder().decode(OpenAIResponse.self, from: data),
                  let responseText = result.choices.first?.message.content else {
                return
            }

            let parsed = responseText
                .components(separatedBy: "\n")
                .filter { $0.trimmingCharacters(in: .whitespaces).hasPrefix("•") }

            DispatchQueue.main.async {
                self.insights = parsed
            }
        }.resume()
    }
}
