import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class ResultViewModel: ObservableObject {
    @Published var insights: [String] = []
    @Published var isLoading: Bool = false

    func fetchInsights(from nutritionText: String, imageData: Data?) {
        let prompt = """
        Analyze the following nutrition label and return 4-5 bullet points with health insights in plain English, aimed at everyday consumers:

        "\(nutritionText)"
        """

        let body: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [["role": "user", "content": prompt]],
            "temperature": 0.7
        ]

        guard let url = URL(string: "https://api.openai.com/v1/chat/completions"),
              let jsonData = try? JSONSerialization.data(withJSONObject: body) else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        guard let apiKey = loadEnvVariable("OPENAI_API_KEY") else {
            return
        }

        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        isLoading = true
        URLSession.shared.dataTask(with: request) { data, response, error in
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
                .filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
            
            guard let user = Auth.auth().currentUser else {
                return
            }

            let storageRef = Storage.storage().reference()
            let imagePath = "scans/\(user.uid)/\(UUID().uuidString).jpg"
            let imageRef = storageRef.child(imagePath)

            imageRef.putData(imageData!, metadata: nil) { metadata, error in
                guard error == nil else {
                    print("Failed to upload image: \(error!.localizedDescription)")
                    return
                }

                imageRef.downloadURL { url, error in
                    guard let downloadURL = url else {
                        print("Failed to get download URL: \(error?.localizedDescription ?? "No error")")
                        return
                    }

                    let scanData: [String: Any] = [
                        "timestamp": Date().timeIntervalSince1970,
                        "nutritionText": nutritionText,
                        "insights": parsed,
                        "imageURL": downloadURL.absoluteString
                    ]

                    let dbRef = Database.database().reference()
                    dbRef.child("scans").child(user.uid).childByAutoId().setValue(scanData)
                }
            }

            DispatchQueue.main.async {
                self.insights = parsed
            }
        }.resume()
    }
}
