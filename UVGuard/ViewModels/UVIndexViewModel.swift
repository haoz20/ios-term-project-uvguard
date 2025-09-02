//
//  UVIndexViewModel.swift
//  UVGuard
//
//  Created by Swan Htet Aung on 1/9/25.
//

import Foundation

@Observable
class UVIndexViewModel {
    var currentUV: Double?
    var currentTimeRange: String?
    var errorMessage: String?

    init() {
        loadMockData()
    }
    
    func loadMockData() {
        guard let url = Bundle.main.url(forResource: "mock", withExtension: "json") else {
            errorMessage = "Failed to find mock.json"
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let uvResponse = try decoder.decode(UVResponse.self, from: data)
            
            findCurrentUV(from: uvResponse)
            
        } catch {
            errorMessage = "Failed to load or parse mock.json: \(error.localizedDescription)"
        }
    }
    
    private func findCurrentUV(from response: UVResponse) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"

        let now = Date()
        
        
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
                self.currentTimeRange = "\(timeFormat.string(from: date)) - \(timeFormat.string(from: nextDate))"
                return
            } else {
                print("❌ No match: \(now) is NOT between \(date) and \(nextDate)")
            }
        }
        
        print("No exact time match found. Using first available data for demo.")
        
        // Fallback: Use the first available data point if no exact time match
        if !response.hourly.time.isEmpty && !response.hourly.uvIndex.isEmpty {
            if let firstDate = dateFormatter.date(from: response.hourly.time[0]) {
                self.currentUV = response.hourly.uvIndex[0]
                let secondDate = response.hourly.time.count > 1 ? 
                    (dateFormatter.date(from: response.hourly.time[1]) ?? firstDate.addingTimeInterval(3600)) :
                    firstDate.addingTimeInterval(3600)
                
                let timeFormat = DateFormatter()
                timeFormat.dateFormat = "h a"
                self.currentTimeRange = "\(timeFormat.string(from: firstDate)) - \(timeFormat.string(from: secondDate))"
                return
            }
        }
        
        errorMessage = "Could not find current UV index for the current time."
    }
    
}
