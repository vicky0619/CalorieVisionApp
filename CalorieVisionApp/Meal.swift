swift
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Meal: Identifiable, Codable {
    @DocumentID var id: String?
    var userId: String
    var imageURL: String
    var nutrition: Nutrition
    @ServerTimestamp var timestamp: Timestamp?
}

struct Nutrition: Codable {
    var calories: Double
    var protein: Double
    var carbs: Double
    var fat: Double
}