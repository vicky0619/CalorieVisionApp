swift
import SwiftUI
import Firebase

struct FoodDiaryView: View {
    @ObservedObject var viewModel: MealViewModel
    @State private var selectedDate = Date()
    var userId: String

    var body: some View {
        VStack {
            DatePicker("Select Date", selection: $selectedDate, displayedComponents: [.date])
                .datePickerStyle(.graphical)
                .padding()
                .onChange(of: selectedDate) { _ in
                    Task{
                        await viewModel.loadMeals(userId: userId, on: selectedDate)
                    }
                }

            if viewModel.todayMeals.isEmpty {
                Text("No meals recorded for this day.")
                    .foregroundColor(.gray)
            } else {
                List {
                    ForEach(viewModel.todayMeals) { meal in
                        NavigationLink(destination: MealDetailView(viewModel: viewModel, meal: meal)) {
                            HStack {
                                if let url = URL(string: meal.imageURL) {
                                    AsyncImage(url: url) { image in
                                        image.resizable()
                                             .aspectRatio(contentMode: .fit)
                                             .frame(width: 50, height: 50)
                                             .cornerRadius(5)
                                    } placeholder: {
                                        ProgressView()
                                    }
                                }

                                VStack(alignment: .leading) {
                                    Text("\(meal.nutrition.calories, specifier: "%.0f") Calories")
                                    Text("Added: \(meal.timestamp?.dateValue() ?? Date(), formatter: dateFormatter)")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                }
            }

            Spacer()
            if let diary = viewModel.diary {
                VStack{
                    Text("Diary:")
                        .font(.title)
                    HStack{
                        Text("Calories:")
                        Text("\(diary.totalCalories)")
                    }
                    HStack{
                        Text("Protein:")
                        Text("\(diary.totalProtein)")
                    }
                    HStack{
                        Text("Carbs:")
                        Text("\(diary.totalCarbs)")
                    }
                    HStack{
                        Text("Fats:")
                        Text("\(diary.totalFat)")
                    }
                }

            }
        }
        .navigationTitle("Food Diary")
        .onAppear{
            Task{
                await viewModel.loadMeals(userId: userId, on: selectedDate)
                await viewModel.loadDiary(userId: userId, on: selectedDate)
            }
        }
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }
}