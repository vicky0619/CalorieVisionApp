swift

@MainActor
class MealViewModel: ObservableObject {
    @Published var meals: [Meal] = []
    @Published var todayMeals: [Meal] = []
    @Published var dailySummary: DailySummary?
    let firestoreService = FirestoreService()

    func loadMeals(userId: String) async {
        do {
            self.meals = try await firestoreService.fetchMeals(for: userId)
        } catch {
            print("Error fetching meals: \(error)")
        }
    }

    func loadMeals(userId: String, on date: Date) async {
        do {
            self.todayMeals = try await firestoreService.fetchMeals(for: userId, on: date)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateString = dateFormatter.string(from: date)
            let document = firestoreService.db.collection("diary").document(userId).collection("diary").document(dateString)
            let snapshot = try await document.getDocument()
            self.dailySummary = try? snapshot.data(as: DailySummary.self)
        } catch {
            print("Error fetching meals: \(error)")
        }
    }

    func addMeal(meal: Meal) async {
        do {
            let newMeal = try await firestoreService.addMeal(meal: meal)
            self.meals.insert(newMeal, at: 0)
            let calendar = Calendar.current
            if calendar.isDate(Date(), inSameDayAs: newMeal.timestamp!.dateValue()){
                self.todayMeals.insert(newMeal, at: 0)
            }
            if let timestamp = newMeal.timestamp {
                try await firestoreService.updateDailySummary(userId: newMeal.userId, date: timestamp.dateValue(), mealNutrition: newMeal.nutrition)
                await self.loadMeals(userId: newMeal.userId, on: Date())
            }
        } catch {
            print("Error adding meal: \(error)")
        }
    }

    func updateMeal(meal: Meal) async {
        do {
            try await firestoreService.updateMeal(meal: meal)
            if let index = self.meals.firstIndex(where: { $0.id == meal.id }) {
                self.meals[index] = meal
            }
            if let index = self.todayMeals.firstIndex(where: { $0.id == meal.id }) {
                self.todayMeals[index] = meal
            }
        } catch {
            print("Error updating meal: \(error)")
        }
    }

    func deleteMeal(mealId: String, userId: String) async {
        do {
            try await firestoreService.deleteMeal(mealId: mealId, userId: userId)
            self.meals.removeAll { $0.id == mealId }
            self.todayMeals.removeAll { $0.id == mealId }
        } catch {
            print("Error deleting meal: \(error)")
        }
    }
}

struct MealHistoryView: View {
    @ObservedObject var viewModel: MealViewModel
    var userId: String
    var body: some View {
        List {
            ForEach(viewModel.meals) { meal in
                Text("Meal: \(meal.nutrition.calories)")
            }
        }
        .task {
            await viewModel.loadMeals(userId: userId)
        }
    }
}

struct TodayView: View {
    @ObservedObject var viewModel: MealViewModel
    var userId: String
    var body: some View {
        VStack {
            List {
                ForEach(viewModel.todayMeals) { meal in
                    Text("Meal: \(meal.nutrition.calories)")
                }
            }
            if let summary = viewModel.dailySummary {
                Text("Total Calories: \(summary.totalCalories)")
                Text("Total Protein: \(summary.totalProtein)")
                Text("Total Carbs: \(summary.totalCarbs)")
                Text("Total Fat: \(summary.totalFat)")
            } else {
                Text("No summary available for today.")
            }
        }
        .task{
            await viewModel.loadMeals(userId: userId, on: Date())
        }
    }
}

struct ContentView: View {
    @StateObject private var viewModel = MealViewModel()
    var userId = "testuser"

    var body: some View {
        VStack {
            MealHistoryView(viewModel: viewModel, userId: userId)
            TodayView(viewModel: viewModel, userId: userId)
            Button("Add Meal") {
                Task{
                    let newMeal = Meal(userId: userId, imageURL: "http://example.com/image.jpg", nutrition: Nutrition(calories: 100, protein: 20, carbs: 50, fat: 20))
                    await viewModel.addMeal(meal: newMeal)
                }
            }
        }
    }
}