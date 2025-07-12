//
//  DogFoodViewModel.swift
//  Dogfood
//
//  Created by takumi kowatari on 2025/06/22.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

class DogFoodViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var isSearchActive: Bool = false
    @Published var dogFoods: [DogFood] = []

    var filteredDogFoods: [DogFood] {
        if searchText.isEmpty {
            return dogFoods
        } else {
            return dogFoods.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.keywords.contains { $0.localizedCaseInsensitiveContains(searchText) }
            }
        }
    }

    init() {
        fetchDogFoods()
    }

    func fetchDogFoods() {
        let db = Firestore.firestore()
        let storage = Storage.storage()

        db.collection("dogfood").getDocuments { snapshot, error in
            if let error = error {
                print("Firestore読み込みエラー: \(error.localizedDescription)")
                return
            }

            guard let documents = snapshot?.documents else { return }

            // 一時的にDogFoodリストを用意
            for doc in documents {
                let data = doc.data()

                guard
                    let name = data["name"] as? String,
                    let imagePath = data["imagePath"] as? String,
                    let description = data["description"] as? String,
                    let summary = data["summary"] as? String,
                    let keywords = data["keywords"] as? [String]
                else {
                    continue
                }

                // Firestoreの内容を元に初期DogFoodを作成（imageURLは後で取得）
                var dogFood = DogFood(
                    id: doc.documentID,
                    name: name,
                    imageURL: nil,
                    description: description,
                    summary: summary,
                    keywords: keywords
                )

                // Firebase Storage から imageURL を取得
                let ref = storage.reference(withPath: imagePath)
                ref.downloadURL { url, error in
                    DispatchQueue.main.async {
                        if let url = url {
                            dogFood.imageURL = url
                        } else {
                            print("画像URLの取得失敗: \(error?.localizedDescription ?? "不明なエラー")")
                        }
                        self.dogFoods.append(dogFood)
                        self.objectWillChange.send() // View更新を通知
                    }
                }
            }
        }
    }
}

