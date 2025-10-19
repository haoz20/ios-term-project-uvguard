//
//  Date+TimeFormat.swift
//  UVGuard
//
//  Date extension for consistent time formatting across the app
//

import Foundation

extension Date {
    /// Format time according to user preference (12-hour or 24-hour)
    /// - Parameter use24Hour: Whether to use 24-hour format. If nil, uses SettingsManager preference
    /// - Returns: Formatted time string (e.g., "2:30 PM" or "14:30")
    func formattedTime(use24Hour: Bool? = nil) -> String {
        let use24 = use24Hour ?? SettingsManager.shared.is24HourTime
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = use24 ? "HH:mm" : "h:mm a"
        return formatter.string(from: self)
    }
    
    /// Format time with seconds according to user preference
    /// - Parameter use24Hour: Whether to use 24-hour format. If nil, uses SettingsManager preference
    /// - Returns: Formatted time string with seconds (e.g., "2:30:45 PM" or "14:30:45")
    func formattedTimeWithSeconds(use24Hour: Bool? = nil) -> String {
        let use24 = use24Hour ?? SettingsManager.shared.is24HourTime
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = use24 ? "HH:mm:ss" : "h:mm:ss a"
        return formatter.string(from: self)
    }
    
    /// Format hour only according to user preference
    /// - Parameter use24Hour: Whether to use 24-hour format. If nil, uses SettingsManager preference
    /// - Returns: Formatted hour string (e.g., "2 PM" or "14")
    func formattedHour(use24Hour: Bool? = nil) -> String {
        let use24 = use24Hour ?? SettingsManager.shared.is24HourTime
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = use24 ? "HH" : "ha"
        return formatter.string(from: self)
    }
    
    /// Format short hour for compact display
    /// - Parameter use24Hour: Whether to use 24-hour format. If nil, uses SettingsManager preference
    /// - Returns: Formatted short hour string (e.g., "2P" or "14")
    func formattedShortHour(use24Hour: Bool? = nil) -> String {
        let use24 = use24Hour ?? SettingsManager.shared.is24HourTime
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        if use24 {
            formatter.dateFormat = "HH"
        } else {
            formatter.dateFormat = "ha"
            // Remove the 'M' from AM/PM for compact display
            let result = formatter.string(from: self)
            return result.replacingOccurrences(of: "M", with: "")
        }
        return formatter.string(from: self)
    }
}

extension DateFormatter {
    /// Creates a DateFormatter for time with user's preference
    static func timeFormatter(use24Hour: Bool? = nil) -> DateFormatter {
        let use24 = use24Hour ?? SettingsManager.shared.is24HourTime
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = use24 ? "HH:mm" : "h:mm a"
        return formatter
    }
    
    /// Creates a DateFormatter for hour with user's preference
    static func hourFormatter(use24Hour: Bool? = nil) -> DateFormatter {
        let use24 = use24Hour ?? SettingsManager.shared.is24HourTime
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = use24 ? "HH" : "ha"
        return formatter
    }
}
