//
//  DogFood.swift
//  Dogfood
//
//  Created by takumi kowatari on 2025/06/20.
//
import SwiftUI
import FirebaseCore

@main
struct DogFoodApp: App {
    @StateObject private var viewModel = DogFoodViewModel()
    // Firebase 初期化
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            TabView {
                MainView()
                    .tabItem {
                        Label("ホーム", systemImage: "house")
                    }
                SearchView(viewModel: viewModel)
                    .tabItem {
                        Label("検索", systemImage: "magnifyingglass")
                    }
            }
        }
    }
}

