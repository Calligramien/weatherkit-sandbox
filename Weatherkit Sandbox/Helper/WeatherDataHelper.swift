//
//  WeatherDataHelper.swift
//  Weatherkit Sandbox
//
//  Created by Damien Gautier on 05/04/2023.
//

import SwiftUI
import WeatherKit
import CoreLocation

@MainActor
class WeatherDataHelper: ObservableObject {
    
    static let shared = WeatherDataHelper()
    let service = WeatherService.shared
    @Published var currentWeather: CurrentWeather?
}
