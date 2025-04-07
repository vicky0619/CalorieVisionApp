import SwiftUI

struct HistoryView: View {
    let records: [FoodAnalysisRecord]

    var body: some View {
        NavigationView {
            List(records.reversed()) { record in
                VStack(alignment: .leading) {
                    if let uiImage = UIImage(data: record.imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                    }

                    Text(record.resultText)
                        .font(.body)
                        .padding(.top, 5)

                    Text("📅 \(record.timestamp.formatted(date: .abbreviated, time: .shortened))")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 8)
            }
            .navigationTitle("歷史紀錄")
        }
    }
}
