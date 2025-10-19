//
//  WatchConnectivityManager.swift
//  UVGuard
//
//  Created by Swan Htet Aung on 19/10/25.
//

import Foundation
import WatchConnectivity

class WatchConnectivityManager: NSObject, ObservableObject {
    static let shared = WatchConnectivityManager()
    
    private override init() {
        super.init()
        
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
    // MARK: - Send UV Data to Watch
    func sendUVData(uv: Double, location: (city: String, country: String)) {
        guard WCSession.default.isReachable else {
            // Use application context for background sync
            sendDataViaApplicationContext(uv: uv, location: location)
            return
        }
        
        // Send immediately if watch is reachable
        let message: [String: Any] = [
            "currentUV": uv,
            "city": location.city,
            "country": location.country,
            "timestamp": Date().timeIntervalSince1970
        ]
        
        WCSession.default.sendMessage(message, replyHandler: nil) { error in
            print("Error sending message to watch: \(error.localizedDescription)")
            // Fallback to application context
            self.sendDataViaApplicationContext(uv: uv, location: location)
        }
    }
    
    // MARK: - Send Hourly Forecast
    func sendHourlyForecast(_ forecast: [(hour: String, uv: Double)]) {
        guard WCSession.default.activationState == .activated else { return }
        
        let forecastData = forecast.map { ["hour": $0.hour, "uv": $0.uv] }
        
        let context: [String: Any] = [
            "hourlyForecast": forecastData,
            "timestamp": Date().timeIntervalSince1970
        ]
        
        do {
            try WCSession.default.updateApplicationContext(context)
            print("📱 Sent hourly forecast to Watch")
        } catch {
            print("Error sending forecast: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Private Helper
    private func sendDataViaApplicationContext(uv: Double, location: (city: String, country: String)) {
        let context: [String: Any] = [
            "currentUV": uv,
            "city": location.city,
            "country": location.country,
            "timestamp": Date().timeIntervalSince1970
        ]
        
        do {
            try WCSession.default.updateApplicationContext(context)
            print("📱 Sent UV data to Watch via ApplicationContext")
        } catch {
            print("Error updating application context: \(error.localizedDescription)")
        }
    }
}

// MARK: - WCSessionDelegate
extension WatchConnectivityManager: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("📱 WCSession activation failed: \(error.localizedDescription)")
        } else {
            print("📱 WCSession activated with state: \(activationState.rawValue)")
            print("📱 Is reachable: \(session.isReachable)")
            
            // Send current data to Watch on activation
            if activationState == .activated {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.sendCurrentDataToWatch()
                }
            }
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("📱 WCSession became inactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("📱 WCSession deactivated")
        // Reactivate session
        WCSession.default.activate()
    }
    
    // Receive messages from Watch
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("📱 Received message from Watch: \(message)")
        
        // Handle refresh request from Watch
        if let refresh = message["refresh"] as? Bool, refresh {
            print("📱 Watch requested refresh - sending current data...")
            
            // Send current data from SharedDataManager immediately
            DispatchQueue.main.async {
                self.sendCurrentDataToWatch()
            }
            
            // Also notify app to refresh data
            NotificationCenter.default.post(name: NSNotification.Name("RefreshUVData"), object: nil)
        }
    }
    
    // MARK: - Send Current Data
    private func sendCurrentDataToWatch() {
        let sharedData = SharedDataManager.shared
        
        // Send UV data if available
        if let uv = sharedData.getCurrentUV() {
            let location = sharedData.getLocation()
            let city = location.city ?? "Unknown"
            let country = location.country ?? ""
            
            sendUVData(uv: uv, location: (city, country))
            print("📱 Sent current UV: \(uv) to Watch")
        } else {
            print("📱 No UV data available to send")
        }
    }
}
