//
//  HourlyForecastView.swift
//  Weatherkit Sandbox
//
//  Created by Damien Gautier on 04/04/2023.
//

import SwiftUI
import WeatherKit

struct HourlyForecastView: View {
    
    let hoursWeatherList: [HourWeather]
    
    var body: some View {
        VStack (alignment: .leading) {
            Text("HOURLY FORECAST")
            .font(.caption)
            .opacity(0.5)
        }
    }
}

//struct HourlyForecastView_Previews: PreviewProvider {
//    static var previews: some View {
//        HourlyForecastView(hoursWeatherList: [HourWeather])
//    }
//}
