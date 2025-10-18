//
//  ForecastViewModel.swift
//  UVGuard
//
//  Forecast ViewModel for 24-hour and 7-day UV forecasts
//

import Foundation
import Alamofire

struct HourlyUVForecast: Identifiable {
    let id = UUID()
    let date: Date
    let uv: Double
    let hour: String
}

struct DailyUVForecast: Identifiable {
    let id = UUID()
    let date: Date
    let maxUV: Double
    let minUV: Double
    let dayName: String
    let dateString: String
}

@Observable
class ForecastViewModel {
    var isLoading = false
    var errorMessage: String?
    var timezone: String = "UTC"
    
    var hourlyForecasts: [HourlyUVForecast] = []
    var dailyForecasts: [DailyUVForecast] = []
    
    private let apiBaseURL = "https://api.open-meteo.com/v1/forecast"
    
    func fetchForecast(latitude: Double, longitude: Double) {
        isLoading = true
        errorMessage = nil
        
        let parameters: [String: Any] = [
            "latitude": latitude,
            "longitude": longitude,
            "hourly": "uv_index",
            "daily": "uv_index_max",
            "timezone": "auto",
            "forecast_days": 7
        ]
        
        AF.request(apiBaseURL, parameters: parameters)
            .validate(statusCode: 200..<300)
            .response { [weak self] response in
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
                            let forecastResponse = try decoder.decode(ForecastResponse.self, from: data)
                            self.processForecast(forecastResponse)
                        } catch {
                            self.errorMessage = "Failed to parse data: \(error.localizedDescription)"
                        }
                        
                    case .failure(let error):
                        self.errorMessage = error.localizedDescription
                    }
                }
            }
    }
    
    private func processForecast(_ response: ForecastResponse) {
        self.timezone = response.timezone
        
        let timeZone = TimeZone(identifier: response.timezone) ?? .current
        
        // Process hourly forecast (24 hours)
        processHourlyForecast(response.hourly, timeZone: timeZone)
        
        // Process daily forecast (7 days)
        processDailyForecast(response.daily, timeZone: timeZone)
    }
    
    private func processHourlyForecast(_ hourly: HourlyForecastData, timeZone: TimeZone) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        dateFormatter.timeZone = timeZone
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h a"
        timeFormatter.timeZone = timeZone
        
        let now = Date()
        
        // Get all forecasts and filter to show only future hours (next 24 hours from now)
        let allForecasts = zip(hourly.time, hourly.uvIndex)
            .compactMap { timeString, uv -> HourlyUVForecast? in
                guard let date = dateFormatter.date(from: timeString) else { return nil }
                let hour = timeFormatter.string(from: date)
                return HourlyUVForecast(date: date, uv: uv, hour: hour)
            }
        
        // Filter to get only forecasts from now onwards, then take next 24 hours
        hourlyForecasts = allForecasts
            .filter { $0.date >= now }
            .prefix(24)
            .map { $0 }
    }
    
    private func processDailyForecast(_ daily: DailyForecastData, timeZone: TimeZone) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = timeZone
        
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "EEE"
        dayFormatter.timeZone = timeZone
        
        let displayDateFormatter = DateFormatter()
        displayDateFormatter.dateFormat = "MMM d"
        displayDateFormatter.timeZone = timeZone
        
        dailyForecasts = zip(daily.time, daily.uvIndexMax)
            .compactMap { timeString, maxUV in
                guard let date = dateFormatter.date(from: timeString) else { return nil }
                let dayName = dayFormatter.string(from: date)
                let dateString = displayDateFormatter.string(from: date)
                
                // For min UV, we'll use 0 or a reasonable estimate (API doesn't provide min)
                return DailyUVForecast(
                    date: date,
                    maxUV: maxUV,
                    minUV: 0,
                    dayName: dayName,
                    dateString: dateString
                )
            }
    }
}

// MARK: - API Response Models

struct ForecastResponse: Codable {
    let timezone: String
    let hourly: HourlyForecastData
    let daily: DailyForecastData
}

struct HourlyForecastData: Codable {
    let time: [String]
    let uvIndex: [Double]
    
    enum CodingKeys: String, CodingKey {
        case time
        case uvIndex = "uv_index"
    }
}

struct DailyForecastData: Codable {
    let time: [String]
    let uvIndexMax: [Double]
    
    enum CodingKeys: String, CodingKey {
        case time
        case uvIndexMax = "uv_index_max"
    }
}
