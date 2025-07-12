//
//  SearchResultView.swift
//  Dogfood
//
//  Created by takumi kowatari on 2025/06/21.
//
import SwiftUI

struct SearchResultsView: View {
    @ObservedObject var viewModel: DogFoodViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.filteredDogFoods) { dogFood in
                    NavigationLink(destination: DogFoodDetailView(dogFood: dogFood)
                        .onDisappear {
                            viewModel.searchText = ""
                            viewModel.isSearchActive = false
                        }
                    ) {
                        HStack {
                            // 🔁 StorageのimageURLを使って非同期表示
                            if let url = dogFood.imageURL {
                                AsyncImage(url: url) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 60, height: 60)
                                            .cornerRadius(8)
                                    case .failure:
                                        Image(systemName: "photo")
                                            .frame(width: 60, height: 60)
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                            } else {
                                ProgressView()
                                    .frame(width: 60, height: 60)
                            }

                            VStack(alignment: .leading, spacing: 4) {
                                Text(dogFood.name)
                                    .font(.headline)
                                Text(dogFood.summary)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .lineLimit(2)
                            }
                            Spacer()
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(radius: 2)
                        .padding(.horizontal)
                    }
                }
            }
        }
    }
}

