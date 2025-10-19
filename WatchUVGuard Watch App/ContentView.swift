//
//  ContentView.swift
//  WatchUVGuard Watch App
//
//  Created by Swan Htet Aung on 19/10/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink {
                    CurrentUVIndexView()
                } label: {
                    HStack {
                        Image(systemName: "sun.max.fill")
                            .foregroundColor(.uvAccent)
                            .font(.title3)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Current UV")
                                .font(.headline)
                            Text("View UV index")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }
                
                NavigationLink {
                    CitiesListView()
                } label: {
                    HStack {
                        Image(systemName: "building.2.fill")
                            .foregroundColor(.uvAccent)
                            .font(.title3)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Cities")
                                .font(.headline)
                            Text("View saved cities")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("UV Guard")
        }
    }
}

#Preview {
    ContentView()
}
