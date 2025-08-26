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
            Tab("UV", systemImage: "sun.max.fill") {
                
            }
            
            Tab("Forecast", systemImage: "chart.xyaxis.line") {
                
            }
            
            Tab("Locations", systemImage: "map") {
                
            }
            
            Tab("Settings", systemImage: "gearshape") {
                Text("Setting Page")
            }
            
        }
        
    }
}

#Preview {
    RootTabView()
}
