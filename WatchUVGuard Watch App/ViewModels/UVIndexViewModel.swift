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
    var location: String = "Loading..."
    var isLoading: Bool = false
    var errorMessage: String? = nil
    
    init() {
        loadData()
    }
    
    func loadData() {
        let sharedData = SharedDataManager.shared
        
        self.currentUV = sharedData.getCurrentUV()
        let locationData = sharedData.getLocation()
        
        if let city = locationData.city {
            self.location = city
        } else {
            self.location = "Unknown Location"
            self.errorMessage = "No data available. Please open the iPhone app first."
        }
    }
    
    func refresh() {
        loadData()
    }
}

