//
//  UVProvider.swift
//  UVGuardWidgets
//
//  Created by Swan Htet Aung on 18/10/25.
//

import WidgetKit
import Foundation

// MARK: - Timeline Provider
struct UVProvider: TimelineProvider {
    func placeholder(in context: Context) -> UVEntry {
        UVEntry(
            date: Date(),
            currentUV: 5.5,
            hourlyForecast: [
                ("12PM", 5.5),
                ("1PM", 6.2),
                ("2PM", 7.1),
                ("3PM", 6.8)
            ]
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (UVEntry) -> ()) {
        let entry = UVEntry(
            date: Date(),
            currentUV: 5.5,
            hourlyForecast: [
                ("12PM", 5.5),
                ("1PM", 6.2),
                ("2PM", 7.1),
                ("3PM", 6.8)
            ]
        )
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<UVEntry>) -> ()) {
        Task {
            // In production, fetch real UV data from API
            let currentDate = Date()
            let entry = await fetchUVData(for: currentDate)
            
            // Update every hour
            let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate)!
            let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
            completion(timeline)
        }
    }
    
    // MARK: - Data Fetching
    private func fetchUVData(for date: Date) async -> UVEntry {
        // TODO: Implement actual API call to fetch UV data
        // For now, return mock data
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        
        // Simulate UV pattern throughout the day
        let baseUV = calculateUVForHour(hour)
        var forecast: [(String, Double)] = []
        
        for offset in 0..<4 {
            let futureHour = (hour + offset) % 24
            let futureUV = calculateUVForHour(futureHour)
            let hourString = formatHour(futureHour)
            forecast.append((hourString, futureUV))
        }
        
        return UVEntry(date: date, currentUV: baseUV, hourlyForecast: forecast)
    }
    
    // MARK: - Helper Methods
    private func calculateUVForHour(_ hour: Int) -> Double {
        // Simulate UV levels throughout the day (peaks at noon)
        switch hour {
        case 6..<9: return Double.random(in: 1.0...3.0)
        case 9..<12: return Double.random(in: 3.0...6.0)
        case 12..<15: return Double.random(in: 6.0...9.0) // Peak
        case 15..<18: return Double.random(in: 4.0...7.0)
        case 18..<20: return Double.random(in: 1.0...3.0)
        default: return 0.0
        }
    }
    
    private func formatHour(_ hour: Int) -> String {
        let period = hour < 12 ? "AM" : "PM"
        let displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour)
        return "\(displayHour)\(period)"
    }
}
