import Foundation
import SwiftData

@Model
class ScanData {
    var id: UUID
    var imageUrl: URL
    var rawText: String

    init(imageUrl: URL, rawText: String) {
        self.id = UUID()
        self.imageUrl = imageUrl
        self.rawText = rawText
    }
}
