//
//  UVIndexViewModel.swift
//  UVGuard
//
//  Created by Swan Htet Aung on 1/9/25.
//

import Foundation
import Alamofire

@Observable
class UVIndexViewModel {
    var currentUV: Double?
    var currentTimeRange: String?
    var errorMessage: String?
    var isLoading: Bool = false
    
    var hourlyForecast: [(time: String, uv: Double)] = []
    var timezone: String = "UTC"
    
    private let apiBaseURL = "https://api.open-meteo.com/v1/forecast"
    private let notificationManager = UVNotificationManager.shared
    private let notificationSettings = NotificationSettings.shared

    init() {
        // Don't load mock data automatically - wait for API call
    }
    
    func fetchUVData(latitude: Double, longitude: Double) {
        isLoading = true
        errorMessage = nil
        
        let parameters: [String: Any] = [
            "latitude": latitude,
            "longitude": longitude,
            "hourly": "uv_index",
            "timezone": "auto", // This will use the location's timezone
            "forecast_hours": 24
        ]
        
        AF.request(apiBaseURL, parameters: parameters)
            .validate(statusCode: 200..<300).response { [weak self] response in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    
                    switch response.result {
                    case .success(let data):
                        guard let data = data else {
                            self.errorMessage = "No data received"
                            return
                        }
                        
                        do {
                            let decoder = JSONDecoder()
                            let uv = try decoder.decode(UVResponse.self, from: data)
                            self.processUVResponse(uv)
                        } catch {
                            self.errorMessage = "Failed to parse data: \(error.localizedDescription)"
                        }
                        
                    case .failure(let error):
                        self.errorMessage = error.localizedDescription
                    }
                }
            }
    }
    
    private func processUVResponse(_ response: UVResponse) {
        // Store timezone
        self.timezone = response.timezone
        
        // Populate hourly forecast data
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        dateFormatter.timeZone = TimeZone(identifier: response.timezone) ?? TimeZone(identifier: "Asia/Bangkok")
        
        hourlyForecast = zip(response.hourly.time, response.hourly.uvIndex).compactMap { (timeString, uvIndex) in
            guard let date = dateFormatter.date(from: timeString) else { return nil }
            return (time: timeString, uv: uvIndex)
        }
        
        findCurrentUV(from: response)
        
        // Schedule notifications if enabled
        scheduleNotificationsIfNeeded()
    }
    
    // MARK: - Notification Scheduling
    
    private func scheduleNotificationsIfNeeded() {
        // Check if any notifications are enabled
        let hasNotificationsEnabled = notificationSettings.dailyForecastEnabled || 
                                      notificationSettings.thresholdNotificationsEnabled
        
        guard hasNotificationsEnabled else { return }
        
        // Schedule daily forecast notification
        if notificationSettings.dailyForecastEnabled {
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: notificationSettings.dailyForecastTime)
            notificationManager.scheduleDailyForecastNotification(at: hour, hourlyForecast: hourlyForecast)
        }
        
        // Schedule threshold notifications
        if notificationSettings.thresholdNotificationsEnabled {
            notificationManager.scheduleUVThresholdNotifications(
                threshold: Double(notificationSettings.uvThreshold), // Convert Int to Double
                hourlyForecast: hourlyForecast,
                timezone: timezone
            )
        }
    }
    
    private func findCurrentUV(from response: UVResponse) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        // Use the timezone from the API response for dynamic location support
        dateFormatter.timeZone = TimeZone(identifier: response.timezone) ?? TimeZone(identifier: "Asia/Bangkok")

        let now = Date()
        print("Current time: \(dateFormatter.string(from: now))")
        print("API timezone: \(response.timezone)")
        
        for (index, timeString) in response.hourly.time.enumerated() {
            print("Trying to parse: \(timeString)")
            
            guard let date = dateFormatter.date(from: timeString) else {
                print("Failed to parse: \(timeString)")
                continue
            }
            
            print("Successfully parsed: \(timeString) -> \(date)")
            let nextDate: Date
            if index + 1 < response.hourly.time.count, 
               let nextDateValue = dateFormatter.date(from: response.hourly.time[index + 1]) {
                nextDate = nextDateValue
            } else {
                // For the last entry, assume it's valid for one hour
                nextDate = date.addingTimeInterval(3600)
            }

            if now >= date && now < nextDate {
                print("✅ Found match! Current time \(now) is between \(date) and \(nextDate)")
                self.currentUV = response.hourly.uvIndex[index]
                let timeFormat = DateFormatter()
                timeFormat.dateFormat = "h a"
                timeFormat.timeZone = dateFormatter.timeZone
                self.currentTimeRange = "\(timeFormat.string(from: date)) - \(timeFormat.string(from: nextDate))"
                return
            } else {
                print("❌ No match: \(now) is NOT between \(date) and \(nextDate)")
            }
        }
        
        errorMessage = "Could not find current UV index for the current time."
    }
}