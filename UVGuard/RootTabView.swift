//
//  RootTabView.swift
//  UVGuard
//
//  Created by Swan Htet Aung on 26/8/25.
//

import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            Tab("UV Index", systemImage: "sun.max.fill") {
//                UVIndexView()
            }
            
            Tab("Forecast", systemImage: "chart.xyaxis.line") {
                Text("Forecast Page")
            }
            
            Tab("Locations", systemImage: "map") {
                Text("Locations Page")
            }
            
            Tab("Settings", systemImage: "gearshape") {
//                SettingsView()
            }
        }
        .accentColor(.orange)
    }
}

#Preview {
    RootTabView()
}
