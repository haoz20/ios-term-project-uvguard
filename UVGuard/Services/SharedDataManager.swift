//
//  SharedDataManager.swift
//  UVGuard
//
//  Shared data manager for app and widget communication
//

import Foundation

class SharedDataManager {
    static let shared = SharedDataManager()
    
    // Use the App Group ID you configured in Xcode
    private let appGroupID = "group.com.swanhtetaung.uvguard"
    
    private var userDefaults: UserDefaults? {
        UserDefaults(suiteName: appGroupID)
    }
    
    // MARK: - Keys
    private enum Keys {
        static let currentUV = "currentUV"
        static let hourlyForecast = "hourlyForecast"
        static let location = "location"
        static let lastUpdate = "lastUpdate"
        static let cityName = "cityName"
        static let countryName = "countryName"
    }
    
    // MARK: - Save Data
    func saveCurrentUV(_ uv: Double) {
        userDefaults?.set(uv, forKey: Keys.currentUV)
        userDefaults?.synchronize()
    }
    
    func saveHourlyForecast(_ forecast: [(hour: String, uv: Double)]) {
        let encoded = forecast.map { ["hour": $0.hour, "uv": $0.uv] }
        userDefaults?.set(encoded, forKey: Keys.hourlyForecast)
        userDefaults?.synchronize()
    }
    
    func saveLocation(city: String, country: String) {
        userDefaults?.set(city, forKey: Keys.cityName)
        userDefaults?.set(country, forKey: Keys.countryName)
        userDefaults?.synchronize()
    }
    
    func saveLastUpdate(_ date: Date) {
        userDefaults?.set(date, forKey: Keys.lastUpdate)
        userDefaults?.synchronize()
    }
    
    // MARK: - Load Data
    func getCurrentUV() -> Double? {
        guard let uv = userDefaults?.double(forKey: Keys.currentUV), uv > 0 else {
            return nil
        }
        return uv
    }
    
    func getHourlyForecast() -> [(hour: String, uv: Double)] {
        guard let encoded = userDefaults?.array(forKey: Keys.hourlyForecast) as? [[String: Any]] else {
            // Return default mock data if no data available
            return [
                ("12PM", 5.5),
                ("1PM", 6.2),
                ("2PM", 7.1),
                ("3PM", 6.8)
            ]
        }
        
        return encoded.compactMap { dict in
            guard let hour = dict["hour"] as? String,
                  let uv = dict["uv"] as? Double else { return nil }
            return (hour, uv)
        }
    }
    
    func getLocation() -> (city: String?, country: String?) {
        let city = userDefaults?.string(forKey: Keys.cityName)
        let country = userDefaults?.string(forKey: Keys.countryName)
        return (city, country)
    }
    
    func getLastUpdate() -> Date? {
        return userDefaults?.object(forKey: Keys.lastUpdate) as? Date
    }
    
    // MARK: - Clear Data
    func clearAllData() {
        userDefaults?.removeObject(forKey: Keys.currentUV)
        userDefaults?.removeObject(forKey: Keys.hourlyForecast)
        userDefaults?.removeObject(forKey: Keys.cityName)
        userDefaults?.removeObject(forKey: Keys.countryName)
        userDefaults?.removeObject(forKey: Keys.lastUpdate)
        userDefaults?.synchronize()
    }
}
