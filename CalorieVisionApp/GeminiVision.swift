import Foundation
import UIKit


func analyzeImageWithGemini(image: UIImage, completion: @escaping (String) -> Void) {
    guard let imageData = image.jpegData(compressionQuality: 0.8) else {
        completion("❌ 無法轉換圖片")
        return
    }

    let apiKey = APIKeys.geminiKey
    let url = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=apiKey")!
    let prompt = """
    請直接估算這張圖片中的餐點熱量與營養成分（卡路里、蛋白質、碳水化合物、脂肪），即使無法完全精確也請給出一個合理範圍。

    請使用以下 JSON 格式回覆：

    {
      "food": "請簡單描述食物名稱",
      "calories_kcal": "xxx-xxx",
      "protein_g": "x-x",
      "carbohydrates_g": "x-x",
      "fat_g": "x-x"
    }

    請直接回傳這段 JSON，不需要額外解釋或警告。
    """

    let base64Image = imageData.base64EncodedString()
    let payload: [String: Any] = [
        "contents": [
            [
                "parts": [
                    ["text": prompt],
                    ["inlineData": [
                        "mimeType": "image/jpeg",
                        "data": base64Image
                    ]]
                ]
            ]
        ]
    ]

    guard let body = try? JSONSerialization.data(withJSONObject: payload) else {
        completion("❌ 無法組成請求")
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.httpBody = body
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")

    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion("❌ 錯誤：\(error.localizedDescription)")
            return
        }

        guard let data = data else {
            completion("❌ 沒有收到資料")
            return
        }

        if let result = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
           let candidates = result["candidates"] as? [[String: Any]],
           let content = candidates.first?["content"] as? [String: Any],
           let parts = content["parts"] as? [[String: Any]],
           let responseText = parts.first?["text"] as? String {
            completion(responseText)
        } else {
            completion("⚠️ 無法解析回傳資料：\n\(String(data: data, encoding: .utf8) ?? "無內容")")
        }
    }.resume()
}
