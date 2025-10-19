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
        VStack(spacing: 16) {
            if viewModel.isLoading {
                ProgressView()
                    .padding(.vertical, 30)
            } else if let uv = viewModel.currentUV {
                // City Name
                VStack(spacing: 4) {
                    Image(systemName: "location.fill")
                        .font(.caption2)
                        .foregroundColor(.uvAccent)
                    
                    Text(viewModel.location)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
                .padding(.top, 8)
                // UV Index Display
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
                            Text("\(Int(uv.rounded()))")
                                .font(.system(size: 36, weight: .bold))
                                .foregroundColor(uvLevel.color)
                            
                            Text("UV")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    // Level Description
                    Text(uvLevel.description)
                        .font(.caption)
                        .fontWeight(.semibold)
                }
                
                // Recommendation
                Text(uvLevel.recommendation)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 8)
                
            } else {
                Spacer()
                
                VStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.largeTitle)
                        .foregroundColor(.orange)
                    
                    Text("No UV data")
                        .font(.headline)
                    
                    Text(viewModel.errorMessage ?? "Open the iPhone app to sync data")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Button {
                        viewModel.refresh()
                    } label: {
                        Label("Refresh", systemImage: "arrow.clockwise")
                            .font(.caption)
                    }
                    .buttonStyle(.bordered)
                    .tint(.uvAccent)
                }
                
                Spacer()
            }
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
}

#Preview {
    NavigationStack {
        CurrentUVIndexView()
    }
}
