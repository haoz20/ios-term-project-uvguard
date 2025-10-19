//
//  WidgetAssets.swift
//  UVGuardWidgets
//
//  Created by Swan Htet Aung on 18/10/25.
//

import SwiftUI

// MARK: - UV Guard Theme Colors (matching app)
extension Color {
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
    
    // Helper initializer for hex colors
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}
