import SwiftUI

struct HourlyComponent: View {
    let date: Date
    let uvIndex: Double
    @State private var settingsManager = SettingsManager.shared
    
    private var timeString: String {
        let calendar = Calendar.current
        if calendar.isDate(date, equalTo: Date(), toGranularity: .hour) {
            return "Now"
        }
        
        return date.formattedTime()
    }
    
    private var uvLevel: UVLevel {
        switch uvIndex {
        case 0..<3: return .low
        case 3..<6: return .moderate
        case 6..<8: return .high
        case 8..<11: return .veryHigh
        default: return .extreme
        }
    }
    
    private var uvColor: Color {
        switch uvLevel {
        case .low: return .green
        case .moderate: return .yellow
        case .high: return .orange
        case .veryHigh: return .red
        case .extreme: return .purple
        }
    }
    
    private var uvDescription: String {
        switch uvLevel {
        case .low: return "Low"
        case .moderate: return "Moderate"
        case .high: return "High"
        case .veryHigh: return "Very High"
        case .extreme: return "Extreme"
        }
    }
    
    var body: some View {
        VStack(spacing: 10) {
            // Time Display
            Text(timeString)
                .font(.montserratSemiBold(13))
                .uvPrimaryText()
            
            // UV Index Circle
            ZStack {
                Circle()
                    .fill(uvColor.opacity(0.2))
                    .frame(width: 45, height: 45)
                
                Circle()
                    .stroke(uvColor, lineWidth: 2.5)
                    .frame(width: 45, height: 45)
                
                Text(String(format: "%.0f", uvIndex))
                    .font(.montserratBold(13))
                    .foregroundColor(uvColor)
            }
            
            // UV Category
            Text(uvDescription)
                .font(.montserratMedium(9))
                .uvSecondaryText()
                .lineLimit(1)
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.uvCardBackground.opacity(0.6))
                .stroke(uvColor.opacity(0.4), lineWidth: 1)
        )
    }
}

#Preview {
//    ScrollView(.horizontal, showsIndicators: false) {
//        HStack(spacing: 8) {
//            HourlyComponent(date: Date(), uvIndex: 2.1)
//            HourlyComponent(date: Calendar.current.date(byAdding: .hour, value: 1, to: Date())!, uvIndex: 4.6)
//            HourlyComponent(date: Calendar.current.date(byAdding: .hour, value: 2, to: Date())!, uvIndex: 7.8)
//            HourlyComponent(date: Calendar.current.date(byAdding: .hour, value: 3, to: Date())!, uvIndex: 9.3)
//            HourlyComponent(date: Calendar.current.date(byAdding: .hour, value: 4, to: Date())!, uvIndex: 5.2)
//            HourlyComponent(date: Calendar.current.date(byAdding: .hour, value: 5, to: Date())!, uvIndex: 1.9)
//        }
//        .padding()
//    }
//    .background(Color(.systemGroupedBackground))
    
    HourlyComponent(date: Date(), uvIndex: 2.1)
//    HourlyComponent(date: Calendar.current.date(byAdding: .hour, value: 1, to: Date())!, uvIndex: 4.6)
}
