//
//  UVGuardWidgetsBundle.swift
//  UVGuardWidgets
//
//  Created by Swan Htet Aung on 18/10/25.
//

import WidgetKit
import SwiftUI

@main
struct UVGuardWidgetsBundle: WidgetBundle {
    var body: some Widget {
        CurrentUVWidget()
        ForecastWidget()
    }
}
