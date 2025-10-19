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
        return getUVLevel(for: uv)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                // City Name
                VStack(spacing: 4) {
                    Image(systemName: "location.fill")
                        .font(.caption2)
                        .foregroundColor(.uvAccent)
                    
                    Text(viewModel.location)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.uvPrimaryText)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
                .padding(.top, 8)
                
                if viewModel.isLoading {
                    ProgressView()
                        .padding(.vertical, 20)
                } else if let uv = viewModel.currentUV {
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
                } else {
                    VStack(spacing: 8) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.title3)
                            .foregroundColor(.uvDanger)
                        
                        Text("No UV data")
                            .font(.caption)
                            .foregroundColor(.uvSecondaryText)
                        
                        Button("Refresh") {
                            viewModel.refresh()
                        }
                        .font(.caption)
                        .foregroundColor(.uvAccent)
                    }
                    .padding(.vertical, 20)
                }
            }
            .padding(.horizontal, 12)
        }
        .navigationTitle("UV Index")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.loadData()
        }
        .refreshable {
            viewModel.refresh()
        }
    }
}

#Preview {
    NavigationStack {
        CurrentUVIndexView()
    }
}
