import SwiftUI

struct UVComponent: View {
    let uvData: Double
    @State private var animationProgress: CGFloat = 0
    @State private var pulseScale: CGFloat = 1
    @State private var rotationAngle: Double = 0
    
    // UV Index categories and colors
    private var uvLevel: UVLevel {
        switch uvData {
        case 0..<3: return .low
        case 3..<6: return .moderate
        case 6..<8: return .high
        case 8..<11: return .veryHigh
        default: return .extreme
        }
    }
    
    private var uvColor: Color {
        switch uvLevel {
        case .low: return .green
        case .moderate: return .yellow
        case .high: return .orange
        case .veryHigh: return .red
        case .extreme: return .purple
        }
    }
    
    private var uvDescription: String {
        switch uvLevel {
        case .low: return "Low"
        case .moderate: return "Moderate"
        case .high: return "High"
        case .veryHigh: return "Very High"
        case .extreme: return "Extreme"
        }
    }
    
    private var uvAdvice: String {
        switch uvLevel {
        case .low: return "Minimal protection needed"
        case .moderate: return "Stay in shade during midday"
        case .high: return "Protection essential"
        case .veryHigh: return "Extra protection required"
        case .extreme: return "Avoid sun exposure"
        }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                Image(systemName: "sun.max.fill")
                    .foregroundColor(uvColor)
                    .font(.uvTitle2)
                    .rotationEffect(.degrees(rotationAngle))
                
                Text("UV Index")
                    .font(.uvHeadline)
                    .fontWeight(.semibold)
                    .uvPrimaryText()
                
                Spacer()
            }
            
            // Main UV Display
            ZStack {
                // Background circle with gradient
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                uvColor.opacity(0.1),
                                uvColor.opacity(0.3)
                            ]),
                            center: .center,
                            startRadius: 20,
                            endRadius: 80
                        )
                    )
                    .frame(width: 160, height: 160)
                    .scaleEffect(pulseScale)
                
                // Progress ring
                Circle()
                    .trim(from: 0, to: animationProgress * (uvData / 11.0))
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [uvColor.opacity(0.6), uvColor]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .frame(width: 140, height: 140)
                    .rotationEffect(.degrees(-90))
                
                // UV Value
                VStack(spacing: 4) {
                    Text("\(Int(round(uvData)))")
                        .font(.uvIndexNumber)
                        .foregroundColor(uvColor)
                        .scaleEffect(animationProgress)
                    
                    Text(uvDescription)
                        .font(.uvCaption)
                        .fontWeight(.medium)
                        .uvSecondaryText()
                        .opacity(animationProgress)
                }
            }
            
            // UV Scale Indicator
            VStack(spacing: 12) {
                Text("UV Scale")
                    .font(.uvSubheadline)
                    .fontWeight(.medium)
                    .uvSecondaryText()
                
                HStack(spacing: 2) {
                    ForEach(0..<11, id: \.self) { index in
                        Rectangle()
                            .fill(getScaleColor(for: index))
                            .frame(width: 25, height: 8)
                            .opacity(Double(index) <= uvData ? 1.0 : 0.3)
                            .scaleEffect(Double(index) <= uvData ? 1.1 : 1.0)
                            .animation(
                                .spring(response: 0.6, dampingFraction: 0.8)
                                .delay(Double(index) * 0.05),
                                value: animationProgress
                            )
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 4))
                
                HStack {
                    Text("0")
                        .font(.uvCaption2)
                        .uvSecondaryText()
                    Spacer()
                    Text("11+")
                        .font(.uvCaption2)
                        .uvSecondaryText()
                }
            }
            
            // Advice Card
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "info.circle.fill")
                        .foregroundColor(uvColor)
                    Text("Recommendation")
                        .font(.uvSubheadline)
                        .fontWeight(.semibold)
                        .uvPrimaryText()
                }
                
                Text(uvAdvice)
                    .font(.uvBody)
                    .uvSecondaryText()
                    .multilineTextAlignment(.leading)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(uvColor.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(uvColor.opacity(0.3), lineWidth: 1)
                    )
            )
            .opacity(animationProgress)
        }
        .padding(24)
        .modifier(UVCardModifier())
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        // Main animation sequence
        withAnimation(.easeInOut(duration: 1.2)) {
            animationProgress = 1
        }
        
        // Pulse animation
        withAnimation(
            .easeInOut(duration: 2.0)
            .repeatForever(autoreverses: true)
        ) {
            pulseScale = 1.05
        }
        
        // Sun rotation animation
        withAnimation(
            .linear(duration: 10.0)
            .repeatForever(autoreverses: false)
        ) {
            rotationAngle = 360
        }
    }
    
    private func resetAndAnimate() {
        animationProgress = 0
        withAnimation(.easeInOut(duration: 1.0)) {
            animationProgress = 1
        }
    }
    
    private func getScaleColor(for index: Int) -> Color {
        switch index {
        case 0...2: return .green
        case 3...5: return .yellow
        case 6...7: return .orange
        case 8...10: return .red
        default: return .purple
        }
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 20) {
            UVComponent(uvData: 2.5)
            UVComponent(uvData: 6.8)
            UVComponent(uvData: 9.2)
        }
        .padding()
    }
    .background(LinearGradient.uvBackground)
}
