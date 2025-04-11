swift
import UIKit
import Firebase
import Foundation
import GoogleGenerativeAI

struct GeminiVisionService {
    private let apiKey = ProcessInfo.processInfo.environment["API_KEY"]!

    func analyze(image: UIImage) async -> Nutrition {
        
        let model = GenerativeModel(name: "gemini-pro-vision", apiKey: apiKey)
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("Error: Could not convert image to JPEG data.")
            return Nutrition(calories: 0, protein: 0, carbs: 0, fat: 0)
        }
        
        let base64EncodedImage = imageData.base64EncodedString()
        
        let prompt = "Analyze the given food image and return a nutrition value. Return your answer in JSON format with the following format: {\"calories\":, \"protein\":, \"carbs\":, \"fat\":}. DO NOT include anything more than the JSON in your answer"
        
        let parts: [ModelContent.Part] = [
            .init(text: prompt),
            .init(inlineData: .init(mimeType: "image/jpeg", data: imageData))
        ]
        
        let content = ModelContent(role: "user", parts: parts)
        
        do {
            let response = try await model.generateContent(content)
            
            guard let responseText = response.text else {
                print("Error: Response text is nil.")
                return Nutrition(calories: 0, protein: 0, carbs: 0, fat: 0)
            }
            
            guard let nutrition = parseNutritionJSON(jsonString: responseText) else {
                print("Error: Could not parse nutrition JSON.")
                return Nutrition(calories: 0, protein: 0, carbs: 0, fat: 0)
            }
            
            return nutrition
            
        } catch {
            print("Error calling Gemini API: \(error)")
            return Nutrition(calories: 0, protein: 0, carbs: 0, fat: 0)
        }
    }

    private func parseNutritionJSON(jsonString: String) -> Nutrition? {
        guard let jsonData = jsonString.data(using: .utf8) else {
            print("Error: Could not convert JSON string to data.")
            return nil
        }

        do {
            let decoder = JSONDecoder()
            let nutrition = try decoder.decode(Nutrition.self, from: jsonData)
            return nutrition
        } catch {
            print("Error: Could not decode JSON to Nutrition: \(error)")
            return nil
        }
    }
}