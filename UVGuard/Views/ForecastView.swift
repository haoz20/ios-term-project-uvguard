//
//  ForecastView.swift
//  UVGuard
//
//  Created by Swan Htet Aung on 4/9/25.
//

import SwiftUI

struct ForecastView: View {
    @StateObject private var locationDataManager = LocationDataManager()
    @State private var viewModel = UVIndexViewModel()
    
    var body: some View {
        ZStack {
            // Warm background gradient
            LinearGradient.uvBackground
                .ignoresSafeArea()
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 24) {
                    // Header Section
                    headerSection
                    
                    if viewModel.isLoading {
                        loadingView
                    } else if !viewModel.hourlyForecast.isEmpty {
                        // 24-Hour Forecast Section
                        hourlyForecastSection
                        
                        // Statistics Section
                        statisticsSection
                        
                        // Recommendations Section
                        recommendationsSection
                        
                    } else if let errorMessage = viewModel.errorMessage {
                        errorView(message: errorMessage)
                    } else {
                        emptyStateView
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 100)
            }
        }
        .onAppear {
            setupLocationAndFetchData()
        }
        .onChange(of: locationDataManager.authorizationStatus) { _, status in
            if status == .authorizedWhenInUse {
                fetchUVData()
            }
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("UV Forecast")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .uvPrimaryText()
                    
                    if let location = locationDataManager.locationManager.location {
                        HStack {
                            Image(systemName: "location.fill")
                                .foregroundColor(.uvAccent)
                            Text(getCurrentLocationName())
                                .font(.subheadline)
                                .uvSecondaryText()
                        }
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text(Date().formatted(.dateTime.weekday(.wide)))
                        .font(.headline)
                        .fontWeight(.semibold)
                        .uvPrimaryText()
                    
                    Text(Date().formatted(.dateTime.month().day().year()))
                        .font(.subheadline)
                        .uvSecondaryText()
                }
            }
        }
        .padding(.top, 20)
    }
    
    // MARK: - Loading View
    private var loadingView: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
                .tint(.uvAccent)
            
            Text("Loading UV forecast...")
                .font(.headline)
                .uvSecondaryText()
        }
        .frame(height: 200)
        .frame(maxWidth: .infinity)
        .modifier(UVCardModifier())
    }
    
    // MARK: - Hourly Forecast Section
    private var hourlyForecastSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("24-Hour Forecast")
                    .font(.title2)
                    .fontWeight(.bold)
                    .uvPrimaryText()
                
                Spacer()
                
                Text("\(viewModel.hourlyForecast.count) hours")
                    .font(.caption)
                    .uvSecondaryText()
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.uvCardBackground.opacity(0.5))
                    .cornerRadius(12)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(Array(viewModel.hourlyForecast.enumerated()), id: \.offset) { index, forecast in
                        if let date = parseDate(from: forecast.time) {
                            HourlyComponent(date: date, uvIndex: forecast.uv)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            }
        }
        .padding()
        .modifier(UVCardModifier())
    }
    
    // MARK: - Statistics Section
    private var statisticsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Today's Overview")
                .font(.title2)
                .fontWeight(.bold)
                .uvPrimaryText()
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                statisticCard(
                    title: "Peak UV",
                    value: String(format: "%.1f", getMaxUV()),
                    icon: "sun.max.fill",
                    color: getColorForUV(getMaxUV())
                )
                
                statisticCard(
                    title: "UV Hours",
                    value: "\(getUVHours())",
                    icon: "clock.fill",
                    color: .uvAccent
                )
                
                statisticCard(
                    title: "Safe Hours",
                    value: "\(getSafeHours())",
                    icon: "shield.fill",
                    color: .green
                )
                
                statisticCard(
                    title: "Danger Hours",
                    value: "\(getDangerHours())",
                    icon: "exclamationmark.triangle.fill",
                    color: .uvDanger
                )
            }
        }
        .padding()
        .modifier(UVCardModifier())
    }
    
    // MARK: - Recommendations Section
    private var recommendationsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recommendations")
                .font(.title2)
                .fontWeight(.bold)
                .uvPrimaryText()
            
            VStack(spacing: 12) {
                ForEach(getRecommendations(), id: \.0) { recommendation in
                    recommendationRow(
                        icon: recommendation.0,
                        title: recommendation.1,
                        description: recommendation.2,
                        color: recommendation.3
                    )
                }
            }
        }
        .padding()
        .modifier(UVCardModifier())
    }
    
    // MARK: - Helper Views
    private func statisticCard(title: String, value: String, icon: String, color: Color) -> some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.title3)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)
                    .uvPrimaryText()
                
                Text(title)
                    .font(.caption)
                    .uvSecondaryText()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(Color.uvCardBackground.opacity(0.5))
        .cornerRadius(12)
    }
    
    private func recommendationRow(icon: String, title: String, description: String, color: Color) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.title3)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .uvPrimaryText()
                
                Text(description)
                    .font(.caption)
                    .uvSecondaryText()
            }
            
            Spacer()
        }
        .padding()
        .background(Color.uvCardBackground.opacity(0.5))
        .cornerRadius(12)
    }
    
    private func errorView(message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 50))
                .foregroundColor(.uvDanger)
            
            Text(message)
                .font(.headline)
                .multilineTextAlignment(.center)
                .uvSecondaryText()
            
            Button("Retry") {
                fetchUVData()
            }
            .buttonStyle(UVDangerButtonStyle())
        }
        .padding(40)
        .modifier(UVCardModifier())
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "sun.max")
                .font(.system(size: 50))
                .foregroundColor(.uvAccent)
            
            Text("No forecast data available")
                .font(.headline)
                .uvPrimaryText()
            
            Text("Pull to refresh or check your location settings")
                .font(.subheadline)
                .uvSecondaryText()
                .multilineTextAlignment(.center)
        }
        .padding(40)
        .modifier(UVCardModifier())
    }
    
    // MARK: - Helper Functions
    private func parseDate(from timeString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        return dateFormatter.date(from: timeString)
    }
    
    private func getCurrentLocationName() -> String {
        // This would need to be implemented with reverse geocoding
        return "Current Location"
    }
    
    private func getMaxUV() -> Double {
        return viewModel.hourlyForecast.map { $0.uv }.max() ?? 0.0
    }
    
    private func getUVHours() -> Int {
        return viewModel.hourlyForecast.filter { $0.uv > 0.5 }.count
    }
    
    private func getSafeHours() -> Int {
        return viewModel.hourlyForecast.filter { $0.uv < 3.0 }.count
    }
    
    private func getDangerHours() -> Int {
        return viewModel.hourlyForecast.filter { $0.uv >= 8.0 }.count
    }
    
    private func getColorForUV(_ uv: Double) -> Color {
        switch uv {
        case 0..<3: return .green
        case 3..<6: return .yellow
        case 6..<8: return .orange
        case 8..<11: return .red
        default: return .purple
        }
    }
    
    private func getRecommendations() -> [(String, String, String, Color)] {
        let maxUV = getMaxUV()
        var recommendations: [(String, String, String, Color)] = []
        
        if maxUV >= 8 {
            recommendations.append(("sun.max.fill", "Avoid Sun Exposure", "UV levels are extreme today. Stay indoors during peak hours.", .red))
        } else if maxUV >= 6 {
            recommendations.append(("sunglasses.fill", "Use Protection", "Wear sunscreen, hat, and sunglasses.", .orange))
        } else if maxUV >= 3 {
            recommendations.append(("sun.haze.fill", "Moderate Protection", "Some protection recommended during midday.", .yellow))
        } else {
            recommendations.append(("checkmark.circle.fill", "Minimal Risk", "Low UV levels today. Minimal protection needed.", .green))
        }
        
        recommendations.append(("drop.fill", "Stay Hydrated", "Drink plenty of water, especially outdoors.", .blue))
        recommendations.append(("timer", "Check Regularly", "UV levels change throughout the day.", .purple))
        
        return recommendations
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
}

#Preview {
    ForecastView()
}
