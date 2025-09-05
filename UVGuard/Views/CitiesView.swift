//
//  CitiesView.swift
//  UVGuard
//
//  Created by Swan Htet Aung on 4/9/25.
//

import SwiftUI

struct CitiesView: View {
    
    
    @State private var showAddCity = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                
            }
            .navigationTitle("Cities")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddCity = true
                    } label: {
                        HStack {
                            Image(systemName: "plus.app")
                        }
                        
                    }
                }
            }
            .sheet(isPresented: $showAddCity) {
                SearchCityView()
            }
        }
        
        
        
    }
}

#Preview {
    CitiesView()
}
