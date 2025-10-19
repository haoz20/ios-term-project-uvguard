//
//  ForecastView.swift
//  UVGuard
//
//  Complete forecast view with 24-hour and 7-day forecasts
//

import SwiftUI
import CoreLocation
import Charts

struct ForecastView: View {
    let city: CityModel?
    let useCurrentLocation: Bool
    
    @StateObject private var locationDataManager = LocationDataManager()
    @State private var viewModel = ForecastViewModel()
    @Environment(\.dismiss) private var dismiss
    
    init(city: CityModel? = nil) {
        self.city = city
        self.useCurrentLocation = city == nil
    }
    
    var body: some View {
        ZStack {
            LinearGradient.uvBackground
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    // Header - Only show for current location
                    if useCurrentLocation, let location = locationDataManager.locationManager.location {
                        CityHeaderView(location: location)
                    }
                    
                    if viewModel.isLoading {
                        loadingView
                    } else if let error = viewModel.errorMessage {
                        errorView(message: error)
                    } else {
                        // 24-Hour Forecast Section
                        if !viewModel.hourlyForecasts.isEmpty {
                            hourlyForecastSection
                        }
                        
                        // 7-Day Forecast Section
                        if !viewModel.dailyForecasts.isEmpty {
                            dailyForecastSection
                        }
                    }
                }
                .padding()
                .padding(.bottom, 30)
            }
        }
        .navigationTitle(useCurrentLocation ? "UV Forecast" : (city?.name ?? "UV Forecast"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if !useCurrentLocation {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.uvSecondaryText)
                    }
                }
            }
        }
        .onAppear {
            fetchForecastData()
        }
        .onChange(of: locationDataManager.authorizationStatus) { _, status in
            if status == .authorizedWhenInUse && useCurrentLocation {
                fetchForecastData()
            }
        }
    }
    
    // MARK: - 24-Hour Forecast Section
    @State private var selectedHourIndex: Int = 0
    @State private var selectedHourDate: Date?
    
    private var selectedForecast: HourlyUVForecast {
        viewModel.hourlyForecasts[safe: selectedHourIndex] ?? viewModel.hourlyForecasts.first!
    }
    
    private var hourlyForecastSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack {
                Image(systemName: "clock.fill")
                    .foregroundColor(.uvAccent)
                    .font(.title3)
                
                Text("24-Hour Forecast")
                    .font(.title2)
                    .fontWeight(.bold)
                    .uvPrimaryText()
                
                Spacer()
                
                // Now indicator
                HStack(spacing: 4) {
                    Circle()
                        .fill(Color.uvAccent)
                        .frame(width: 8, height: 8)
                    Text("Now")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .uvPrimaryText()
                }
            }
            
            // SwiftUI Chart - without card
            if !viewModel.hourlyForecasts.isEmpty {
                VStack(spacing: 8) {
                    // Selected value display
                    if let selectedDate = selectedHourDate,
                       let selectedForecast = viewModel.hourlyForecasts.first(where: { Calendar.current.isDate($0.date, equalTo: selectedDate, toGranularity: .hour) }) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(selectedForecast.hour)
                                    .font(.caption)
                                    .uvSecondaryText()
                                HStack(spacing: 8) {
                                    Text("UV: \(Int(round(selectedForecast.uv)))")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .foregroundColor(getUVColor(selectedForecast.uv))
                                    Text(getUVDescription(selectedForecast.uv))
                                        .font(.subheadline)
                                        .uvSecondaryText()
                                }
                            }
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                    
                    Chart {
                        ForEach(Array(viewModel.hourlyForecasts.enumerated()), id: \.element.id) { index, forecast in
                            // Area gradient
                            AreaMark(
                                x: .value("Time", forecast.date),
                                y: .value("UV", forecast.uv)
                            )
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [
                                        Color.uvAccent.opacity(0.3),
                                        Color.uvAccent.opacity(0.1),
                                        Color.uvAccent.opacity(0.0)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            
                            // Line
                            LineMark(
                                x: .value("Time", forecast.date),
                                y: .value("UV", forecast.uv)
                            )
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color.uvAccent, Color.uvOrangeHighlight],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .lineStyle(StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                            
                            // Points with color based on UV level
                            PointMark(
                                x: .value("Time", forecast.date),
                                y: .value("UV", forecast.uv)
                            )
                            .foregroundStyle(getUVColor(forecast.uv))
                            .symbolSize(60)
                            
                            // "Now" rule mark for the first point
                            if index == 0 {
                                RuleMark(x: .value("Now", forecast.date))
                                    .foregroundStyle(Color.uvAccent)
                                    .lineStyle(StrokeStyle(lineWidth: 2, dash: [5, 3]))
                                    .annotation(position: .top, alignment: .center) {
                                        Text("NOW")
                                            .font(.caption2)
                                            .fontWeight(.bold)
                                            .foregroundColor(.uvAccent)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(Color.uvCardBackground)
                                            .cornerRadius(8)
                                    }
                            }
                        }
                        
                        // Selection indicator
                        if let selectedDate = selectedHourDate {
                            RuleMark(x: .value("Selection", selectedDate))
                                .foregroundStyle(Color.white.opacity(0.5))
                                .lineStyle(StrokeStyle(lineWidth: 2))
                                .annotation(position: .top, alignment: .center, spacing: 0) {
                                    ZStack {
                                        Circle()
                                            .fill(Color.white)
                                            .frame(width: 12, height: 12)
                                        Circle()
                                            .fill(Color.uvAccent)
                                            .frame(width: 8, height: 8)
                                    }
                                }
                        }
                    }
                    .chartXSelection(value: $selectedHourDate)
                    .chartXAxis {
                        AxisMarks(values: .stride(by: .hour, count: 3)) { value in
                            if let date = value.as(Date.self) {
                                AxisValueLabel {
                                    VStack(spacing: 2) {
                                        Text(date, format: .dateTime.hour())
                                            .font(.caption2)
                                            .uvSecondaryText()
                                    }
                                }
                                AxisGridLine()
                                    .foregroundStyle(Color.uvSecondaryText.opacity(0.2))
                            }
                        }
                    }
                    .chartYAxis {
                        AxisMarks(position: .leading) { value in
                            AxisValueLabel {
                                if let intValue = value.as(Int.self) {
                                    Text("\(intValue)")
                                        .font(.caption2)
                                        .uvSecondaryText()
                                }
                            }
                            AxisGridLine()
                                .foregroundStyle(Color.uvSecondaryText.opacity(0.1))
                        }
                    }
                    .chartYScale(domain: 0...11)
                    .frame(height: 200)
                    .padding()
                }
            }
            
            // Hourly items scroll - inside card
            VStack(alignment: .leading, spacing: 0) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(Array(viewModel.hourlyForecasts.enumerated()), id: \.element.id) { index, forecast in
                            HourlyForecastCard(forecast: forecast, isNow: index == 0)
                        }
                    }
                }
            }
            .padding()
            .modifier(UVCardModifier())
        }
    }
    
    // MARK: - 7-Day Forecast Section
    @State private var selectedDayDate: Date?
    
    private var dailyForecastSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                
                Text("7-Day Forecast")
                    .font(.title2)
                    .fontWeight(.bold)
                    .uvPrimaryText()
                
                Spacer()
            }
            
            // SwiftUI Chart - without card
            if !viewModel.dailyForecasts.isEmpty {
                VStack(spacing: 8) {
                    // Selected value display
                    if let selectedDate = selectedDayDate,
                       let selectedForecast = viewModel.dailyForecasts.first(where: { Calendar.current.isDate($0.date, equalTo: selectedDate, toGranularity: .day) }) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(selectedForecast.dayName)
                                    .font(.caption)
                                    .uvSecondaryText()
                                HStack(spacing: 8) {
                                    Text("Max UV: \(Int(round(selectedForecast.maxUV)))")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .foregroundColor(getUVColor(selectedForecast.maxUV))
                                    Text(getUVDescription(selectedForecast.maxUV))
                                        .font(.subheadline)
                                        .uvSecondaryText()
                                }
                            }
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                    
                    Chart {
                        ForEach(viewModel.dailyForecasts) { forecast in
                            // Area gradient
                            AreaMark(
                                x: .value("Day", forecast.date),
                                y: .value("UV", forecast.maxUV)
                            )
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [
                                        Color.uvOrangeHighlight.opacity(0.3),
                                        Color.uvOrangeHighlight.opacity(0.1),
                                        Color.uvOrangeHighlight.opacity(0.0)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            
                            // Line
                            LineMark(
                                x: .value("Day", forecast.date),
                                y: .value("UV", forecast.maxUV)
                            )
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color.uvAccent, Color.uvOrangeHighlight],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .lineStyle(StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                            
                            // Points with color based on UV level
                            PointMark(
                                x: .value("Day", forecast.date),
                                y: .value("UV", forecast.maxUV)
                            )
                            .foregroundStyle(getUVColor(forecast.maxUV))
                            .symbolSize(60)
                        }
                        
                        // Selection indicator
                        if let selectedDate = selectedDayDate {
                            RuleMark(x: .value("Selection", selectedDate))
                                .foregroundStyle(Color.white.opacity(0.5))
                                .lineStyle(StrokeStyle(lineWidth: 2))
                                .annotation(position: .top, alignment: .center, spacing: 0) {
                                    ZStack {
                                        Circle()
                                            .fill(Color.white)
                                            .frame(width: 12, height: 12)
                                        Circle()
                                            .fill(Color.uvAccent)
                                            .frame(width: 8, height: 8)
                                    }
                                }
                        }
                    }
                    .chartXSelection(value: $selectedDayDate)
                    .chartXAxis {
                        AxisMarks(values: .automatic) { value in
                            if let date = value.as(Date.self) {
                                AxisValueLabel {
                                    VStack(spacing: 2) {
                                        Text(date, format: .dateTime.weekday(.abbreviated))
                                            .font(.caption)
                                            .fontWeight(.medium)
                                            .uvPrimaryText()
                                    }
                                }
                                AxisGridLine()
                                    .foregroundStyle(Color.uvSecondaryText.opacity(0.2))
                            }
                        }
                    }
                    .chartYAxis {
                        AxisMarks(position: .leading) { value in
                            AxisValueLabel {
                                if let intValue = value.as(Int.self) {
                                    Text("\(intValue)")
                                        .font(.caption2)
                                        .uvSecondaryText()
                                }
                            }
                            AxisGridLine()
                                .foregroundStyle(Color.uvSecondaryText.opacity(0.1))
                        }
                    }
                    .chartYScale(domain: 0...11)
                    .frame(height: 200)
                    .padding()
                }
            }
            
            // Daily items list - inside card with Grid layout
            Grid(alignment: .leading, horizontalSpacing: 16, verticalSpacing: 12) {
                // Header Row
                GridRow {
                    Text("Day")
                        .font(.uvCaption)
                        .fontWeight(.semibold)
                        .uvSecondaryText()
                        .gridColumnAlignment(.leading)
                    
                    Text("UV Index")
                        .font(.uvCaption)
                        .fontWeight(.semibold)
                        .uvSecondaryText()
                        .gridColumnAlignment(.center)
                    
                    Text("Max")
                        .font(.uvCaption)
                        .fontWeight(.semibold)
                        .uvSecondaryText()
                        .gridColumnAlignment(.trailing)
                }
                .padding(.bottom, 8)
                
                Divider()
                    .gridCellUnsizedAxes(.horizontal)
                    .background(Color.uvSecondaryText.opacity(0.3))
                
                // Data Rows
                ForEach(viewModel.dailyForecasts) { forecast in
                    DailyForecastRow(forecast: forecast)
                }
            }
            .padding()
            .modifier(UVCardModifier())
        }
    }
    
    // MARK: - Helper Methods
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
    
    // MARK: - Loading View
    private var loadingView: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
                .tint(.uvAccent)
            
            Text("Loading forecast...")
                .font(.headline)
                .uvSecondaryText()
        }
        .frame(height: 200)
        .frame(maxWidth: .infinity)
        .modifier(UVCardModifier())
    }
    
    // MARK: - Error View
    private func errorView(message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 50))
                .foregroundColor(.uvDanger)
            
            Text("Unable to load forecast")
                .font(.headline)
                .uvPrimaryText()
            
            Text(message)
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .uvSecondaryText()
            
            Button("Retry") {
                fetchForecastData()
            }
            .buttonStyle(UVPrimaryButtonStyle())
        }
        .padding(40)
        .modifier(UVCardModifier())
    }
    
    // MARK: - Data Fetching
    private func fetchForecastData() {
        if useCurrentLocation {
            if let location = locationDataManager.locationManager.location {
                viewModel.fetchForecast(
                    latitude: location.coordinate.latitude,
                    longitude: location.coordinate.longitude
                )
            } else if locationDataManager.authorizationStatus == .notDetermined {
                locationDataManager.locationManager.requestWhenInUseAuthorization()
            }
        } else if let city = city {
            viewModel.fetchForecast(
                latitude: city.latitude,
                longitude: city.longitude
            )
        }
    }
}

// MARK: - Hourly Forecast Card
struct HourlyForecastCard: View {
    let forecast: HourlyUVForecast
    let isNow: Bool
    
    var body: some View {
        VStack(spacing: 10) {
            // Show "Now" label for first item, otherwise show time
            if isNow {
                HStack(spacing: 4) {
                    Circle()
                        .fill(Color.uvAccent)
                        .frame(width: 6, height: 6)
                    Text("Now")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.uvAccent)
                }
            } else {
                Text(forecast.hour)
                    .font(.caption)
                    .fontWeight(.medium)
                    .uvSecondaryText()
            }
            
            ZStack {
                Circle()
                    .fill(uvColor.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                // Highlight "now" circle with a border
                if isNow {
                    Circle()
                        .stroke(Color.uvAccent, lineWidth: 2)
                        .frame(width: 50, height: 50)
                }
                
                Text("\(Int(round(forecast.uv)))")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(uvColor)
            }
            
            Text(uvDescription)
                .font(.caption2)
                .fontWeight(.medium)
                .uvSecondaryText()
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.uvCardBackground.opacity(isNow ? 0.8 : 0.5))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isNow ? Color.uvAccent.opacity(0.3) : Color.clear, lineWidth: 1)
                )
        )
    }
    
    private var uvColor: Color {
        switch forecast.uv {
        case 0..<3: return .green
        case 3..<6: return .uvAccent
        case 6..<8: return .uvOrangeHighlight
        case 8..<11: return .uvDanger
        default: return .purple
        }
    }
    
    private var uvDescription: String {
        switch forecast.uv {
        case 0..<3: return "Low"
        case 3..<6: return "Moderate"
        case 6..<8: return "High"
        case 8..<11: return "Very High"
        default: return "Extreme"
        }
    }
}

// MARK: - Daily Forecast Row
struct DailyForecastRow: View {
    let forecast: DailyUVForecast
    
    var body: some View {
        GridRow {
            // Day and Date Column
            VStack(alignment: .leading, spacing: 2) {
                Text(forecast.dayName)
                    .font(.uvHeadline)
                    .uvPrimaryText()
                
                Text(forecast.dateString)
                    .font(.uvCaption)
                    .uvSecondaryText()
            }
            .gridColumnAlignment(.leading)
            
            // UV Bar Indicator Column
            HStack(spacing: 3) {
                ForEach(0..<11, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(index < Int(round(forecast.maxUV)) ? uvColor : Color.uvSecondaryText.opacity(0.2))
                        .frame(width: 8, height: 20)
                }
            }
            .gridColumnAlignment(.center)
            
            // Max UV Value Column
            HStack(spacing: 6) {
                Image(systemName: "sun.max.fill")
                    .font(.uvCaption)
                    .foregroundColor(uvColor)
                
                Text("\(Int(round(forecast.maxUV)))")
                    .font(.uvTitle3)
                    .fontWeight(.bold)
                    .foregroundColor(uvColor)
                
                Text(uvDescription)
                    .font(.uvCaption2)
                    .uvSecondaryText()
            }
            .gridColumnAlignment(.trailing)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color.uvCardBackground.opacity(0.3))
        .cornerRadius(12)
    }
    
    private var uvColor: Color {
        switch forecast.maxUV {
        case 0..<3: return .green
        case 3..<6: return .uvAccent
        case 6..<8: return .uvOrangeHighlight
        case 8..<11: return .uvDanger
        default: return .purple
        }
    }
    
    private var uvDescription: String {
        switch forecast.maxUV {
        case 0..<3: return "Low"
        case 3..<6: return "Moderate"
        case 6..<8: return "High"
        case 8..<11: return "Very High"
        default: return "Extreme"
        }
    }
}

// MARK: - Collection Extension for Safe Indexing
extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

#Preview {
    NavigationStack {
        ForecastView()
    }
}
