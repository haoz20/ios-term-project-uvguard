//
//  ContentView.swift
//  UVGuard
//
//  Created by Swan Htet Aung on 21/8/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var locationDataManager = LocationDataManager()
    var body: some View {
        VStack {
//            Text("Latitude: \(locationDataManager.locationManager.location?.coordinate.latitude.description ?? "Error loading")")
//            Text("Longitude: \(locationDataManager.locationManager.location?.coordinate.longitude.description ?? "Error loading")")
            RootTabView()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
