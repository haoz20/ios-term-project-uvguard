//
//  RootTabView.swift
//  UVGuard
//
//  Created by Swan Htet Aung on 26/8/25.
//

import SwiftUI

struct RootTabView: View {
    
    init() {
        #if os(iOS)
        // Configure tab bar appearance with custom font (iOS only)
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        // Set custom font for tab bar items
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.montserratMedium(10)
        ]
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.montserratSemiBold(10)
        ]
        
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = attributes
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = selectedAttributes
        appearance.inlineLayoutAppearance.normal.titleTextAttributes = attributes
        appearance.inlineLayoutAppearance.selected.titleTextAttributes = selectedAttributes
        appearance.compactInlineLayoutAppearance.normal.titleTextAttributes = attributes
        appearance.compactInlineLayoutAppearance.selected.titleTextAttributes = selectedAttributes
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        #endif
    }
    
    var body: some View {
        TabView {
            Tab("UV Index", systemImage: "sun.max.fill") {
                UVIndexView()
            }
            
            Tab("Forecast", systemImage: "chart.xyaxis.line") {
                ForecastView()
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
