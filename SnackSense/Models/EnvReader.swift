import Foundation

func loadEnvVariable(_ key: String) -> String? {
    guard let path = Bundle.main.path(forResource: ".env", ofType: nil),
          let data = try? String(contentsOfFile: path) else {
        return nil
    }

    for line in data.components(separatedBy: .newlines) {
        let parts = line.components(separatedBy: "=")
        if parts.count == 2 {
            let envKey = parts[0].trimmingCharacters(in: .whitespaces)
            let value = parts[1].trimmingCharacters(in: .whitespaces)
            if envKey == key {
                return value
            }
        }
    }
    return nil
}
