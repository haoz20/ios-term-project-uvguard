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
    
    private let storageKey = "savedCities"
    
    init() {
        loadCities()
    }
    
    func loadCities() {
        isLoading = true
        errorMessage = nil
        
        // Load cities from UserDefaults
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([CityModel].self, from: data) {
            cities = decoded
        } else {
            cities = []
        }
        
        isLoading = false
    }
    
    func refresh() {
        loadCities()
    }
}
