//
//  UVHelpers.swift
//  WatchUVGuard Watch App
//
//  Created by Swan Htet Aung on 19/10/25.
//

import Foundation

//func getUVLevel(for uvIndex: Double) -> UVLevel {
//    switch uvIndex {
//    case 0..<3:
//        return .low
//    case 3..<6:
//        return .moderate
//    case 6..<8:
//        return .high
//    case 8..<11:
//        return .veryHigh
//    default:
//        return .extreme
//    }
//}

func timeAgo(from date: Date) -> String {
    let now = Date()
    let components = Calendar.current.dateComponents([.minute, .hour, .day], from: date, to: now)
    
    if let day = components.day, day > 0 {
        return day == 1 ? "1 day ago" : "\(day) days ago"
    }
    
    if let hour = components.hour, hour > 0 {
        return hour == 1 ? "1 hour ago" : "\(hour) hours ago"
    }
    
    if let minute = components.minute, minute > 0 {
        return minute == 1 ? "1 minute ago" : "\(minute) minutes ago"
    }
    
    return "Just now"
}
