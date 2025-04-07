import Foundation

struct FoodAnalysisRecord: Identifiable, Codable {
    let id = UUID()
    let imageData: Data
    let resultText: String
    let timestamp: Date
}
