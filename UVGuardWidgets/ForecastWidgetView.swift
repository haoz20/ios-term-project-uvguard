//
//  ForecastWidgetView.swift
//  UVGuardWidgets
//
//  Created by Swan Htet Aung on 18/10/25.
//

import WidgetKit
import SwiftUI

// MARK: - Forecast Widget View (Medium)
struct ForecastWidgetView: View {
    var entry: UVEntry
    
    private var maxForecastUV: Double {
        entry.hourlyForecast.map { $0.uv }.max() ?? 10.0
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            // Header
            HStack {
                Image(systemName: "sun.max.fill")
                    .foregroundColor(.uvAccent)
                    .font(.caption)
                Text("UV Forecast")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.uvPrimaryText)
                Spacer()
                Text(entry.date, style: .time)
                    .font(.caption2)
                    .foregroundColor(.uvSecondaryText)
            }
            
            // Current UV
            HStack(alignment: .bottom, spacing: 6) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Now")
                        .font(.caption2)
                        .foregroundColor(.uvSecondaryText)
                    Text("\(Int(entry.currentUV.rounded()))")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(getUVLevel(for: entry.currentUV).color)
                }
                
                Text(getUVLevel(for: entry.currentUV).description)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.uvPrimaryText)
                    .padding(.bottom, 2)
                
                Spacer()
            }
            
            Divider()
                .background(Color.uvSecondaryText.opacity(0.3))
            
            // Hourly forecast chart
            HStack(alignment: .bottom, spacing: 12) {
                ForEach(entry.hourlyForecast, id: \.hour) { forecast in
                    VStack(spacing: 2) {
                        // UV bar
                        let maxBarHeight: CGFloat = 40
                        let barHeight = (forecast.uv / max(maxForecastUV, 1)) * maxBarHeight
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(getUVLevel(for: forecast.uv).color)
                            .frame(width: 28, height: max(barHeight, 8))
                        
                        // UV value
                        Text("\(Int(forecast.uv.rounded()))")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(.uvPrimaryText)
                        
                        // Hour
                        Text(forecast.hour)
                            .font(.system(size: 9))
                            .foregroundColor(.uvSecondaryText)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(14)
    }
}

// MARK: - Widget Configuration
struct ForecastWidget: Widget {
    let kind: String = "ForecastWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: UVProvider()) { entry in
            if #available(iOS 17.0, *) {
                ForecastWidgetView(entry: entry)
                    .containerBackground(for: .widget) {
                        LinearGradient(
                            colors: [Color.uvSoftYellow, Color.uvLightCream],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    }
            } else {
                ForecastWidgetView(entry: entry)
                    .background(
                        LinearGradient(
                            colors: [Color.uvSoftYellow, Color.uvLightCream],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
        }
        .configurationDisplayName("UV Forecast")
        .description("Shows hourly UV forecast")
        .supportedFamilies([.systemMedium])
    }
}

// MARK: - Preview
#Preview(as: .systemMedium) {
    ForecastWidget()
} timeline: {
    UVEntry(
        date: .now,
        currentUV: 7,
        hourlyForecast: [
            ("12PM", 7),
            ("1PM", 7),
            ("2PM", 8),
            ("3PM", 8)
        ]
    )
}
