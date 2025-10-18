//
//  CurrentUVWidgetView.swift
//  UVGuardWidgets
//
//  Created by Swan Htet Aung on 18/10/25.
//

import WidgetKit
import SwiftUI

// MARK: - Current UV Widget View (Small)
struct CurrentUVWidgetView: View {
    var entry: UVEntry
    
    private var uvLevel: UVLevel {
        getUVLevel(for: entry.currentUV)
    }
    
    var body: some View {
        VStack(spacing: 4) {
            // Header
            HStack {
                Image(systemName: "sun.max.fill")
                    .foregroundColor(.uvAccent)
                    .font(.caption)
                Text("UV Index")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.uvPrimaryText)
            }
            
            Spacer()
            
            // UV Value with colored circle
            ZStack {
                Circle()
                    .fill(uvLevel.color.opacity(0.2))
                    .frame(width: 80, height: 80)
                
                Circle()
                    .stroke(uvLevel.color, lineWidth: 4)
                    .frame(width: 80, height: 80)
                
                Text("\(Int(entry.currentUV.rounded()))")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(uvLevel.color)
            }
            
            Spacer()
            
            // Level description
            Text(uvLevel.description)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.uvPrimaryText)
        }
        .padding(12)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Widget Configuration
struct CurrentUVWidget: Widget {
    let kind: String = "CurrentUVWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: UVProvider()) { entry in
            if #available(iOS 17.0, *) {
                CurrentUVWidgetView(entry: entry)
                    .containerBackground(for: .widget) {
                        LinearGradient(
                            colors: [Color.uvSoftYellow, Color.uvLightCream],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    }
            } else {
                CurrentUVWidgetView(entry: entry)
                    .background(
                        LinearGradient(
                            colors: [Color.uvSoftYellow, Color.uvLightCream],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
        }
        .configurationDisplayName("Current UV Index")
        .description("Shows the current UV index level")
        .supportedFamilies([.systemSmall])
    }
}

// MARK: - Preview
#Preview(as: .systemSmall) {
    CurrentUVWidget()
} timeline: {
    UVEntry(date: .now, currentUV: 4, hourlyForecast: [])
    UVEntry(date: .now, currentUV: 7, hourlyForecast: [])
    UVEntry(date: .now, currentUV: 11, hourlyForecast: [])
}
