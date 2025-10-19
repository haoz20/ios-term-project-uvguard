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
        // Load real data for snapshot
        let entry = loadWidgetData()
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<UVEntry>) -> ()) {
        // Load data from SharedDataManager
        let currentDate = Date()
        let entry = loadWidgetData()
        
        // Update every 30 minutes
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 30, to: currentDate)!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }
    
    // MARK: - Load Data from App
    private func loadWidgetData() -> UVEntry {
        let sharedData = SharedDataManager.shared
        
        let currentUV = sharedData.getCurrentUV()
        let forecast = sharedData.getHourlyForecast()
        let lastUpdate = sharedData.getLastUpdate()
        
        return UVEntry(
            date: lastUpdate,
            currentUV: currentUV,
            hourlyForecast: forecast
        )
    }
    
    // MARK: - Fallback Mock Data (if needed)
    private func fetchUVData(for date: Date) async -> UVEntry {
        // Fallback to mock data if SharedDataManager has no data
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
