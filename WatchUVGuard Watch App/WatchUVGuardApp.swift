//
//  WatchUVGuardApp.swift
//  WatchUVGuard Watch App
//
//  Created by Swan Htet Aung on 19/10/25.
//

import SwiftUI

@main
struct WatchUVGuard_Watch_AppApp: App {
    init() {
        // Initialize WatchConnectivity
        _ = WatchConnectivityManager.shared
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
