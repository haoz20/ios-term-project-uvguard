//
//  ContentView.swift
//  UVGuard
//
//  Created by Swan Htet Aung on 21/8/25.
//

import SwiftUI

struct ContentView: View {
    @State private var settingsManager = SettingsManager.shared
    
    var body: some View {
        RootTabView()
            .preferredColorScheme(colorScheme)
    }
    
    private var colorScheme: ColorScheme? {
        switch settingsManager.appearance {
        case .system:
            return nil
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}

#Preview {
    ContentView()
}
