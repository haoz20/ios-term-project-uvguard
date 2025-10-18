//
//  UVGuardWidgets.swift
//  UVGuardWidgets
//
//  Created by Swan Htet Aung on 18/10/25.
//
//  Main widget file - organizes and exposes the widget bundle.
//  Individual widget components are in separate files:
//  - WidgetAssets.swift: Colors and styling
//  - UVEntry.swift: Data models (UVEntry, UVLevel)
//  - UVProvider.swift: Timeline provider and data fetching
//  - CurrentUVWidgetView.swift: Small widget for current UV
//  - ForecastWidgetView.swift: Medium widget for UV forecast
//

import WidgetKit
import SwiftUI

// The widget bundle is already defined in UVGuardWidgetsBundle.swift
// This file can be used for shared utilities or kept minimal