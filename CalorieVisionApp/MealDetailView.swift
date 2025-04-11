swift
import SwiftUI
import Firebase
struct MealDetailView: View {
    @ObservedObject var viewModel: MealViewModel
    @State private var showingEditView = false
    let meal: Meal

    var body: some View {
        VStack {
            // Display Meal Image
            if let url = URL(string: meal.imageURL) {
                AsyncImage(url: url) { image in
                    image.resizable()
                         .aspectRatio(contentMode: .fit)
                         .frame(maxWidth: .infinity, maxHeight: 300)
                         .cornerRadius(10)
                } placeholder: {
                    ProgressView()
                }
            } else {
                Image(systemName: "photo")
                    .font(.system(size: 60))
                    .frame(maxWidth: .infinity, maxHeight: 300)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
            }

            // Nutrition Information
            VStack(alignment: .leading) {
                Text("Nutrition")
                    .font(.title2)
                    .bold()
                    .padding(.bottom, 5)

                HStack {
                    Text("Calories:")
                    Spacer()
                    Text("\(meal.nutrition.calories, specifier: "%.0f")")
                }
                HStack {
                    Text("Protein:")
                    Spacer()
                    Text("\(meal.nutrition.protein, specifier: "%.1f")g")
                }
                HStack {
                    Text("Carbs:")
                    Spacer()
                    Text("\(meal.nutrition.carbs, specifier: "%.1f")g")
                }
                HStack {
                    Text("Fat:")
                    Spacer()
                    Text("\(meal.nutrition.fat, specifier: "%.1f")g")
                }
            }
            .padding()
            
            // Timestamp
            if let timestamp = meal.timestamp {
                Text("Added: \(timestamp.dateValue(), formatter: dateFormatter)")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.bottom)
            }
            HStack{
                Button(action: {
                    showingEditView = true
                }) {
                    Text("Edit")
                }.padding()
                Button(action: {
                    Task{
                        if let id = meal.id{
                            await viewModel.deleteMeal(mealId: id, userId: meal.userId)
                        }
                        
                    }
                }) {
                    Text("Delete")
                }.padding()
            }

            Spacer()
        }
        .navigationTitle("Meal Details")
        .padding()
        .sheet(isPresented: $showingEditView) {
            EditMealView(viewModel: viewModel, meal: meal)
        }
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }
}