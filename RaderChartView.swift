//
//  RaderChartView.swift
//  Dogfood
//
//  Created by takumi kowatari on 2025/07/12.
//
import SwiftUI

struct RadarChartView: View {
    var values: [Double]  // 各項目の平均（最大値5）
    var labels: [String]  // 各頂点に表示する項目名（5つ）
    
    var body: some View {
        GeometryReader { geo in
            let size = min(geo.size.width, geo.size.height)
            let center = CGPoint(x: size / 2, y: size / 2)
            let radius = size / 2 * 0.8
            
            // 👇 型推論の負担を軽減するために分割
            let startAngle = -Double.pi / 2
            let endAngle = 3 * Double.pi / 2
            let angleStep = 2 * Double.pi / 5
            let doubleAngles = stride(from: startAngle, to: endAngle, by: angleStep)
            let angles: [CGFloat] = doubleAngles.map { CGFloat($0) }
            
            ZStack {
                // 軸線
                ForEach(0..<5, id: \.self) { i in
                    Path { path in
                        let angle = angles[i]
                        let point = CGPoint(
                            x: center.x + cos(angle) * radius,
                            y: center.y + sin(angle) * radius
                        )
                        path.move(to: center)
                        path.addLine(to: point)
                    }
                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                }
                
                // グリッド
                ForEach(1...5, id: \.self) { level in
                    Path { path in
                        for i in 0..<5 {
                            let angle = angles[i]
                            let point = CGPoint(
                                x: center.x + cos(angle) * radius * CGFloat(level) / 5,
                                y: center.y + sin(angle) * radius * CGFloat(level) / 5
                            )
                            if i == 0 {
                                path.move(to: point)
                            } else {
                                path.addLine(to: point)
                            }
                        }
                        path.closeSubpath()
                    }
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                }
                
                // アニメーション付きの値表示
                Path { path in
                    for i in 0..<5 {
                        let angle = angles[i]
                        let scaledValue = CGFloat(values[i]) / 5
                        let point = CGPoint(
                            x: center.x + cos(angle) * radius * scaledValue,
                            y: center.y + sin(angle) * radius * scaledValue
                        )
                        if i == 0 {
                            path.move(to: point)
                        } else {
                            path.addLine(to: point)
                        }
                    }
                    path.closeSubpath()
                }
                .fill(Color.orange.opacity(0.4))
                
                // ラベル
                ForEach(0..<5, id: \.self) { i in
                    let angle = angles[i]
                    let offset: CGFloat = 20
                    let point = CGPoint(
                        x: center.x + cos(angle) * (radius + offset),
                        y: center.y + sin(angle) * (radius + offset)
                    )
                    Text(labels[i])
                        .font(.caption)
                        .foregroundColor(.black)
                        .position(point)
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .frame(height: 250)
    }
}

#Preview {
    RadarChartView(
        values: [4.0, 3.5, 5.0, 2.0, 3.0],
        labels: ["コスパ", "くいつき", "健康", "保存", "匂い"]
    )
    .padding()
}
