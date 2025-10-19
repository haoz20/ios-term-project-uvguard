//
//  UVNotificationManager.swift
//  UVGuard
//
//  Created on UV Notification Implementation
//

import Foundation
import UserNotifications
import SwiftUI

@Observable
class UVNotificationManager {
    static let shared = UVNotificationManager()
    
    var authorizationStatus: UNAuthorizationStatus = .notDetermined
    
    private let center = UNUserNotificationCenter.current()
    
    // Notification identifiers
    private let morningBriefingIdentifier = "morning-uv-briefing"
    private let eveningBriefingIdentifier = "evening-uv-briefing"
    private let dailyForecastIdentifier = "daily-uv-forecast" // Deprecated
    private let uvThresholdIdentifierPrefix = "uv-threshold-" // Deprecated
    
    private init() {
        checkAuthorizationStatus()
    }
    
    // MARK: - Authorization
    
    func requestAuthorization() async -> Bool {
        do {
            let granted = try await center.requestAuthorization(options: [.alert, .sound, .badge])
            await MainActor.run {
                authorizationStatus = granted ? .authorized : .denied
            }
            return granted
        } catch {
            print("Notification authorization error: \(error)")
            return false
        }
    }
    
    func checkAuthorizationStatus() {
        center.getNotificationSettings { settings in
            Task { @MainActor in
                self.authorizationStatus = settings.authorizationStatus
            }
        }
    }
    
    // MARK: - Schedule Smart UV Briefings
    
    /// Schedules morning briefing if today's UV exceeds threshold
    /// - Parameters:
    ///   - time: Time to send the morning briefing
    ///   - todayForecast: Today's hourly UV data
    ///   - threshold: UV threshold to trigger notification
    func scheduleMorningBriefing(at time: Date, todayForecast: [(time: String, uv: Double)], threshold: Double) {
        // Remove existing morning briefing
        center.removePendingNotificationRequests(withIdentifiers: [morningBriefingIdentifier])
        
        guard !todayForecast.isEmpty else { return }
        
        // Calculate today's peak UV
        let peakUV = todayForecast.map { $0.uv }.max() ?? 0.0
        
        // Only schedule if peak UV exceeds threshold
        guard peakUV >= threshold else {
            print("⏭️ Morning briefing skipped: Today's peak UV (\(String(format: "%.1f", peakUV))) below threshold (\(String(format: "%.0f", threshold)))")
            return
        }
        
        let uvLevel = getUVLevel(for: peakUV)
        
        // Find peak time range
        let peakTimeRange = findPeakTimeRange(forecast: todayForecast, peakUV: peakUV)
        
        // Create notification content
        let content = UNMutableNotificationContent()
        content.title = "☀️ Today's UV Briefing"
        content.body = "Today: peak UV \(String(format: "%.0f", peakUV)) (\(uvLevel.description)) \(peakTimeRange). \(getProtectionAdvice(for: uvLevel))"
        content.sound = .default
        content.badge = 1
        
        content.userInfo = [
            "type": "morning-briefing",
            "peakUV": peakUV,
            "threshold": threshold
        ]
        
        // Schedule for specified time daily in user's local time zone
        var components = Calendar.current.dateComponents([.hour, .minute], from: time)
        components.timeZone = TimeZone.current
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: morningBriefingIdentifier, content: content, trigger: trigger)
        
        center.add(request) { error in
            if let error = error {
                print("Error scheduling morning briefing: \(error)")
            } else {
                print("✅ Morning briefing scheduled for \(components.hour ?? 0):\(String(format: "%02d", components.minute ?? 0)) \(TimeZone.current.identifier)")
            }
        }
    }
    
    /// Schedules evening briefing if tomorrow's UV exceeds threshold
    /// - Parameters:
    ///   - time: Time to send the evening briefing
    ///   - tomorrowForecast: Tomorrow's hourly UV data
    ///   - threshold: UV threshold to trigger notification
    func scheduleEveningBriefing(at time: Date, tomorrowForecast: [(time: String, uv: Double)], threshold: Double) {
        // Remove existing evening briefing
        center.removePendingNotificationRequests(withIdentifiers: [eveningBriefingIdentifier])
        
        guard !tomorrowForecast.isEmpty else { return }
        
        // Calculate tomorrow's peak UV
        let peakUV = tomorrowForecast.map { $0.uv }.max() ?? 0.0
        
        // Only schedule if peak UV exceeds threshold
        guard peakUV >= threshold else {
            print("⏭️ Evening briefing skipped: Tomorrow's peak UV (\(String(format: "%.1f", peakUV))) below threshold (\(String(format: "%.0f", threshold)))")
            return
        }
        
        let uvLevel = getUVLevel(for: peakUV)
        
        // Find peak time range
        let peakTimeRange = findPeakTimeRange(forecast: tomorrowForecast, peakUV: peakUV)
        
        // Create notification content
        let content = UNMutableNotificationContent()
        content.title = "🌙 Tomorrow's UV Briefing"
        content.body = "Tomorrow: peak UV \(String(format: "%.0f", peakUV)) (\(uvLevel.description)) \(peakTimeRange). \(getProtectionAdvice(for: uvLevel))"
        content.sound = .default
        content.badge = 1
        
        content.userInfo = [
            "type": "evening-briefing",
            "peakUV": peakUV,
            "threshold": threshold
        ]
        
        // Schedule for specified time daily in user's local time zone
        var components = Calendar.current.dateComponents([.hour, .minute], from: time)
        components.timeZone = TimeZone.current
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: eveningBriefingIdentifier, content: content, trigger: trigger)
        
        center.add(request) { error in
            if let error = error {
                print("Error scheduling evening briefing: \(error)")
            } else {
                print("✅ Evening briefing scheduled for \(components.hour ?? 0):\(String(format: "%02d", components.minute ?? 0)) \(TimeZone.current.identifier)")
            }
        }
    }
    
    private func findPeakTimeRange(forecast: [(time: String, uv: Double)], peakUV: Double) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        
        let timeFormatter = DateFormatter.timeFormatter()
        
        // Find all hours within 90% of peak UV
        let peakHours = forecast.filter { $0.uv >= peakUV * 0.9 }
        
        guard !peakHours.isEmpty,
              let firstTime = dateFormatter.date(from: peakHours.first?.time ?? ""),
              let lastTime = dateFormatter.date(from: peakHours.last?.time ?? "") else {
            return ""
        }
        
        let startTime = timeFormatter.string(from: firstTime)
        let endTime = timeFormatter.string(from: lastTime.addingTimeInterval(60 * 60)) // Add 1 hour
        
        return "\(startTime)–\(endTime)"
    }
    
    private func getProtectionAdvice(for level: UVLevel) -> String {
        switch level {
        case .low:
            return "Minimal protection needed."
        case .moderate:
            return "Wear sunglasses on bright days."
        case .high:
            return "Hat & SPF 30+ recommended."
        case .veryHigh:
            return "Hat & SPF 50 recommended."
        case .extreme:
            return "Avoid sun exposure. SPF 50+ essential."
        }
    }
    
    // MARK: - Schedule Daily Forecast Summary (Deprecated)
    
    /// Schedules a daily morning notification with UV forecast summary
    /// - Parameters:
    ///   - hour: Hour of the day (0-23) to send notification (default: 7 AM)
    ///   - hourlyForecast: Array of hourly UV data
    func scheduleDailyForecastNotification(at hour: Int = 7, hourlyForecast: [(time: String, uv: Double)]) {
        // Remove existing daily forecast notification
        center.removePendingNotificationRequests(withIdentifiers: [dailyForecastIdentifier])
        
        guard !hourlyForecast.isEmpty else { return }
        
        // Calculate peak UV for the day
        let peakUV = hourlyForecast.map { $0.uv }.max() ?? 0.0
        let uvLevel = getUVLevel(for: peakUV)
        
        // Create notification content
        let content = UNMutableNotificationContent()
        content.title = "Today's UV Forecast ☀️"
        content.body = generateForecastMessage(peakUV: peakUV, uvLevel: uvLevel, hourlyForecast: hourlyForecast)
        content.sound = .default
        content.badge = 1
        
        // Add custom data
        content.userInfo = [
            "type": "daily-forecast",
            "peakUV": peakUV
        ]
        
        // Schedule for specified hour daily in user's local time zone
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = 0
        dateComponents.timeZone = TimeZone.current
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: dailyForecastIdentifier, content: content, trigger: trigger)
        
        center.add(request) { error in
            if let error = error {
                print("Error scheduling daily forecast: \(error)")
            } else {
                print("✅ Daily forecast scheduled for \(hour):00 \(TimeZone.current.identifier)")
            }
        }
    }
    
    // MARK: - Schedule UV Threshold Notifications
    
    /// Schedules notifications for hours when UV exceeds the threshold
    /// - Parameters:
    ///   - threshold: UV index threshold (e.g., 6.0 for high UV)
    ///   - hourlyForecast: Array of hourly UV data with time strings
    ///   - timezone: Timezone identifier from API
    func scheduleUVThresholdNotifications(threshold: Double, hourlyForecast: [(time: String, uv: Double)], timezone: String) {
        // Remove existing threshold notifications
        removeThresholdNotifications()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        dateFormatter.timeZone = TimeZone(identifier: timezone)
        
        let now = Date()
        var scheduledCount = 0
        
        for (index, forecast) in hourlyForecast.enumerated() {
            guard let forecastDate = dateFormatter.date(from: forecast.time),
                  forecast.uv >= threshold,
                  forecastDate > now else {
                continue
            }
            
            // Schedule notification 15 minutes before the high UV hour
            let notificationDate = forecastDate.addingTimeInterval(-15 * 60)
            
            // Only schedule if notification time is in the future
            guard notificationDate > now else { continue }
            
            let content = UNMutableNotificationContent()
            content.title = "⚠️ High UV Alert"
            content.body = generateThresholdMessage(uv: forecast.uv, time: forecastDate, threshold: threshold)
            content.sound = .defaultCritical
            content.badge = 1
            
            content.userInfo = [
                "type": "uv-threshold",
                "uvIndex": forecast.uv,
                "threshold": threshold,
                "time": forecast.time
            ]
            
            // Create trigger
            let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: notificationDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
            
            let identifier = "\(uvThresholdIdentifierPrefix)\(index)"
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            
            center.add(request) { error in
                if let error = error {
                    print("Error scheduling threshold notification: \(error)")
                } else {
                    scheduledCount += 1
                    print("✅ Scheduled UV alert for \(dateFormatter.string(from: forecastDate))")
                }
            }
        }
        
        print("📅 Scheduled \(scheduledCount) UV threshold notifications")
    }
    
    // MARK: - Remove Notifications
    
    func removeMorningBriefing() {
        center.removePendingNotificationRequests(withIdentifiers: [morningBriefingIdentifier])
        print("🗑️ Removed morning briefing")
    }
    
    func removeEveningBriefing() {
        center.removePendingNotificationRequests(withIdentifiers: [eveningBriefingIdentifier])
        print("🗑️ Removed evening briefing")
    }
    
    func removeThresholdNotifications() {
        center.getPendingNotificationRequests { requests in
            let thresholdIdentifiers = requests
                .filter { $0.identifier.hasPrefix(self.uvThresholdIdentifierPrefix) }
                .map { $0.identifier }
            
            self.center.removePendingNotificationRequests(withIdentifiers: thresholdIdentifiers)
            print("🗑️ Removed \(thresholdIdentifiers.count) threshold notifications")
        }
    }
    
    func removeDailyForecastNotification() {
        center.removePendingNotificationRequests(withIdentifiers: [dailyForecastIdentifier])
    }
    
    func removeAllNotifications() {
        center.removeAllPendingNotificationRequests()
        center.removeAllDeliveredNotifications()
        print("🗑️ Removed all notifications")
    }
    
    // MARK: - Helper Methods
    
    private func getUVLevel(for uv: Double) -> UVLevel {
        switch uv {
        case 0..<3: return .low
        case 3..<6: return .moderate
        case 6..<8: return .high
        case 8..<11: return .veryHigh
        default: return .extreme
        }
    }
    
    private func generateForecastMessage(peakUV: Double, uvLevel: UVLevel, hourlyForecast: [(time: String, uv: Double)]) -> String {
        let uvDescription = uvLevel.description
        
        // Find peak hours
        let peakHours = hourlyForecast.filter { $0.uv >= peakUV * 0.9 }
        
        var message = "Peak UV Index: \(String(format: "%.1f", peakUV)) (\(uvDescription))"
        
        // Add recommendation
        switch uvLevel {
        case .low:
            message += "\nMinimal protection needed today."
        case .moderate:
            message += "\nStay in shade during midday hours."
        case .high:
            message += "\n⚠️ Protection essential! Wear sunscreen and avoid midday sun."
        case .veryHigh:
            message += "\n🚨 Extra protection required! Minimize sun exposure."
        case .extreme:
            message += "\n🚨 EXTREME! Avoid sun exposure between 10 AM - 4 PM."
        }
        
        return message
    }
    
    private func generateThresholdMessage(uv: Double, time: Date, threshold: Double) -> String {
        let timeFormatter = DateFormatter.timeFormatter()
        timeFormatter.timeZone = .current
        
        let timeString = timeFormatter.string(from: time)
        let uvLevel = getUVLevel(for: uv)
        
        var message = "UV Index will reach \(String(format: "%.1f", uv)) (\(uvLevel.description)) at \(timeString)."
        
        // Add protective advice
        switch uvLevel {
        case .high:
            message += "\n☀️ Use SPF 30+ sunscreen and wear protective clothing."
        case .veryHigh:
            message += "\n⚠️ Seek shade. Wear SPF 50+, hat, and sunglasses."
        case .extreme:
            message += "\n🚨 Stay indoors if possible. Full protection required outside."
        default:
            message += "\n☀️ Take protective measures."
        }
        
        return message
    }
    
    // MARK: - Debug
    
    func getPendingNotifications() async -> [UNNotificationRequest] {
        return await center.pendingNotificationRequests()
    }
    
    func printPendingNotifications() {
        center.getPendingNotificationRequests { requests in
            print("📬 Pending Notifications: \(requests.count)")
            for request in requests {
                print("  - \(request.identifier): \(request.content.title)")
                if let trigger = request.trigger as? UNCalendarNotificationTrigger,
                   let nextDate = trigger.nextTriggerDate() {
                    print("    Scheduled for: \(nextDate)")
                }
            }
        }
    }
}

// MARK: - UVLevel Extension

//extension UVLevel {
//    var description: String {
//        switch self {
//        case .low: return "Low"
//        case .moderate: return "Moderate"
//        case .high: return "High"
//        case .veryHigh: return "Very High"
//        case .extreme: return "Extreme"
//        }
//    }
//}
