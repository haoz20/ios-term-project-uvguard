//
//  CityModel.swift
//  UVGuard
//
//  Created by Swan Htet Aung on 4/9/25.
//

import Foundation

struct Results: Codable {
    var results: [CityModel]
}



struct CityModel: Identifiable, Codable {
    let id: Int
    let name: String
    let latitude: Double
    let longitude: Double
    let timeZone: String
    let country: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, latitude, longitude, country
        case timeZone = "timezone"
    }
}
