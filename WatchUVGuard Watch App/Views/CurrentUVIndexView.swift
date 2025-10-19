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
                        .font(.uvCaption2)
                        .foregroundColor(.uvAccent)
                    
                    Text(viewModel.location)
                        .font(.uvCaption)
                        .fontWeight(.semibold)
                        .foregroundColor(.uvPrimaryText)
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
                                .font(.montserratBold(36))
                                .foregroundColor(uvLevel.color)
                            
                            Text("UV")
                                .font(.uvCaption2)
                                .foregroundColor(.uvSecondaryText)
                        }
                    }
                    
                    // Level Description
                    Text(uvLevel.description)
                        .font(.uvCaption)
                        .fontWeight(.semibold)
                        .foregroundColor(.uvPrimaryText)
                }
                
                // Recommendation
            } else {
                Spacer()
                
                VStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.montserratBold(34))
                        .foregroundColor(.orange)
                    
                    Text("No UV data")
                        .font(.uvHeadline)
                        .foregroundColor(.uvPrimaryText)
                    
                    Text(viewModel.errorMessage ?? "Open the iPhone app to sync data")
                        .font(.uvCaption)
                        .foregroundColor(.uvSecondaryText)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Button {
                        viewModel.refresh()
                    } label: {
                        Label("Refresh", systemImage: "arrow.clockwise")
                            .font(.uvCaption)
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
