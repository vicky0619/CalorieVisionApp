//
//  ContentView.swift
//  CalorieVisionApp
//
//  Created by Vicky T on 4/8/25.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage? = nil
    @State private var resultText: String = ""
    @State private var isCameraPresented = false
    @State private var history: [FoodAnalysisRecord] = []
    @State private var isHistoryPresented = false


    var body: some View {
        VStack(spacing: 20) {
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 250)
            }

            PhotosPicker("選擇照片", selection: $selectedItem, matching: .images)
                .onChange(of: selectedItem) { newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self),
                           let uiImage = UIImage(data: data) {
                            selectedImage = uiImage
                        }
                    }
                }


            Button("拍照分析") {
                isCameraPresented = true
            }
            .sheet(isPresented: $isCameraPresented) {
                ImagePicker(sourceType: .camera, selectedImage: $selectedImage)
            }
            HStack {
                PhotosPicker("選照片", selection: $selectedItem, matching: .images)
                Button("拍照分析") {
                    isCameraPresented = true
                }
            }


            Button("分析圖片") {
                if let image = selectedImage {
                    analyzeImageWithGemini(image: image) { result in
                        resultText = result

                        if let imageData = image.jpegData(compressionQuality: 0.8) {
                            let newRecord = FoodAnalysisRecord(
                                imageData: imageData,
                                resultText: result,
                                timestamp: Date()
                            )
                            history.append(newRecord)
                        }
                    }
                }
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            
            ScrollView {
                Text(resultText)
                    .padding()
            }
            Button("🕘 歷史紀錄") {
                isHistoryPresented = true
            }
            .sheet(isPresented: $isHistoryPresented) {
                HistoryView(records: history)
            }

        }
        .padding()
    }
}


#Preview {
    ContentView()
}
