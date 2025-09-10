import SwiftUI
import CoreLocation

struct CityHeaderView: View {
    var location: CLLocation
    @State private var placemark: CLPlacemark?
    
    var body: some View {
        HStack(spacing: 4) {
            HStack {
                Image(systemName: "location.fill")
                Text(placemark?.locality ?? "Loading...")
                    .font(.headline)
                    .fontWeight(.bold)
            }
            
            Spacer()
            VStack(alignment: .trailing) {
                Text(Date().formatted(.dateTime.month().day()))
                    .font(.headline)
                    .foregroundColor(.secondary)
                Text(Date().formatted(.dateTime.hour().minute()))
            }
            
        }
        .frame(maxWidth: .infinity)
        .onAppear(perform: getPlacemark)
    }
    
    private func getPlacemark() {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let placemark = placemarks?.first {
                self.placemark = placemark
            }
        }
    }
}

#Preview {
    CityHeaderView(location: CLLocation(latitude: 13.7563, longitude: 100.5018))
}
