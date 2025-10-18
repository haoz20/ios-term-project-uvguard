//
//  UVLineChart.swift
//  UVGuard
//
//  Simple line chart for UV index visualization
//

import SwiftUI

struct UVLineChart: View {
    let dataPoints: [Double]
    let labels: [String]
    let maxValue: Double
    let height: CGFloat
    
    init(dataPoints: [Double], labels: [String], height: CGFloat = 120) {
        self.dataPoints = dataPoints
        self.labels = labels
        self.maxValue = max(dataPoints.max() ?? 11, 11) // At least 11 for scale
        self.height = height
    }
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let stepX = width / CGFloat(max(dataPoints.count - 1, 1))
            
            ZStack(alignment: .topLeading) {
                // Background grid lines
                VStack(spacing: 0) {
                    ForEach(0..<4) { i in
                        Divider()
                            .background(Color.uvSecondaryText.opacity(0.1))
                        if i < 3 {
                            Spacer()
                        }
                    }
                }
                
                // Line chart path
                Path { path in
                    guard !dataPoints.isEmpty else { return }
                    
                    let points = dataPoints.enumerated().map { index, value in
                        CGPoint(
                            x: CGFloat(index) * stepX,
                            y: height - (CGFloat(value) / CGFloat(maxValue)) * height
                        )
                    }
                    
                    path.move(to: points[0])
                    for point in points.dropFirst() {
                        path.addLine(to: point)
                    }
                }
                .stroke(
                    LinearGradient(
                        colors: [Color.uvAccent, Color.uvOrangeHighlight],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round)
                )
                
                // Gradient fill under the line
                Path { path in
                    guard !dataPoints.isEmpty else { return }
                    
                    let points = dataPoints.enumerated().map { index, value in
                        CGPoint(
                            x: CGFloat(index) * stepX,
                            y: height - (CGFloat(value) / CGFloat(maxValue)) * height
                        )
                    }
                    
                    path.move(to: CGPoint(x: points[0].x, y: height))
                    path.addLine(to: points[0])
                    for point in points.dropFirst() {
                        path.addLine(to: point)
                    }
                    path.addLine(to: CGPoint(x: points.last!.x, y: height))
                    path.closeSubpath()
                }
                .fill(
                    LinearGradient(
                        colors: [
                            Color.uvAccent.opacity(0.3),
                            Color.uvAccent.opacity(0.1),
                            Color.uvAccent.opacity(0.0)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                
                // Data point circles
                ForEach(Array(dataPoints.enumerated()), id: \.offset) { index, value in
                    let x = CGFloat(index) * stepX
                    let y = height - (CGFloat(value) / CGFloat(maxValue)) * height
                    
                    Circle()
                        .fill(getColorForUV(value))
                        .frame(width: 8, height: 8)
                        .position(x: x, y: y)
                        .shadow(color: getColorForUV(value).opacity(0.5), radius: 3)
                }
            }
        }
        .frame(height: height)
    }
    
    private func getColorForUV(_ uv: Double) -> Color {
        switch uv {
        case 0..<3: return .green
        case 3..<6: return .uvAccent
        case 6..<8: return .uvOrangeHighlight
        case 8..<11: return .uvDanger
        default: return .purple
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        UVLineChart(
            dataPoints: [2, 3, 5, 7, 9, 8, 6, 4, 2],
            labels: ["9AM", "10AM", "11AM", "12PM", "1PM", "2PM", "3PM", "4PM", "5PM"]
        )
        .padding()
    }
    .background(LinearGradient.uvBackground)
}
