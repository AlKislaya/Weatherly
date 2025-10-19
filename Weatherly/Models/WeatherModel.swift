//
//  WeatherModel.swift
//  Weatherly
//
//  Created by Alexandra on 18.10.25.
//

import Foundation

struct WeatherModel {
    let city: String
    let conditionId: Int
    let temperature: Double
    
    var conditionName: String {
        return getConditionName(weatherId: conditionId)
    }
    var temperatuteString: String {
        return String(format: "%.1f", temperature)
    }
    
    func getConditionName(weatherId: Int) -> String{
        switch weatherId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
}
