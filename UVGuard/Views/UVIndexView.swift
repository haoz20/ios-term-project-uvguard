
//
//  UVIndexView.swift
//  UVGuard
//
//  Created by Swan Htet Aung on 1/9/25.
//

import SwiftUI

struct UVIndexView: View {
    @State private var viewModel: UVIndexViewModel = UVIndexViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            if let uv = viewModel.currentUV, let timeRange = viewModel.currentTimeRange {
                Text("Current UV Index")
                    .font(.title)
                
                Text(String(format: "%.2f", uv))
                    .font(.system(size: 80, weight: .bold))
                
                Text("Time: \(timeRange)")
                    .font(.headline)
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            } else {
                ProgressView()
            }
        }
        .padding()
    }
}

#Preview {
    UVIndexView()
}
