//
//  WeatherData.swift
//  Weatherly
//
//  Created by Alexandra on 18.10.25.
//

struct WeatherData : Codable {
    let weather: [Weather]
    let main: Main
}
