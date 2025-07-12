//
//  EvaluationAverage.swift
//  Dogfood
//
//  Created by takumi kowatari on 2025/07/12.
//
import FirebaseFirestore

struct EvaluationAverage {
    var costPerformance: Double
    var appetite: Double
    var health: Double
    var preservation: Double
    var smell: Double
}

class EvaluationViewModel: ObservableObject {
    @Published var average: EvaluationAverage?

    func fetchAverages(for dogFoodID: String) {
        let db = Firestore.firestore()
        db.collection("evaluations").whereField("dogFoodID", isEqualTo: dogFoodID).getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else { return }
            
            var total = EvaluationAverage(costPerformance: 0, appetite: 0, health: 0, preservation: 0, smell: 0)
            let count = Double(documents.count)
            
            for doc in documents {
                let data = doc.data()
                total.costPerformance += Double(data["costPerformance"] as? Int ?? 0)
                total.appetite += Double(data["appetite"] as? Int ?? 0)
                total.health += Double(data["health"] as? Int ?? 0)
                total.preservation += Double(data["preservation"] as? Int ?? 0)
                total.smell += Double(data["smell"] as? Int ?? 0)
            }
            
            if count > 0 {
                self.average = EvaluationAverage(
                    costPerformance: total.costPerformance / count,
                    appetite: total.appetite / count,
                    health: total.health / count,
                    preservation: total.preservation / count,
                    smell: total.smell / count
                )
            }
        }
    }
}
