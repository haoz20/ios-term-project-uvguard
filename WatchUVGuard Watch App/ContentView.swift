//
//  ContentView.swift
//  WatchUVGuard Watch App
//
//  Created by Swan Htet Aung on 19/10/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            // Current UV Index Tab
            CurrentUVIndexView()
                .tabItem {
                    Label("UV Index", systemImage: "sun.max.fill")
                }
            
            // Cities List Tab
            CitiesListView()
                .tabItem {
                    Label("Cities", systemImage: "building.2.fill")
                }
        }
    }
}

#Preview {
    ContentView()
}
