//
//  UVGuardTheme.swift
//  UVGuard
//
//  Theme colors and styles for UV Guard app
//

import SwiftUI

// MARK: - Color Palette

extension Color {
    // Primary palette
    static let uvLightCream = Color(hex: "FBF9D1")
    static let uvSandBeige = Color(hex: "FFFDE7")
    static let uvWarmTan = Color(hex: "C1856D")
    static let uvDeepRed = Color(hex: "9A3F3F")
    static let uvSoftYellow = Color(hex: "FEF3E2")
    static let uvGoldAccent = Color(hex: "FAB12F")
    static let uvOrangeHighlight = Color(hex: "FA812F")
    static let uvWarningRed = Color(hex: "DD0303")
    
    // Semantic colors
    static let uvBackground = Color.uvSoftYellow
    static let uvCardBackground = Color.uvSandBeige
    static let uvPrimaryText = Color.uvDeepRed
    static let uvSecondaryText = Color.uvWarmTan
    static let uvAccent = Color.uvGoldAccent
    static let uvDanger = Color.uvWarningRed  // Alias for danger/warning states
    
    // UV Level specific colors (keeping standard for recognition)
    static let uvLow = Color.green
    static let uvModerate = Color.uvGoldAccent
    static let uvHigh = Color.uvOrangeHighlight
    static let uvVeryHigh = Color.uvWarningRed
    static let uvExtreme = Color.purple
    
    // Helper initializer for hex colors
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Gradients

extension LinearGradient {
    static let uvPrimaryButton = LinearGradient(
        colors: [Color.uvGoldAccent, Color.uvOrangeHighlight],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    static let uvBackground = LinearGradient(
        colors: [Color.uvSoftYellow, Color.uvLightCream],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let uvCard = LinearGradient(
        colors: [Color.uvSandBeige, Color(hex: "FFF8E1")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let uvDanger = LinearGradient(
        colors: [Color.uvWarningRed, Color.uvWarningRed.opacity(0.9)],
        startPoint: .leading,
        endPoint: .trailing
    )
}

// MARK: - Button Styles

struct UVPrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(.white)
            .padding(.horizontal, 32)
            .padding(.vertical, 14)
            .background(LinearGradient.uvPrimaryButton)
            .cornerRadius(12)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .shadow(color: Color.uvOrangeHighlight.opacity(0.3), radius: 8, x: 0, y: 4)
    }
}

struct UVDangerButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(.white)
            .padding(.horizontal, 32)
            .padding(.vertical, 14)
            .background(LinearGradient.uvDanger)
            .cornerRadius(12)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .shadow(color: Color.uvWarningRed.opacity(0.3), radius: 8, x: 0, y: 4)
    }
}

struct UVSecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(.uvPrimaryText)
            .padding(.horizontal, 32)
            .padding(.vertical, 14)
            .background(Color.uvCardBackground)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.uvWarmTan, lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

// MARK: - Card Style

struct UVCardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.uvCardBackground)
                    .shadow(color: Color.uvWarmTan.opacity(0.2), radius: 10, x: 0, y: 4)
            )
    }
}

extension View {
    func uvCard() -> some View {
        modifier(UVCardModifier())
    }
}

// MARK: - Text Styles

extension View {
    func uvPrimaryText() -> some View {
        self.foregroundColor(.uvPrimaryText)
    }
    
    func uvSecondaryText() -> some View {
        self.foregroundColor(.uvSecondaryText)
    }
}
