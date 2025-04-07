# CalorieVisionApp

**CalorieVisionApp** is a Swift-based iOS application that uses **Gemini Vision AI** to analyze food photos and estimate nutrition facts — including calories, protein, carbohydrates, and fat. The app allows users to take or upload photos, view AI results in structured JSON, and maintain a history of past analyses. It is designed to demonstrate image + LLM integration in a mobile app, suitable for computer science portfolio and internship applications.

---

## ✨ Features

- 📸 Take a photo or choose from gallery
- 🧠 Analyze image using Gemini Vision API
- 📊 Output nutrition facts in JSON format
- 🕘 Maintain a history of analyzed meals
- 🧾 (Planned) Food diary with daily intake summary

---

## 🧠 Technologies Used

| Tech        | Role                         |
|-------------|------------------------------|
| SwiftUI     | Main app UI                  |
| UIKit       | Camera integration           |
| Gemini API  | Image-based nutrition AI     |
| OpenAI API  | Optional GPT-based fallback  |
| Xcode       | iOS development              |
| Git/GitHub  | Version control & portfolio  |

---

## 🛠 Setup & Run

1. Clone this repo
2. Duplicate `APIKeys.swift.example` → rename to `APIKeys.swift`
3. Insert your own API keys:

```swift
struct APIKeys {
    static let openaiKey = "sk-..."     // optional
    static let geminiKey = "AIza..."    // required
}
```

4. Open with Xcode (iOS 16+), run on Simulator or real device

---

## 📂 File Overview

```
CalorieVisionApp/
├── APIKeys.swift.example   # Replace with your actual key
├── OpenAIService.swift     # Optional GPT-based analysis
├── GeminiService.swift     # Vision image → nutrition
├── ContentView.swift       # Main view with image upload
├── HistoryView.swift       # Past analysis viewer
├── .gitignore              # Prevents secrets from leaking
└── README.md               # You're here
```

---

## 📸 Screenshots

*Coming soon…*  
You can add UI screenshots or a short video here!

---

## 👤 Author

**Wen-Chi Tsai**  
GitHub: [@vicky0619](https://github.com/vicky0619)  
A computer science student passionate about AI, image recognition, and health-related applications.

---

## 🌟 Future Directions

- Add food diary view with per-day nutritional totals
- Integrate CoreData or Firebase to store history permanently
- Implement Swift Charts to visualize intake trends
- Export records as CSV or PDF
- TestFlight deployment

---

## 🈶 繁體中文簡介

**CalorieVisionApp** 是一款 Swift iOS App，使用 Gemini Vision AI 分析餐點照片，預估熱量、蛋白質、碳水化合物與脂肪等營養資訊。  
使用者可拍照或選擇照片，查看 AI 回傳之 JSON 結果，並記錄分析歷史，是一款結合 Vision 模型與 SwiftUI 的作品集級 App。


