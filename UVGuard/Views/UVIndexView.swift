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
            // Warm background gradient
            LinearGradient.uvBackground
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    // Header - Use CityHeaderView
                    if let location = locationDataManager.locationManager.location {
                        CityHeaderView(location: location)
                    }
                    
                    // Content
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
                .padding()
            }
        }
        .onAppear(perform: setupLocationAndFetchData)
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
            viewModel.errorMessage = "Unable to get current location. Please ensure location services are enabled."
            return
        }
        
        // Reverse geocode to get city name
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let placemark = placemarks?.first {
                let city = placemark.locality ?? "Unknown"
                let country = placemark.country ?? ""
                SharedDataManager.shared.saveLocation(city: city, country: country)
            }
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
                .foregroundColor(.uvDanger)
            
            Text(message)
                .font(.headline)
                .multilineTextAlignment(.center)
                .foregroundColor(.uvSecondaryText)
            
            Button("Retry") {
                fetchUVData()
            }
            .buttonStyle(UVDangerButtonStyle())
        }
        .padding(40)
        .modifier(UVCardModifier())
    }
    
    @ViewBuilder
    private func waitingForLocationView() -> some View {
        VStack(spacing: 16) {
            ProgressView()
                .tint(.uvAccent)
            Text("Waiting for location...")
                .font(.headline)
                .foregroundColor(.uvSecondaryText)
        }
        .padding(40)
        .modifier(UVCardModifier())
    }
}

#Preview {
    UVIndexView()
}
