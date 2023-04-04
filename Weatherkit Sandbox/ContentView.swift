//
//  ContentView.swift
//  Weatherkit Sandbox
//
//  Created by Damien Gautier on 04/04/2023.
//

import SwiftUI
import WeatherKit

struct ContentView: View {
    
    let weatherService = WeatherService.shared
    
    @StateObject var locationManager = LocationManager()
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }.task(id: locationManager.currentLocation) {
            do {
                if let location = locationManager.currentLocation {
                    let weather = try await weatherService.weather(for: location)
                    print(weather)
                }
            } catch {
                print("Error getting weather: \(error)")
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
