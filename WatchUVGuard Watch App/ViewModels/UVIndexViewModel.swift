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
        isLoading = true
        errorMessage = nil
        
        // Load from SharedDataManager
        let uv = SharedDataManager.shared.getCurrentUV()
        currentUV = uv
        
        let locationData = SharedDataManager.shared.getLocation()
        let city = locationData.city
        let country = locationData.country
        
        if !city.isEmpty {
            if !country.isEmpty {
                location = "\(city), \(country)"
            } else {
                location = city
            }
        } else {
            location = "Unknown Location"
        }
        
        isLoading = false
    }
    
    func refresh() {
        loadData()
    }
}

