//
//  ContentView.swift
//  CalorieVisionApp
//
//  Created by Vicky T on 4/8/25.

import Firebase
import SwiftUI

struct MealHistoryView: View {
    @ObservedObject var viewModel: MealViewModel
    var userId: String
    var body: some View {
        List {
            ForEach(viewModel.meals) { meal in
                NavigationLink(destination: MealDetailView(viewModel: viewModel, meal: meal)){
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
        .task {
            await viewModel.loadMeals(userId: userId)
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }
}

struct ContentView: View {
    @StateObject private var viewModel = MealViewModel()
    var userId = "testuser" // replace this with the current user's ID

    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: FoodDiaryView(viewModel: viewModel, userId: userId)) {
                    Text("Food Diary")
                }
                .padding()
                NavigationLink(destination: ImageUploadView(viewModel: viewModel, userId: userId)){
                    Text("Add meal")
                }
                .padding()
                MealHistoryView(viewModel: viewModel, userId: userId)
            }
        }
    }
}

