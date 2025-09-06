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
                UVIndexView()
            }
            
            Tab("Forecast", systemImage: "chart.xyaxis.line") {
                Text("Forecast Page")
            }
            
            Tab("Cities", systemImage: "map") {
                CitiesView()
            }
            
            Tab("Settings", systemImage: "gearshape") {
                SettingsView()
            }
        }
        .tint(.orange)
    }
}

#Preview {
    RootTabView()
}
