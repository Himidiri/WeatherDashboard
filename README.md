# WeatherDashboard

WeatherDashboard is a native iOS application developed using SwiftUI. The purpose of the application is to provide real-time weather information and nearby tourist attractions for any user-specified location worldwide.

It integrates live weather data, geocoding, maps, and local data storage into a clean, modern multi-tab interface.

## Application Overview

The application consists of four primary tabs:

1. Now  
2. 8-Day Weather  
3. Map  
4. Visited Places  

Each tab presents specific information related to the selected location while maintaining synchronized data across the entire application.

## Functional Features

### Location Search
- Users can enter any city name.
- The application converts the place name into geographic coordinates using `CLGeocoder`.
- Weather and map data are updated dynamically across all tabs.

### Real-Time Weather (Now Tab)
- Displays current temperature and weather condition.
- Shows sunrise and sunset times.
- Displays additional weather metrics such as pressure.
- Generates a contextual weather advisory message using an enumeration-based logic structure.
- Uses a gradient background consistent with the overall design.

### 8-Day Forecast
- Presents a bar chart visualising daily high and low temperatures.
- Includes a scrollable textual summary of the forecast.
- Implements dynamic colour representation based on temperature values.

### Place Map
- Displays an interactive map using MapKit.
- Shows five nearby tourist attractions retrieved using `MKLocalSearch`.
- Supports map interaction:
  - Selecting a list item centres the map on the location.
  - Selecting a map pin zooms to the region.
  - Long pressing a location opens a web search in the browser.

### Stored Places
- Saves searched locations using SwiftData.
- Allows reloading of previously saved locations.
- Supports swipe-to-delete functionality.
- Enables long-press web search for stored locations.

### Error Handling
- Invalid location input triggers a user alert.
- The application reverts to the default location (London) when an error occurs.

## Default Behaviour

Upon first launch:
- The application automatically loads weather and map data for London.
- All tabs display synchronised data for this default location.

## Technology Stack

The application is implemented using the following technologies:

- Swift 6+
- SwiftUI
- SwiftData
- CoreLocation (CLGeocoder)
- MapKit (MKLocalSearch)
- OpenWeather One Call API 3.0
- Async/Await networking model

No external third-party frameworks were used.

## Key Implementation Concepts

The project demonstrates the following development concepts:

- JSON data modelling and decoding
- Modern asynchronous networking using async/await
- Structured error handling
- Geocoding and coordinate management
- Persistent storage using SwiftData
- Tab-based interface design in SwiftUI
- State management and cross-view data synchronisation

## System Requirements

- Xcode 16.x
- iOS 17 or later
- Valid OpenWeather API key

## Installation and Execution

1. Clone the repository:
   ```bash
   git clone https://github.com/Himidiri/WeatherDashboard.git
   ```
2. Open the project in Xcode: `WeatherDashboard.xcodeproj`
3. Insert a valid OpenWeather API key in `WeatherService.swift`.
4. Build and run on iOS Simulator or a real device.

## Screenshots

<div align="center">

<img src="https://github.com/user-attachments/assets/a1e88357-5839-4586-931b-1628f3b46b87" width="250"/>
<img src="https://github.com/user-attachments/assets/1a6dc688-0e05-4fe3-98db-0783057f3f19" width="250"/>
<img src="https://github.com/user-attachments/assets/79f02a73-de23-4fd3-99ab-37b8cc72d36f" width="250"/>

<br/>

<img src="https://github.com/user-attachments/assets/63cc2f22-70c8-4a1d-bbcd-36b0ec26685a" width="250"/>
<img src="https://github.com/user-attachments/assets/e005edc5-815e-4b2b-bb4e-a2cf404b98b6" width="250"/>
<img src="https://github.com/user-attachments/assets/e08f206b-a869-4339-bfd4-8c83a77e790c" width="250"/>

<br/>

<img src="https://github.com/user-attachments/assets/d5baade4-849b-4f31-bbf5-f47cb513f19a" width="250"/>
<img src="https://github.com/user-attachments/assets/551709f8-936b-41ce-bbf9-c7e9a628868c" width="250"/>
<img src="https://github.com/user-attachments/assets/524a5d5a-0c80-4c11-acee-1ba354113c99" width="250"/>

<br/>

<img src="https://github.com/user-attachments/assets/03cc33d7-c86c-4bdd-be75-68569f4a1a1a" width="250"/>
<img src="https://github.com/user-attachments/assets/b1a9c14f-9c05-4318-84af-e5883cfe04a2" width="250"/>
<img src="https://github.com/user-attachments/assets/007de977-ccac-4364-9bcc-e01a29e5234c" width="250"/>

</div>
