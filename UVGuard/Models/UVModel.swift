//
//  UVModel.swift
//  UVGuard
//
//  Created by Swan Htet Aung on 27/8/25.
//

import Foundation

struct UVResponse: Codable {
    let latitude: Double
    let longitude: Double
    let generationtimeMs: Double
    let utcOffsetSeconds: Int
    let timezone: String
    let timezoneAbbreviation: String
    let elevation: Double
    let hourlyUnits: HourlyUnits
    let hourly: HourlyData
    
    enum CodingKeys: String, CodingKey {
        case latitude, longitude
        case generationtimeMs = "generationtime_ms"
        case utcOffsetSeconds = "utc_offset_seconds"
        case timezone
        case timezoneAbbreviation = "timezone_abbreviation"
        case elevation
        case hourlyUnits = "hourly_units"
        case hourly
    }
}

struct HourlyUnits: Codable {
    let time: String
    let uvIndex: String

    enum CodingKeys: String, CodingKey {
        case time
        case uvIndex = "uv_index"
    }
}

struct HourlyData: Codable {
    let time: [String]
    let uvIndex: [Double]

    enum CodingKeys: String, CodingKey {
        case time
        case uvIndex = "uv_index"
    }
}



