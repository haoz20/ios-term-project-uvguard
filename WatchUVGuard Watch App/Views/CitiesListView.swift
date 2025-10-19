//
//  CitiesListView.swift
//  WatchUVGuard Watch App
//
//  Created by Swan Htet Aung on 19/10/25.
//

import SwiftUI

struct CitiesListView: View {
    @State private var viewModel = CitiesViewModel()
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                } else if viewModel.cities.isEmpty {
                    emptyStateView
                } else {
                    List(viewModel.cities) { city in
                        NavigationLink(destination: CityDetailView(city: city)) {
                            CityRowView(city: city)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Cities")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.loadCities()
            }
            .refreshable {
                viewModel.refresh()
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 12) {
            Image(systemName: "building.2")
                .font(.title2)
                .foregroundColor(.uvAccent.opacity(0.6))
            
            Text("No Cities")
                .font(.headline)
                .foregroundColor(.uvPrimaryText)
            
            Text("Add cities in the iOS app")
                .font(.caption2)
                .foregroundColor(.uvSecondaryText)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

// MARK: - City Row View
struct CityRowView: View {
    let city: CityModel
    @State private var currentUV: Double = 0.0
    
    var uvLevel: UVLevel {
        getUVLevel(for: currentUV)
    }
    
    var body: some View {
        HStack(spacing: 10) {
            // UV Badge
            ZStack {
                Circle()
                    .fill(uvLevel.color.opacity(0.2))
                    .frame(width: 36, height: 36)
                
                Text("\(Int(currentUV.rounded()))")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(uvLevel.color)
            }
            
            // City Info
            VStack(alignment: .leading, spacing: 2) {
                Text(city.name)
                    .font(.headline)
                    .foregroundColor(.uvPrimaryText)
                    .lineLimit(1)
                
                if let country = city.country {
                    Text(country)
                        .font(.caption2)
                        .foregroundColor(.uvSecondaryText)
                        .lineLimit(1)
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 2)
        .onAppear {
            // Load UV for this city (stored separately)
            loadCityUV()
        }
    }
    
    private func loadCityUV() {
        // Try to load from UserDefaults using city id
        let key = "city_uv_\(city.id)"
        currentUV = UserDefaults.standard.double(forKey: key)
    }
}

// MARK: - City Detail View
struct CityDetailView: View {
    let city: CityModel
    @State private var currentUV: Double = 0.0
    
    var uvLevel: UVLevel {
        getUVLevel(for: currentUV)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                // City Header
                VStack(spacing: 4) {
                    Text(city.name)
                        .font(.headline)
                        .foregroundColor(.uvPrimaryText)
                    
                    if let country = city.country, !country.isEmpty {
                        Text(country)
                            .font(.caption)
                            .foregroundColor(.uvSecondaryText)
                    }
                }
                .padding(.top, 8)
                
                // UV Display
                VStack(spacing: 8) {
                    // UV Circle
                    ZStack {
                        Circle()
                            .fill(uvLevel.color.opacity(0.2))
                            .frame(width: 90, height: 90)
                        
                        Circle()
                            .stroke(uvLevel.color, lineWidth: 3)
                            .frame(width: 90, height: 90)
                        
                        VStack(spacing: 0) {
                            Text("\(Int(currentUV.rounded()))")
                                .font(.system(size: 36, weight: .bold))
                                .foregroundColor(uvLevel.color)
                            
                            Text("UV")
                                .font(.caption2)
                                .foregroundColor(.uvSecondaryText)
                        }
                    }
                    
                    // Level Description
                    Text(uvLevel.description)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.uvPrimaryText)
                }
                .padding(.vertical, 8)
            }
            .padding(.horizontal, 12)
        }
        .navigationTitle(city.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            loadCityUV()
        }
    }
    
    private func loadCityUV() {
        let key = "city_uv_\(city.id)"
        currentUV = UserDefaults.standard.double(forKey: key)
    }
}

#Preview {
    NavigationStack {
        CitiesListView()
    }
}

#Preview("City Detail") {
    NavigationStack {
        CityDetailView(city: CityModel(
            id: 1,
            name: "New York",
            latitude: 40.7128,
            longitude: -74.0060,
            timeZone: "America/New_York",
            country: "United States"
        ))
    }
}
