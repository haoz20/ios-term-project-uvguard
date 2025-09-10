//
//  UVIndexView.swift
//  UVGuard
//
//  Created by Swan Htet Aung on 1/9/25.
//

import SwiftUI
import CoreLocation

struct UVIndexView: View {
    @StateObject private var locationDataManager = LocationDataManager()
    @State private var viewModel = UVIndexViewModel()
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground).ignoresSafeArea()
            VStack {
                if let location = locationDataManager.locationManager.location {
                    CityHeaderView(location: location)
                }
                ScrollView {
                    VStack(spacing: 24) {
                        Group {
                            if viewModel.isLoading {
                                ProgressView("Fetching UV data...")
                                    .font(.headline)
                                    .frame(height: 300)
                            } else if let uv = viewModel.currentUV {
                                UVComponent(uvData: uv)
                            } else if let errorMessage = viewModel.errorMessage {
                                errorView(message: errorMessage)
                            } else {
                                waitingForLocationView()
                            }
                        }
                    }
                    .padding(.top, 20)
                }
            }
            .padding(.horizontal)
            .onAppear(perform: setupLocationAndFetchData)
            .onChange(of: locationDataManager.authorizationStatus) { _, status in
                if status == .authorizedWhenInUse {
                    fetchUVData()
                }
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
            viewModel.errorMessage = "Unable to get current location. Please ensure location services are enabled."
            return
        }
        
        viewModel.fetchUVData(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude
        )
    }
    
    @ViewBuilder
    private func errorView(message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 50))
                .foregroundColor(.orange)
            
            Text(message)
                .font(.headline)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            
            Button("Retry") {
                fetchUVData()
            }
            .buttonStyle(.borderedProminent)
            .tint(.orange)
        }
        .padding(40)
        .background(.regularMaterial)
        .cornerRadius(20)
    }
    
    @ViewBuilder
    private func waitingForLocationView() -> some View {
        VStack(spacing: 16) {
            ProgressView()
            Text("Waiting for location...")
                .font(.headline)
                .foregroundColor(.secondary)
        }
        .padding(40)
        .background(.regularMaterial)
        .cornerRadius(20)
    }
}

#Preview {
    UVIndexView()
}
