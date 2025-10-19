//
//  UVLevelWidget.swift
//  UVGuardWidgets
//
//  Widget-specific UVLevel helpers
//  NOTE: This is temporary. Ideally, add UVLevel.swift to Widget target membership in Xcode
//

import SwiftUI

// MARK: - UV Level for Widgets
enum UVLevel {
    case low, moderate, high, veryHigh, extreme
    
    var color: Color {
        switch self {
        case .low: return .green
        case .moderate: return .yellow
        case .high: return .orange
        case .veryHigh: return .red
        case .extreme: return .purple
        }
    }
    
    var description: String {
        switch self {
        case .low: return "Low"
        case .moderate: return "Moderate"
        case .high: return "High"
        case .veryHigh: return "Very High"
        case .extreme: return "Extreme"
        }
    }
}

// MARK: - Helper Function
func getUVLevel(for uv: Double) -> UVLevel {
    switch uv {
    case 0..<3: return .low
    case 3..<6: return .moderate
    case 6..<8: return .high
    case 8..<11: return .veryHigh
    default: return .extreme
    }
}
