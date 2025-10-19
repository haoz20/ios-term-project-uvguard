//
//  WatchConnectivityManager.swift
//  WatchUVGuard Watch App
//
//  Created by Swan Htet Aung on 19/10/25.
//

import Foundation
import WatchConnectivity
import Observation

@Observable
class WatchConnectivityManager: NSObject {
    static let shared = WatchConnectivityManager()
    
    var currentUV: Double?
    var location: (city: String, country: String)?
    var hourlyForecast: [(hour: String, uv: Double)] = []
    var lastUpdateTime: Date?
    
    private override init() {
        super.init()
        
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
            print("⌚ WatchConnectivity initialized")
        }
    }
    
    // MARK: - Request Data from iPhone
    func requestDataFromiPhone() {
        guard WCSession.default.activationState == .activated else {
            print("⌚ WCSession not activated")
            return
        }
        
        guard WCSession.default.isReachable else {
            print("⌚ iPhone not reachable")
            return
        }
        
        let message = ["refresh": true] as [String : Any]
        print("⌚ Requesting data from iPhone...")
        
        WCSession.default.sendMessage(message, replyHandler: nil) { error in
            print("⌚ Error requesting data: \(error.localizedDescription)")
        }
    }
}

// MARK: - WCSessionDelegate
extension WatchConnectivityManager: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("⌚ WCSession activation failed: \(error.localizedDescription)")
        } else {
            print("⌚ WCSession activated with state: \(activationState.rawValue)")
            print("⌚ Is reachable: \(session.isReachable)")
        }
    }
    
    // Receive immediate messages from iPhone
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("⌚ Received message: \(message)")
        
        DispatchQueue.main.async {
            if let uv = message["currentUV"] as? Double {
                self.currentUV = uv
                SharedDataManager.shared.saveCurrentUV(uv)
                print("⌚ Received UV: \(uv)")
            }
            
            if let city = message["city"] as? String,
               let country = message["country"] as? String {
                self.location = (city, country)
                SharedDataManager.shared.saveLocation(city: city, country: country)
                print("⌚ Received location: \(city), \(country)")
            }
            
            self.lastUpdateTime = Date()
            
            // Notify views to refresh
            NotificationCenter.default.post(name: NSNotification.Name("WatchDataUpdated"), object: nil)
        }
    }
    
    // Receive application context from iPhone (background updates)
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        print("⌚ Received application context: \(applicationContext.keys)")
        
        DispatchQueue.main.async {
            // UV Data
            if let uv = applicationContext["currentUV"] as? Double {
                self.currentUV = uv
                SharedDataManager.shared.saveCurrentUV(uv)
                print("⌚ Context UV: \(uv)")
            }
            
            // Location
            if let city = applicationContext["city"] as? String,
               let country = applicationContext["country"] as? String {
                self.location = (city, country)
                SharedDataManager.shared.saveLocation(city: city, country: country)
                print("⌚ Context location: \(city), \(country)")
            }
            
            // Hourly Forecast
            if let forecastArray = applicationContext["hourlyForecast"] as? [[String: Any]] {
                var forecast: [(hour: String, uv: Double)] = []
                for item in forecastArray {
                    if let hour = item["hour"] as? String,
                       let uv = item["uv"] as? Double {
                        forecast.append((hour, uv))
                    }
                }
                self.hourlyForecast = forecast
                SharedDataManager.shared.saveHourlyForecast(forecast)
                print("⌚ Context forecast: \(forecast.count) hours")
            }
            
            self.lastUpdateTime = Date()
            
            // Notify views to refresh
            NotificationCenter.default.post(name: NSNotification.Name("WatchDataUpdated"), object: nil)
        }
    }
}
