swift
import SwiftUI
import PhotosUI

struct ImageUploadView: View {
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: Image? = nil
    @State private var isImagePickerShowing = false
    @State private var isShowingAlert = false
    @State private var isLoading = false
    @State private var showNutrition = false
    @State private var nutrition = Nutrition(calories: 0, protein: 0, carbs: 0, fat: 0)
    @ObservedObject var viewModel: MealViewModel
    var userId: String

    var body: some View {
        VStack {
            if let image = selectedImage {
                image
                    .resizable()
                    .scaledToFit()
            } else {
                Image(systemName: "photo.circle.fill")
                    .font(.system(size: 100))
                    .foregroundColor(.gray)
            }
            if isLoading{
                ProgressView()
            }

            PhotosPicker("Select Image", selection: $selectedItem, matching: .images)
            .onChange(of: selectedItem) { newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        if let uiImage = UIImage(data: data) {
                            selectedImage = Image(uiImage: uiImage)
                            isLoading = true
                            nutrition = await GeminiVisionService().analyze(image: uiImage)
                            isLoading = false
                            showNutrition = true
                            return
                        }
                    }
                }
            }
            if showNutrition{
                Text("Calories: \(nutrition.calories)")
                Text("Protein: \(nutrition.protein)")
                Text("Carbs: \(nutrition.carbs)")
                Text("Fat: \(nutrition.fat)")
                Button("Add meal"){
                    Task{
                        
                        guard let image = selectedImage else { return }
                        guard let uiImage = image.asUIImage() else { return }
                        let url = await StorageService().uploadImage(image: uiImage, userId: userId)
                        let meal = Meal(userId: userId, imageURL: url, nutrition: nutrition)
                        await viewModel.addMeal(meal: meal)
                        showNutrition = false
                        selectedImage = nil
                    }
                }
            }

        }
        .padding()
        .alert("Error", isPresented: $isShowingAlert) {
            Button("OK", role: .cancel) { }
        }
    }
}