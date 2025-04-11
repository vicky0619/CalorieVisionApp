swift
import SwiftUI
import Firebase

@MainActor
class MealViewModel: ObservableObject {
    @Published var meals: [Meal] = []
    @Published var todayMeals: [Meal] = []
    private let firestoreService = FirestoreService()

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
            try await firestoreService.updateDailyDiary(for: meal.userId, on: Date())
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
            try await firestoreService.updateDailyDiary(for: meal.userId, on: Date())
        } catch {
            print("Error updating meal: \(error)")
        }
    }

    func deleteMeal(mealId: String, userId: String) async {
        do {
            
            let meal = meals.first { $0.id == mealId}
            
            if meal != nil{
                try await firestoreService.deleteMeal(mealId: mealId, userId: userId)
                self.meals.removeAll { $0.id == mealId }
                self.todayMeals.removeAll { $0.id == mealId }
                try await firestoreService.updateDailyDiary(for: userId, on: Date())
            }
            
        } catch {
            print("Error deleting meal: \(error)")
        }
    }
}