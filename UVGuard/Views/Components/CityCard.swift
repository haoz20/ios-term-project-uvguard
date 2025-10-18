//
//  CityCard.swift
//  UVGuard
//
//  City card component showing UV information
//

import SwiftUI

struct CityCard: View {
    let city: CityModel
    @State private var viewModel = UVIndexViewModel()
    @State private var currentTime: String = ""
    @State private var timer: Timer?
    @State private var animationProgress: CGFloat = 0
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with city name and UV
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(city.name)
                        .font(.title2)
                        .fontWeight(.bold)
                        .uvPrimaryText()
                    
                    HStack(spacing: 6) {
                        Image(systemName: "location.fill")
                            .font(.caption2)
                            .foregroundColor(.uvAccent)
                        
                        if let country = city.country {
                            Text(country)
                                .font(.caption)
                                .uvSecondaryText()
                        }
                    }
                }
                
                Spacer()
                
                // Large UV Display
                VStack(alignment: .trailing, spacing: 2) {
                    if let uv = viewModel.currentUV {
                        Text("\(Int(round(uv)))")
                            .font(.system(size: 56, weight: .thin, design: .rounded))
                            .foregroundColor(getUVColor(uv))
                            .scaleEffect(animationProgress)
                    } else if viewModel.isLoading {
                        ProgressView()
                            .scaleEffect(1.2)
                            .tint(.uvAccent)
                            .frame(width: 56, height: 56)
                    } else {
                        Text("--")
                            .font(.system(size: 56, weight: .thin, design: .rounded))
                            .uvSecondaryText()
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
            // Divider
            Divider()
                .background(Color.uvSecondaryText.opacity(0.2))
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
            
            // Bottom section with UV status and time
            HStack(alignment: .center) {
                // UV Status
                if let uv = viewModel.currentUV {
                    HStack(spacing: 10) {
                        Image(systemName: "sun.max.fill")
                            .foregroundColor(getUVColor(uv))
                            .font(.title3)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(getUVDescription(uv))
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .uvPrimaryText()
                            
                        }
                    }
                    .opacity(animationProgress)
                } else if let error = viewModel.errorMessage {
                    HStack(spacing: 8) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.uvDanger)
                            .font(.caption)
                        Text("Unable to load")
                            .font(.caption)
                            .uvSecondaryText()
                    }
                }
                
                Spacer()
                
                // Local time with clock icon
                HStack(spacing: 6) {
                    Image(systemName: "clock.fill")
                        .font(.caption)
                        .foregroundColor(.uvAccent)
                    
                    Text(currentTime)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .uvPrimaryText()
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .modifier(UVCardModifier())
        .onAppear {
            fetchCityUV()
            startTimeUpdates()
            
            // Entrance animation
            withAnimation(.easeOut(duration: 0.6)) {
                animationProgress = 1
            }
        }
        .onDisappear {
            timer?.invalidate()
        }
    }
    
    // MARK: - Helper Methods
    
    private func fetchCityUV() {
        viewModel.fetchUVData(latitude: city.latitude, longitude: city.longitude)
    }
    
    private func startTimeUpdates() {
        updateTime()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            updateTime()
        }
    }
    
    private func updateTime() {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        
        if let timezone = city.timeZone,
           let tz = TimeZone(identifier: timezone) {
            formatter.timeZone = tz
        } else {
            formatter.timeZone = TimeZone.current
        }
        
        currentTime = formatter.string(from: Date())
    }
    
    private func getUVColor(_ uv: Double) -> Color {
        switch uv {
        case 0..<3: return .green
        case 3..<6: return .uvAccent
        case 6..<8: return .uvOrangeHighlight
        case 8..<11: return .uvDanger
        default: return .purple
        }
    }
    
    private func getUVDescription(_ uv: Double) -> String {
        switch uv {
        case 0..<3: return "Low"
        case 3..<6: return "Moderate"
        case 6..<8: return "High"
        case 8..<11: return "Very High"
        default: return "Extreme"
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        CityCard(city: CityModel(
            id: 1,
            name: "Bangkok",
            latitude: 13.7563,
            longitude: 100.5018,
            timeZone: "Asia/Bangkok",
            country: "Thailand"
        ))
        
        CityCard(city: CityModel(
            id: 2,
            name: "New York",
            latitude: 40.7128,
            longitude: -74.0060,
            timeZone: "America/New_York",
            country: "United States"
        ))
    }
    .padding()
    .background(LinearGradient.uvBackground)
}
