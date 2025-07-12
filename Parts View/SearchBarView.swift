//
//  SearchBarView.swift
//  Dogfood
//
//  Created by takumi kowatari on 2025/06/21.
//
import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String
    @Binding var isSearchActive: Bool
    @FocusState var isFocused: Bool

    var body: some View {
        HStack {
            TextField("検索", text: $searchText)
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .focused($isFocused)
                .onChange(of: isFocused) {
                    if isFocused {
                        isSearchActive = true
                    }
                }


            if isFocused {
                Button("キャンセル") {
                    searchText = ""
                    isSearchActive = false
                    isFocused = false
                }
                .transition(.move(edge: .trailing))
            }
        }
        .padding()
    }
}

#Preview {
    SearchBarPreviewWrapper()
}

private struct SearchBarPreviewWrapper: View {
    @State private var searchText: String = ""
    @State private var isSearchActive: Bool = false
    @FocusState private var isFocused: Bool

    var body: some View {
        SearchBarView(
            searchText: $searchText,
            isSearchActive: $isSearchActive,
            isFocused: _isFocused
        )
    }
}
