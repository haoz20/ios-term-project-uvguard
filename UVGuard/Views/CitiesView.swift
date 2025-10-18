//
//  CitiesView.swift
//  UVGuard
//
//  Created by Swan Htet Aung on 4/9/25.
//

import SwiftUI

struct CitiesView: View {
    
    @State private var showAddCity = false
    @State private var cities: [CityModel] = []
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Warm background gradient
                LinearGradient.uvBackground
                    .ignoresSafeArea()
                
                Group {
                    if cities.isEmpty {
                        emptyStateView
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 16) {
                                ForEach(cities) { city in
                                    CityCard(city: city)
                                        .contextMenu {
                                            Button(role: .destructive) {
                                                deleteCity(city)
                                            } label: {
                                                Label("Delete", systemImage: "trash")
                                            }
                                        }
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 20)
                        }
                    }
                }
            }
            .navigationTitle("Cities")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddCity = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.uvAccent)
                            .font(.title3)
                    }
                }
            }
            .sheet(isPresented: $showAddCity) {
                SearchCityView(saveCity: { city in
                    addCity(city)
                })
            }
            .onAppear {
                loadCities()
            }
        }
    }
    
    // MARK: - Empty State View
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "location.slash.fill")
                .font(.system(size: 60))
                .foregroundColor(.uvAccent)
            
            Text("No Cities Added")
                .font(.title2)
                .fontWeight(.bold)
                .uvPrimaryText()
            
            Text("Add cities to see UV index information for multiple locations.")
                .font(.body)
                .multilineTextAlignment(.center)
                .uvSecondaryText()
                .padding(.horizontal, 40)
            
            Button {
                showAddCity = true
            } label: {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Add Your First City")
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(UVPrimaryButtonStyle())
            .padding(.horizontal, 40)
            .padding(.top, 10)
        }
        .frame(maxHeight: .infinity)
    }
    
    private func loadCities() {
        if let data = UserDefaults.standard.object(forKey: "favorite-cities") as? Data {
            do {
                let savedCities = try JSONDecoder().decode([CityModel].self, from: data)
                cities = savedCities
            } catch {
                
            }
        }
    }
    
    private func saveCities() {
        do {
            let encoder = JSONEncoder()
            let saveCities = try encoder.encode(cities)
            UserDefaults.standard.set(saveCities, forKey: "favorite-cities")
        } catch {
            
        }
    }
    
    
    private func addCity(_ city: CityModel) {
        if !cities.contains(where: { $0.id == city.id }) {
            cities.append(city)
        }
        saveCities()
    }
    
    private func deleteCity(_ city: CityModel) {
        cities.removeAll { $0.id == city.id }
        saveCities()
    }
    
    private func deleteCities(at offsets: IndexSet) {
        cities.remove(atOffsets: offsets)
        saveCities()
    }
    
}

#Preview {
    CitiesView()
}
