//
//  ContentView.swift
//  Dogfood
//
//  Created by takumi kowatari on 2025/06/20.
//
import SwiftUI

struct SearchView: View {
    @ObservedObject var viewModel: DogFoodViewModel
    @FocusState private var isFocused: Bool

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                SearchBarView(
                    searchText: $viewModel.searchText,
                    isSearchActive: $viewModel.isSearchActive,
                    isFocused: _isFocused
                )

                if !viewModel.isSearchActive {
                    SearchIdleView()
                } else {
                    SearchResultsView(viewModel: viewModel)
                }
            }
            .navigationBarHidden(true)
        }
    }
}
