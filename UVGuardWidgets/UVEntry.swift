//
//  UVEntry.swift
//  UVGuardWidgets
//
//  Created by Swan Htet Aung on 18/10/25.
//

import WidgetKit
import SwiftUI

// MARK: - Timeline Entry
struct UVEntry: TimelineEntry {
    let date: Date
    let currentUV: Double
    let hourlyForecast: [(hour: String, uv: Double)]
}

// MARK: - UV Level
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
    
    var advice: String {
        switch self {
        case .low: return "Minimal protection needed"
        case .moderate: return "Stay in shade during midday"
        case .high: return "Protection essential"
        case .veryHigh: return "Extra protection required"
        case .extreme: return "Avoid sun exposure"
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
