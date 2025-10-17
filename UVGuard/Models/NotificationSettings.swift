//
//  NotificationSettings.swift
//  UVGuard
//
//  Created on UV Notification Implementation
//

import Foundation
import SwiftUI

@Observable
class NotificationSettings {
    static let shared = NotificationSettings()
    
    // User preferences - removed notificationsEnabled toggle (use system settings instead)
    var uvThreshold: Int {  // Changed to Int for discrete values
        didSet {
            UserDefaults.standard.set(uvThreshold, forKey: "uvThreshold")
        }
    }
    
    var dailyForecastEnabled: Bool {
        didSet {
            UserDefaults.standard.set(dailyForecastEnabled, forKey: "dailyForecastEnabled")
            if !dailyForecastEnabled {
                UVNotificationManager.shared.removeDailyForecastNotification()
            }
        }
    }
    
    var dailyForecastTime: Date {
        didSet {
            UserDefaults.standard.set(dailyForecastTime, forKey: "dailyForecastTime")
        }
    }
    
    var thresholdNotificationsEnabled: Bool {
        didSet {
            UserDefaults.standard.set(thresholdNotificationsEnabled, forKey: "thresholdNotificationsEnabled")
            if !thresholdNotificationsEnabled {
                UVNotificationManager.shared.removeThresholdNotifications()
            }
        }
    }
    
    private init() {
        // Load from UserDefaults or use defaults
        self.uvThreshold = UserDefaults.standard.object(forKey: "uvThreshold") as? Int ?? 6
        self.dailyForecastEnabled = UserDefaults.standard.object(forKey: "dailyForecastEnabled") as? Bool ?? true
        self.thresholdNotificationsEnabled = UserDefaults.standard.object(forKey: "thresholdNotificationsEnabled") as? Bool ?? true
        
        // Default to 7 AM
        if let savedTime = UserDefaults.standard.object(forKey: "dailyForecastTime") as? Date {
            self.dailyForecastTime = savedTime
        } else {
            var components = DateComponents()
            components.hour = 7
            components.minute = 0
            self.dailyForecastTime = Calendar.current.date(from: components) ?? Date()
        }
    }
    
    // MARK: - Helper Methods
    
    func getThresholdLevel() -> UVLevel {
        let threshold = Double(uvThreshold)
        switch threshold {
        case 0..<3: return .low
        case 3..<6: return .moderate
        case 6..<8: return .high
        case 8..<11: return .veryHigh
        default: return .extreme
        }
    }
    
    func getThresholdDescription() -> String {
        let level = getThresholdLevel()
        return "\(uvThreshold) - \(level.description)"
    }
}
