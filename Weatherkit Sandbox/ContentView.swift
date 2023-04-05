//
//  ContentView.swift
//  Weatherkit Sandbox
//
//  Created by Damien Gautier on 04/04/2023.
//

import SwiftUI
import WeatherKit
import CoreLocation
import Charts

struct ContentView: View {
    
    let weatherService = WeatherService.shared
    
    @StateObject var locationManager = LocationManager()
    @State private var weather: Weather?
    
    var hourlyWeatherData: [HourWeather] {
        if let weather {
            return Array(weather.hourlyForecast.filter { hourlyWeather in
                return hourlyWeather.date.timeIntervalSince(Date()) >= 0
            }.prefix(24))
        } else {
            return []
        }
    }
    
    var body: some View {
        VStack {
            if let weather {
                VStack {
                    Text("Tokyo")
                        .font(.largeTitle)
                    Text(locationManager.currentPlacemark?.locality ?? "Error")
                        .font(.largeTitle)
                    
                    Text("\(weather.currentWeather.temperature.formatted())")
                    Text("\(weather.currentWeather.condition.description.localizedCapitalized)")
                    Text("Visibility: \(weather.currentWeather.visibility.formatted())")
                    Text("Cloud cover: \(String(format: "%.0f%%", weather.currentWeather.cloudCover))")
                    Text("\(String(format: "%.0f°C", weather.currentWeather.apparentTemperature.value.rounded()))")

                }
                
                HourlyForecastView(hoursWeatherList: hourlyWeatherData)
                
                Spacer()
                
                HourlyForecastChartView(hourlyWeatherData: hourlyWeatherData)
                
                Spacer()
                
                TenDayForecastView(dayWeatherList: weather.dailyForecast.forecast)
            }
        }
        .padding()
        .task(id: locationManager.userLocation) {
            do {
                if let location = locationManager.userLocation {
                    self.weather = try await weatherService.weather(for: location)
                }
                
//                let location = CLLocation(latitude: 35.672855, longitude: 139.817413)
//                self.weather = try await weatherService.weather(for: location)
                // TODO Delete two lines below when everything is done - Mockup Weather Data
                
            } catch {
                print("Error getting weather: \(error)")
            }
        }
        .padding()
    }
    
    struct HourlyForecastView: View {
        
        let hoursWeatherList: [HourWeather]
        
        var body: some View {
            VStack (alignment: .leading) {
                Text("HOURLY FORECAST")
                    .font(.caption)
                    .opacity(0.5)
                
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(hoursWeatherList, id: \.date) { hourWeatherItem in
                            VStack(spacing: 20) {
                                Text(hourWeatherItem.date.formatAsAbbreviatedTime())
                                Image(systemName: "\(hourWeatherItem.symbolName).fill")
                                    .foregroundColor(.black)
                                Text(hourWeatherItem.temperature.formatted())
                                    .fontWeight(.medium)
                            }
                            .padding()
                        }
                    }
                }
            }
            .padding()
            .background { Color.blue }
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .foregroundColor(.white)
        }
    }
    
    struct TenDayForecastView: View {
        
        let dayWeatherList: [DayWeather]
        
        var body: some View {
            VStack(alignment: .leading) {
                Text("10 Days Weather Forecast")
                    .font(.caption)
                    .opacity(0.5)
                
                List(dayWeatherList, id: \.date) { dailyWeather in
                    HStack {
                        Text(dailyWeather.date.formatAsAbbreviatedDay())
                            .frame(maxWidth: 50, alignment: .leading)
                        
                        Image(systemName: "\(dailyWeather.symbolName)")
                            .foregroundColor(.black)
                        
                        Text(dailyWeather.lowTemperature.formatted())
                            .frame(maxWidth: .infinity)
                        
                        Text(dailyWeather.highTemperature.formatted())
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.blue)
                }
                .listStyle(.plain)
            }
        }
    }
    
    struct HourlyForecastChartView: View {
        
        let hourlyWeatherData: [HourWeather]
        
        var body: some View {
            Chart {
                ForEach(hourlyWeatherData.prefix(10), id: \.date) { hourlyWeather in
                    LineMark(x: .value("Hour", hourlyWeather.date.formatAsAbbreviatedTime()), y: .value("Temperature", hourlyWeather.temperature.value))
                }
            }
        }
    }
}

extension Date {
    func formatAsAbbreviatedDay() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: self)
    }
    
    func formatAsAbbreviatedTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "ha"
        return formatter.string(from: self)
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
