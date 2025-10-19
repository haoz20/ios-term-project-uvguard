//
//  UVEntry.swift
//  UVGuardWidgets
//
//  Created by Swan Htet Aung on 18/10/25.
//

import WidgetKit
import SwiftUI

// MARK: - Timeline Entry
struct UVEntry: TimelineEntry {
    let date: Date
    let currentUV: Double
    let hourlyForecast: [(hour: String, uv: Double)]
}
