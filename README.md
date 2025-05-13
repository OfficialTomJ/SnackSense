# 🥗 SnackSense

**SnackSense** is an AI-powered mobile app that helps users make smarter dietary choices in seconds. By simply taking a photo of a food label, the app extracts key nutritional data, processes it through AI, and delivers clear, health-focused insights — perfect for consumers looking to eat better without the guesswork.

## 📲 Features

- Scan food labels with your camera
- Extract nutritional text using OCR
- Summarize and analyze data using OpenAI GPT
- Instant health insights for everyday consumers
- User-friendly UI with health-focused recommendations

## 🚀 Project Structure
SnackSense/
├── Models/
├── Views/
├── Controllers/
├── Resources/
├── Assets/
├── Environment/
├── .env                 # Stores API keys and secrets
└── SnackSense.xcodeproj

## 🔧 Setup & Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/yourusername/SnackSense.git
   cd SnackSense
   
2.	Install dependencies (if using CocoaPods or Swift Package Manager)

   pod install

3.	Set up the .env file
Create a .env file in the root of your project with the following:

OPENAI_API_KEY=your_openai_api_key_here

⚠️ Never commit your .env file to version control. Add it to your .gitignore.

	4.	Access environment variables in Swift
If you’re using a Swift environment loader (e.g., DotEnv), load the .env values like this:

import Foundation

let apiKey = ProcessInfo.processInfo.environment["OPENAI_API_KEY"] ?? ""

Alternatively, you can use a config manager or define a simple helper to load the API key securely.

💬 Using the OpenAI API

Once the text is extracted from the image:
	1.	Send a prompt to the OpenAI API using your API key.
	2.	Format the request as follows:

 let url = URL(string: "https://api.openai.com/v1/chat/completions")!
var request = URLRequest(url: url)
request.httpMethod = "POST"
request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
request.setValue("application/json", forHTTPHeaderField: "Content-Type")

let body: [String: Any] = [
    "model": "gpt-4",
    "messages": [
        ["role": "system", "content": "You are a health assistant that summarizes nutritional data."],
        ["role": "user", "content": "Nutritional label: Calories 180, Sugar 20g, Protein 3g..."]
    ]
]
request.httpBody = try? JSONSerialization.data(withJSONObject: body)

URLSession.shared.dataTask(with: request) { data, response, error in
    // Handle response
}.resume()

📦 Dependencies
	•	SwiftUI
	•	VisionKit or UIImagePickerController (for camera access)
	•	OpenAI API
	•	Optional: SwiftDotEnv for loading .env

🛡️ Security
	•	Keep API keys secure with .env
	•	Do not log sensitive data
	•	Always use HTTPS when communicating with the OpenAI API

🤝 Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you’d like to change.

Project contributors:
25020443 - Kartikay Singh
25465345 - Wai Ming Ronan Soh
24663472 - Thomas Johnston
