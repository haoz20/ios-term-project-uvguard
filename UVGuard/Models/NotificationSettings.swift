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
    
    // UV Threshold for alerts
    var uvThreshold: Int {
        didSet {
            UserDefaults.standard.set(uvThreshold, forKey: "uvThreshold")
        }
    }
    
    // Morning Briefing Settings
    var morningBriefingEnabled: Bool {
        didSet {
            UserDefaults.standard.set(morningBriefingEnabled, forKey: "morningBriefingEnabled")
            if !morningBriefingEnabled {
                UVNotificationManager.shared.removeMorningBriefing()
            }
        }
    }
    
    var morningBriefingTime: Date {
        didSet {
            UserDefaults.standard.set(morningBriefingTime, forKey: "morningBriefingTime")
        }
    }
    
    // Evening Briefing Settings
    var eveningBriefingEnabled: Bool {
        didSet {
            UserDefaults.standard.set(eveningBriefingEnabled, forKey: "eveningBriefingEnabled")
            if !eveningBriefingEnabled {
                UVNotificationManager.shared.removeEveningBriefing()
            }
        }
    }
    
    var eveningBriefingTime: Date {
        didSet {
            UserDefaults.standard.set(eveningBriefingTime, forKey: "eveningBriefingTime")
        }
    }
    
    // Threshold Notifications (deprecated but kept for migration)
    var thresholdNotificationsEnabled: Bool {
        didSet {
            UserDefaults.standard.set(thresholdNotificationsEnabled, forKey: "thresholdNotificationsEnabled")
        }
    }
    
    // Deprecated properties for backward compatibility
    var dailyForecastEnabled: Bool {
        get { morningBriefingEnabled }
        set { morningBriefingEnabled = newValue }
    }
    
    var dailyForecastTime: Date {
        get { morningBriefingTime }
        set { morningBriefingTime = newValue }
    }
    
    private init() {
        // Load UV Threshold
        self.uvThreshold = UserDefaults.standard.object(forKey: "uvThreshold") as? Int ?? 6
        
        // Load Morning Briefing settings (default: enabled at 8:00 AM)
        self.morningBriefingEnabled = UserDefaults.standard.object(forKey: "morningBriefingEnabled") as? Bool ?? true
        if let savedTime = UserDefaults.standard.object(forKey: "morningBriefingTime") as? Date {
            self.morningBriefingTime = savedTime
        } else {
            var components = DateComponents()
            components.hour = 8
            components.minute = 0
            self.morningBriefingTime = Calendar.current.date(from: components) ?? Date()
        }
        
        // Load Evening Briefing settings (default: enabled at 8:00 PM)
        self.eveningBriefingEnabled = UserDefaults.standard.object(forKey: "eveningBriefingEnabled") as? Bool ?? true
        if let savedTime = UserDefaults.standard.object(forKey: "eveningBriefingTime") as? Date {
            self.eveningBriefingTime = savedTime
        } else {
            var components = DateComponents()
            components.hour = 20
            components.minute = 0
            self.eveningBriefingTime = Calendar.current.date(from: components) ?? Date()
        }
        
        // Kept for backward compatibility
        self.thresholdNotificationsEnabled = UserDefaults.standard.object(forKey: "thresholdNotificationsEnabled") as? Bool ?? true
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
