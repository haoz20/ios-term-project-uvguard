//
//  UVLevel.swift
//  UVGuard
//
//  Created by Swan Htet Aung on 11/9/25.
//

import SwiftUI

enum UVLevel {
    case low
    case moderate
    case high
    case veryHigh
    case extreme
    
    var color: Color {
        switch self {
        case .low:
            return .uvLow
        case .moderate:
            return .uvModerate
        case .high:
            return .uvHigh
        case .veryHigh:
            return .uvVeryHigh
        case .extreme:
            return .uvExtreme
        }
    }
    
    var description: String {
        switch self {
        case .low:
            return "Low"
        case .moderate:
            return "Moderate"
        case .high:
            return "High"
        case .veryHigh:
            return "Very High"
        case .extreme:
            return "Extreme"
        }
    }
    
    var recommendation: String {
        switch self {
        case .low:
            return "No protection needed. You can safely stay outside."
        case .moderate:
            return "Wear sunscreen and a hat if outside for extended periods."
        case .high:
            return "Protection essential. Wear sunscreen, hat, and sunglasses."
        case .veryHigh:
            return "Extra protection needed. Seek shade during midday hours."
        case .extreme:
            return "Avoid sun exposure. Stay indoors if possible."
        }
    }
}

// Helper function to get UV level from numeric value
func getUVLevel(for uvIndex: Double) -> UVLevel {
    switch uvIndex {
    case 0..<3:
        return .low
    case 3..<6:
        return .moderate
    case 6..<8:
        return .high
    case 8..<11:
        return .veryHigh
    default:
        return .extreme
    }
}
