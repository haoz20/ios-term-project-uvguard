# UVGuard ☀️

**iOS Term Project**

A comprehensive UV index monitoring and protection application for iOS and watchOS.

## Team Members
- Swan Htet Aung
- Thiri Htet

## Project Description

UVGuard is a health-focused mobile application that helps users monitor UV radiation levels and protect themselves from harmful sun exposure. The app provides real-time UV index data, personalized forecasts, and smart notifications to keep users informed about sun safety throughout the day.

### Key Features

- **Real-time UV Index Monitoring**: Track current UV levels for your location
- **Multi-day Forecasts**: View hourly and daily UV predictions
- **Multiple Cities**: Monitor UV levels across different locations
- **Smart Notifications**: Morning and evening UV briefings based on customizable thresholds
- **UV Protection Articles**: Educational content about sun safety and protection
- **Dark Mode Support**: Adaptive interface for comfortable viewing
- **Apple Watch Support**: Check UV levels directly from your wrist
- **Customizable Settings**: 24-hour time format, notification preferences, and appearance options

### Technology Stack

- **Platform**: iOS 17.0+, watchOS 10.0+
- **Language**: Swift 5.9
- **Framework**: SwiftUI
- **Architecture**: MVVM (Model-View-ViewModel)
- **API**: Open-Meteo UV Index API
- **Location Services**: CoreLocation

### SwiftUI Components Used

- **LazyVStack**: Vertical scrolling lists (Cities, Search results)
- **LazyVGrid**: 2-column grid layout (Articles)
- **Grid**: Tabular data display (Daily forecasts)
- **Custom Fonts**: Montserrat font family
- **Adaptive Colors**: iOS/watchOS compatible dark mode

### Installation

1. Clone the repository
2. Open `UVGuard.xcodeproj` in Xcode
3. Build and run on iOS Simulator or physical device

### API Key

The app uses the free Open-Meteo API (no key required) for UV index data.

### Project Structure

```
UVGuard/
├── Models/          # Data models (UVModel, CityModel, Article, etc.)
├── Views/           # SwiftUI views and components
├── ViewModels/      # Business logic and data handling
├── Services/        # API, Location, Notifications, Settings
├── Theme/           # Custom fonts and styling
└── Extensions/      # Date formatting and utilities
```