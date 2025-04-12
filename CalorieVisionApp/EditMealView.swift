swift
import SwiftUI

struct EditMealView: View {
    @ObservedObject var viewModel: MealViewModel
    @Environment(\.dismiss) private var dismiss
    @State var meal: Meal

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Nutrition")) {
                    TextField("Calories", value: $meal.nutrition.calories, format: .number)
                        .keyboardType(.decimalPad)
                    TextField("Protein (g)", value: $meal.nutrition.protein, format: .number)
                        .keyboardType(.decimalPad)
                    TextField("Carbs (g)", value: $meal.nutrition.carbs, format: .number)
                        .keyboardType(.decimalPad)
                    TextField("Fat (g)", value: $meal.nutrition.fat, format: .number)
                        .keyboardType(.decimalPad)
                }
            }
            .navigationTitle("Edit Meal")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        Task{
                            await viewModel.updateMeal(meal: meal)
                            dismiss()
                        }
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                }
            }
        }
    }
}