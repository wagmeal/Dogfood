//
//  EvaluationInputView.swift
//  Dogfood
//
//  Created by takumi kowatari on 2025/07/11.
//
import SwiftUI
import FirebaseFirestore

struct EvaluationInputView: View {
    let dogFoodID: String  // 評価対象のドッグフードID
    @Environment(\.dismiss) var dismiss
    
    // 5つの評価項目（1〜5の範囲）
    @State private var costPerformance: Double = 3
    @State private var appetite: Double = 3
    @State private var health: Double = 3
    @State private var preservation: Double = 3
    @State private var smell: Double = 3
    
    var body: some View {
        Form {
            Section(header: Text("各項目を評価（1〜5）")) {
                RatingSlider(title: "コストパフォーマンス", value: $costPerformance)
                RatingSlider(title: "くいつき", value: $appetite)
                RatingSlider(title: "健康", value: $health)
                RatingSlider(title: "保存のしやすさ", value: $preservation)
                RatingSlider(title: "匂い", value: $smell)
            }
            
            Button("評価を送信") {
                submitEvaluation()
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.gray)
            .cornerRadius(10)
        }
        .navigationTitle("評価を入力")
        .toolbar {
            // ⬅️ ここが右上のキャンセルボタン
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("キャンセル") {
                    dismiss()
                }
            }
        }
    }
    
    func submitEvaluation() {
        let db = Firestore.firestore()
        let evaluationData: [String: Any] = [
            "dogFoodID": dogFoodID,
            "timestamp": Timestamp(),
            "costPerformance": Int(costPerformance),
            "appetite": Int(appetite),
            "health": Int(health),
            "preservation": Int(preservation),
            "smell": Int(smell)
        ]
        
        db.collection("evaluations").addDocument(data: evaluationData) { error in
            if let error = error {
                print("評価の保存に失敗: \(error.localizedDescription)")
            } else {
                print("評価を保存しました")
                dismiss()
            }
        }
    }
}

struct RatingSlider: View {
    let title: String
    @Binding var value: Double
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(title): \(Int(value))")
            Slider(value: $value, in: 1...5, step: 1)
                .accentColor(Color(hue: 0.127, saturation: 0.202, brightness: 0.84))
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    NavigationStack {
        EvaluationInputView(dogFoodID: "testDogFoodID")
    }
}
