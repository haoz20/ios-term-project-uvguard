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
    
    func loadData() {
        isLoading = true
        errorMessage = nil
        
        // Use a small delay to ensure UI updates smoothly
        Task { @MainActor in
            let sharedData = SharedDataManager.shared
            
            self.currentUV = sharedData.getCurrentUV()
            let locationData = sharedData.getLocation()
            
            if let city = locationData.city {
                self.location = city
                self.errorMessage = nil
            } else {
                self.location = "Unknown Location"
                self.errorMessage = "No data available. Please open the iPhone app first."
            }
            
            self.isLoading = false
        }
    }
    
    func refresh() {
        loadData()
    }
}

