//
//  CitiesViewModel.swift
//  WatchUVGuard Watch App
//
//  Created by Swan Htet Aung on 19/10/25.
//

import Foundation
import Observation

@Observable
class CitiesViewModel {
    var cities: [CityModel] = []
    var isLoading: Bool = false
    var errorMessage: String? = nil
    
    private let storageKey = "favorite-cities"  // Must match iOS app key
    
    init() {
        loadCities()
    }
    
    func loadCities() {
        isLoading = true
        errorMessage = nil
        
        // Load cities from App Groups shared UserDefaults
        let defaults = UserDefaults(suiteName: "group.com.swanhtetaung.uvguard") ?? .standard
        if let data = defaults.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([CityModel].self, from: data) {
            cities = decoded
        } else {
            cities = []
            errorMessage = "No cities found. Add cities in iPhone app."
        }
        
        isLoading = false
    }
    
    func refresh() {
        loadCities()
    }
}
