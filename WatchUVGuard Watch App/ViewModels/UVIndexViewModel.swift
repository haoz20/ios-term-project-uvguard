//
//  UVIndexViewModel.swift
//  WatchUVGuard Watch App
//
//  Created by Swan Htet Aung on 19/10/25.
//

import Foundation
import Observation

@Observable
class UVIndexViewModel {
    var currentUV: Double? = nil
    var location: String = "Unknown Location"
    var isLoading: Bool = false
    var errorMessage: String? = nil
    
    init() {
        // Listen for WatchConnectivity updates
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name("WatchDataUpdated"),
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.loadData()
        }
    }
    
    func loadData() {
        isLoading = true
        errorMessage = nil
        
        // Use a small delay to ensure UI updates smoothly
        Task { @MainActor in
            // First try WatchConnectivity data
            let connectivity = WatchConnectivityManager.shared
            
            if let uv = connectivity.currentUV {
                self.currentUV = uv
            } else {
                // Fallback to SharedDataManager
                self.currentUV = SharedDataManager.shared.getCurrentUV()
            }
            
            if let connectivityLocation = connectivity.location {
                self.location = connectivityLocation.city
                self.errorMessage = nil
            } else {
                // Fallback to SharedDataManager
                let locationData = SharedDataManager.shared.getLocation()
                if let city = locationData.city {
                    self.location = city
                    self.errorMessage = nil
                } else {
                    self.location = "Unknown Location"
                    self.errorMessage = "No data available. Please open the iPhone app first."
                }
            }
            
            self.isLoading = false
        }
    }
    
    func refresh() {
        // Request fresh data from iPhone
        WatchConnectivityManager.shared.requestDataFromiPhone()
        
        // Also reload local data
        loadData()
    }
}

