# WeatherDashboard

A native iOS weather app built with SwiftUI that provides real-time weather data, an 8-day forecast, an interactive map of local tourist attractions, and saved-location management.

---

## Features

| Tab | Description |
|-----|-------------|
| **Now** | Current conditions – temperature, weather icon, high/low, pressure, sunrise/sunset, and a contextual weather-advice banner |
| **Forecast** | 8-day bar chart (Swift Charts) showing daily highs & lows, plus a detailed daily-summary list |
| **Map** | Interactive MapKit view with up to 5 tourist-attraction pins; tap a pin to zoom in, long-press to open a Google search |
| **Saved** | History of every location you have searched, sorted by most-recently used; tap any row to reload it |

**Additional capabilities**

- 🔍 **City search** – type any city name in the top search bar to fetch weather and map data
- ❤️ **Favourites** – heart any location to pin it to the Favourites sheet; swipe-to-remove or clear all at once
- ⚙️ **Settings sheet**
  - *Appearance*: System / Light / Dark
  - *Background*: Aurora · Sunset · Ocean · Midnight
  - *Temperature unit*: Celsius (°C) / Fahrenheit (°F)
- 💾 **Offline-first storage** – searched places and their POIs are persisted with SwiftData so they load instantly on revisit

---

## Tech Stack

| Technology | Usage |
|---|---|
| **SwiftUI** | Entire UI layer |
| **SwiftData** | On-device persistence of `Place` and `AnnotationModel` records |
| **MapKit** | Interactive map, geocoding, and nearby-POI search |
| **Swift Charts** | 8-day temperature bar chart |
| **Combine** | Internal reactive bindings in `MainAppViewModel` |
| **OpenWeather One Call API 3.0** | Real-time weather + daily forecast data |

**Minimum deployment target:** iOS 17+  
**Language:** Swift 5.9+  
**IDE:** Xcode 15+

---

## Project Structure

```
WeatherDashboard/
├── Model/
│   ├── Place.swift              # SwiftData models: Place & AnnotationModel (POIs)
│   └── WeatherResponse.swift    # Decodable structs for the OpenWeather API response
├── ViewModel/
│   ├── MainAppViewModel.swift   # Central ObservableObject – search, loading, map & favourites logic
│   ├── WeatherService.swift     # Fetches weather data from the OpenWeather API
│   └── LocationManager.swift   # CLGeocoder wrapper + MapKit POI search
├── View/
│   ├── NavBarView.swift         # Root view: search bar + TabView
│   ├── CurrentWeatherView.swift # "Now" tab
│   ├── ForecastView.swift       # "Forecast" tab
│   ├── MapView.swift            # "Map" tab
│   ├── VisitedPlacesView.swift  # "Saved" tab
│   ├── FavoritesView.swift      # Favourites sheet
│   ├── SettingsView.swift       # Settings sheet
│   └── Components/              # Reusable sub-views (rows, pins, etc.)
└── Utility/
    ├── AppTheme.swift               # Light / Dark / System theme enum
    ├── AppBackground.swift          # Gradient background options & GradientBackground view
    ├── TemperatureUnit.swift        # °C / °F enum + conversion helpers
    ├── WeatherAdviceCategory.swift  # Temperature-based advice & colour coding
    ├── DateFormatter.swift          # Date/time formatting utilities
    ├── GoogleSearch.swift           # Builds a Google search URL for a query string
    └── WeatherMapError.swift        # Typed error enum for network & decoding failures
```

---

## Getting Started

### Prerequisites

- Xcode 15 or later
- An iOS 17+ simulator or physical device
- An **OpenWeather One Call API 3.0** key ([sign up here](https://openweathermap.org/api/one-call-3))

### Setup

1. **Clone the repository**

   ```bash
   git clone https://github.com/Himidiri/WeatherDashboard.git
   cd WeatherDashboard
   ```

2. **Open in Xcode**

   ```bash
   open WeatherDashboard.xcodeproj
   ```

3. **Add your API key**

   Open `WeatherDashboard/ViewModel/WeatherService.swift` and replace the placeholder key:

   ```swift
   private let apiKey = "YOUR_OPENWEATHER_API_KEY"
   ```

4. **Run the app**

   Select a simulator (iPhone 15 or later recommended) and press **⌘ R**.

---

## How It Works

1. On first launch the app loads weather data for **London** as the default location.
2. Type any city name in the **Change Location** search bar and press Search (or Return).
   - If the city was searched before, its record is loaded from SwiftData and fresh weather is fetched.
   - If it is new, weather and up to 5 nearby tourist attractions are fetched and saved.
3. Switch between the **Now**, **Forecast**, **Map**, and **Saved** tabs to explore the data.
4. Tap the **❤️** icon in the *Now* tab or swipe actions in *Saved* to manage favourites.
5. Open **Settings** (⚙️) to change the appearance theme, background gradient, or temperature unit.

---

## License

This project is for educational and portfolio purposes.
