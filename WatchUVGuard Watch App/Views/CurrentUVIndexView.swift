//
//  CurrentUVIndexView.swift
//  WatchUVGuard Watch App
//
//  Created by Swan Htet Aung on 19/10/25.
//

import SwiftUI

struct CurrentUVIndexView: View {
    @State private var viewModel = UVIndexViewModel()
    
    var uvLevel: UVLevel {
        guard let uv = viewModel.currentUV else { return .low }
        switch uv {
        case 0..<3:
            return .low
        case 3..<6:
            return .moderate
        case 6..<8:
            return .high
        case 8..<11:
            return .veryHigh
        default:
            return .extreme
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                if viewModel.isLoading {
                    ProgressView()
                        .tint(.green)
                        .padding(.vertical, 30)
                } else if let uv = viewModel.currentUV {
                    // City Name
                    VStack(spacing: 2) {
                        Image(systemName: "location.fill")
                            .font(.caption2)
                            .foregroundColor(.green)
                        
                        Text(viewModel.location)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                    }
                    
                    // UV Index Display
                    VStack(spacing: 6) {
                        // UV Circle
                        ZStack {
                            Circle()
                                .fill(uvLevel.color.opacity(0.2))
                                .frame(width: 100, height: 100)
                            
                            Circle()
                                .stroke(uvLevel.color, lineWidth: 4)
                                .frame(width: 100, height: 100)
                            
                            VStack(spacing: 2) {
                                Text("\(Int(uv.rounded()))")
                                    .font(.system(size: 40, weight: .bold, design: .rounded))
                                    .foregroundColor(uvLevel.color)
                                
                                Text("UV")
                                    .font(.caption2)
                                    .foregroundColor(.white.opacity(0.7))
                            }
                        }
                        
                        // Level Description
                        Text(uvLevel.description)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                    
                    // Recommendation
                    VStack(spacing: 4) {
                        Text("Protection")
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.7))
                        
                        Text(getRecommendation())
                            .font(.caption)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .lineLimit(3)
                    }
                    .padding(.horizontal, 8)
                    
                } else {
                    VStack(spacing: 12) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 34, weight: .bold))
                            .foregroundColor(.orange)
                        
                        Text("No UV data")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Text(viewModel.errorMessage ?? "Open the iPhone app to sync data")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        Button {
                            viewModel.refresh()
                        } label: {
                            Label("Refresh", systemImage: "arrow.clockwise")
                                .font(.caption)
                        }
                        .buttonStyle(.bordered)
                        .tint(.green)
                    }
                    .padding(.vertical, 20)
                }
            }
            .padding(.vertical, 8)
        }
        .navigationTitle("UV Index")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.refresh()
                } label: {
                    Image(systemName: "arrow.clockwise")
                        .font(.caption)
                }
                .buttonStyle(.plain)
            }
        }
        .onAppear {
            viewModel.loadData()
        }
    }
    
    // Helper function for recommendations
    private func getRecommendation() -> String {
        switch uvLevel {
        case .low:
            return "Minimal protection needed"
        case .moderate:
            return "Wear sunscreen"
        case .high:
            return "Protection essential"
        case .veryHigh:
            return "Extra protection required"
        case .extreme:
            return "Avoid sun exposure"
        }
    }
}

#Preview {
    NavigationStack {
        CurrentUVIndexView()
    }
}
