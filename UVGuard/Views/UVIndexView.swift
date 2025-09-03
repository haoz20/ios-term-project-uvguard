
//
//  UVIndexView.swift
//  UVGuard
//
//  Created by Swan Htet Aung on 1/9/25.
//

import SwiftUI

struct UVIndexView: View {
    @StateObject private var locationDataManager = LocationDataManager()
    @State private var viewModel = UVIndexViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            if viewModel.isLoading {
                ProgressView("Fetching UV data...")
                    .font(.headline)
            } else if let uv = viewModel.currentUV, let timeRange = viewModel.currentTimeRange {
                Text("Current UV Index")
                    .font(.title)
                
                Text(String(uv))
                    .font(.system(size: 80, weight: .bold))
                    .foregroundColor(uvColor(for: uv))
                
                Text("Time: \(timeRange)")
                    .font(.headline)
                
                if let location = locationDataManager.locationManager.location {
                    Text("Location: \(String(format: "%.4f", location.coordinate.latitude)), \(String(format: "%.4f", location.coordinate.longitude))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
            } else if let errorMessage = viewModel.errorMessage {
                VStack(spacing: 10) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.largeTitle)
                        .foregroundColor(.orange)
                    
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    Button("Retry") {
                        fetchUVData()
                    }
                    .buttonStyle(.borderedProminent)
                }
            } else {
                Text("Waiting for location...")
                    .font(.headline)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .onAppear {
            setupLocationAndFetchData()
        }
        .onChange(of: locationDataManager.authorizationStatus) { _, status in
            if status == .authorizedWhenInUse {
                fetchUVData()
            }
        }
    }
    
    private func setupLocationAndFetchData() {
        if locationDataManager.authorizationStatus == .authorizedWhenInUse {
            fetchUVData()
        } else {
            locationDataManager.locationManager.requestWhenInUseAuthorization()
        }
    }
    
    private func fetchUVData() {
        guard let location = locationDataManager.locationManager.location else {
            viewModel.errorMessage = "Unable to get current location"
            return
        }
        
        viewModel.fetchUVData(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude
        )
    }
    
    private func uvColor(for uvIndex: Int) -> Color {
        switch uvIndex {
        case 0...2:
            return .green
        case 3...5:
            return .yellow
        case 6...7:
            return .orange
        case 8...10:
            return .red
        default:
            return .purple
        }
    }
}

#Preview {
    UVIndexView()
}
