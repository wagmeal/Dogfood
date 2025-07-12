//
//  DogFoodDetailView.swift
//  Dogfood
//
//  Created by takumi kowatari on 2025/06/20.
//

import SwiftUI

struct DogFoodDetailView: View {
    let dogFood: DogFood
    @StateObject private var evalVM = EvaluationViewModel()
    @State private var isPresentingEvaluationInput = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // 画像表示
                if let url = dogFood.imageURL {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(12)
                        case .failure:
                            Image(systemName: "photo")
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .frame(height: 200)
                } else {
                    ProgressView().frame(height: 200)
                }

                // 名前・説明
                Text(dogFood.name)
                    .font(.largeTitle)
                    .bold()

                Text(dogFood.description)
                    .font(.body)

                Divider()

                // 📊 レーダーチャート（平均評価）
                if let avg = evalVM.average {
                    Text("平均評価")
                        .font(.headline)
                    RadarChartView(values: [
                        avg.costPerformance,
                        avg.appetite,
                        avg.health,
                        avg.preservation,
                        avg.smell
                    ],
                    labels: ["コスパ", "くいつき", "健康", "保存", "匂い"])
                    .frame(height: 250)
                } else {
                    Text("評価データがまだありません")
                        .foregroundColor(.gray)
                }

                // 評価入力ボタン
                Button("評価を入力する") {
                    isPresentingEvaluationInput = true
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding()
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            evalVM.fetchAverages(for: dogFood.id)
        }
        .sheet(isPresented: $isPresentingEvaluationInput) {
            NavigationStack {
                EvaluationInputView(dogFoodID: dogFood.id)
            }
        }
    }
}

#Preview {
    NavigationStack {
        DogFoodDetailView(dogFood: DogFood(
            id: "test-id",
            name: "プレミアムドッグ",
            imageURL: URL(string: "https://firebasestorage.googleapis.com/v0/b/mydogfoodapp-1b171.appspot.com/o/testimage%2Fkiaora1.jpg?alt=media&token=a5fd99e3-c25d-4951-bb17-620c71ebb3db"),
            description: "これは詳細な説明文です。",
            summary: "おすすめドッグフード",
            keywords: ["プレミアム", "ドッグフード"]
        ))
    }
}

