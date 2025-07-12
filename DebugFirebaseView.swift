//
//  DebugFirebaseView.swift
//  Dogfood
//
//  Created by takumi kowatari on 2025/07/02.
//

import SwiftUI
import FirebaseStorage

struct StorageDebugView: View {
    @State private var imageURL: URL?
    @State private var errorMessage: String?
    
    // Firebase Storage 上のパス（トークン不要）
    let imagePath = "testimage/kiaora1.jpg"

    var body: some View {
        VStack(spacing: 20) {
            Text("Storage デバッグビュー")
                .font(.title)
                .bold()
            
            Text("Storage パス: \(imagePath)")
                .font(.subheadline)
                .foregroundColor(.gray)

            if let url = imageURL {
                Text("取得URL: \(url.absoluteString)")
                    .font(.caption)
                    .foregroundColor(.blue)
                    .lineLimit(3)
                    .multilineTextAlignment(.center)

                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .border(Color.green)
                    case .failure(let error):
                        VStack {
                            Image(systemName: "xmark.octagon.fill")
                                .font(.largeTitle)
                            Text("画像読み込み失敗")
                            Text(error.localizedDescription)
                        }
                        .foregroundColor(.red)
                    @unknown default:
                        EmptyView()
                    }
                }
            } else if let errorMessage = errorMessage {
                VStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.title)
                    Text("downloadURL取得失敗")
                    Text(errorMessage)
                        .font(.caption)
                }
                .foregroundColor(.red)
            } else {
                ProgressView()
                    .onAppear {
                        fetchImageURL()
                    }
            }
        }
        .padding()
    }

    private func fetchImageURL() {
        let storageRef = Storage.storage().reference(withPath: imagePath)
        storageRef.downloadURL { url, error in
            if let url = url {
                self.imageURL = url
                print("✅ downloadURL 取得成功: \(url.absoluteString)") // ← ここを追加！
            } else if let error = error {
                self.errorMessage = error.localizedDescription
                print("❌ downloadURL 取得失敗: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    StorageDebugView()
}

