//
//  RootView.swift
//  Dogfood
//
//  Created by takumi kowatari on 2025/06/21.
//
import SwiftUI

struct DogFoodAppPreviewWrapper: View {
    @StateObject private var viewModel = DogFoodViewModel()

    var body: some View {
        TabView {
            MainView()
                .tabItem {
                    Label("ホーム", systemImage: "house")
                }

            SearchView(viewModel: viewModel)
                .tabItem {
                    Label("さがす", systemImage: "magnifyingglass")
                }
        }
    }
}

#Preview {
    DogFoodAppPreviewWrapper()
}
