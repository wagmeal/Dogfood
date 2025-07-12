//
//  DogfoodApp.swift
//  Dogfood
//
//  Created by takumi kowatari on 2025/06/20.
//
import Foundation

struct DogFood: Identifiable {
    let id: String
    let name: String
    var imageURL: URL? // Storageから取得するURLを保持
    let description: String
    let summary: String
    let keywords: [String]
}

struct Evaluation: Codable, Identifiable {
    var id: String = UUID().uuidString
    var dogFoodId: String
    var userId: String
    var costPerformance: Int
    var appetite: Int
    var health: Int
    var storageEase: Int
    var smell: Int
    var timestamp: Date = Date()
}
