//
//  WeatherManager.swift
//  Weatherly
//
//  Created by Alexandra on 17.10.25.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(weather: WeatherModel)
    func didCityCoordinatesRetrieve(city: CityData)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let AppId = "4ce2cef5670d81290a93126ab1aa7170"
    let apiVerData = "2.5"
    let apiVerGeo = "1.0"
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(lat: Double, lon: Double) {
        let url = "https://api.openweathermap.org/data/\(apiVerData)/weather?lat=\(lat)&lon=\(lon)&units=metric&appid=\(AppId)"
        performRequest(with: url, callback: weatherTaskHandler(data:response:error:))
    }
    
    func getCityCoordinates(cityName: String) {
        let url = "https://api.openweathermap.org/geo/\(apiVerGeo)/direct?q=\(cityName)&limit=1&appid=\(AppId)"
        performRequest(with: url, callback: cityCoordinatesTaskHandler(data:response:error:))
    }
    
    func performRequest(with urlString: String, callback: @escaping (Data?, URLResponse?, Error?) -> Void){
        let url = URL(string: urlString)
        if (url == nil) {
            print("err_url_is_nil")
            //how to throw error with custom description
            return
        }
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url!, completionHandler: callback)
        task.resume()
    }
    
    //how to merge this two methods below in one which will be using different types, e.g. City or Weather
    func cityCoordinatesTaskHandler(data: Data?, response: URLResponse?, error: Error?){
        if let safeError = error {
            print(safeError)
            delegate?.didFailWithError(error: safeError)
            return
        }
        
        if data == nil {
            print("err_data_is_nil")
            //how to throw error with custom description
            return
        }
        
        let decoder = JSONDecoder()
        do {
            let cityData = try decoder.decode([CityData].self, from: data!)
            if (cityData.isEmpty){
                print("Retrieved empty list of cities")
                return
            }
            delegate?.didCityCoordinatesRetrieve(city: cityData[0])
        } catch {
            print(error)
            delegate?.didFailWithError(error: error)
        }
    }
    
    func weatherTaskHandler(data: Data?, response: URLResponse?, error: Error?){
        if let safeError = error {
            print(safeError)
            delegate?.didFailWithError(error: safeError)
            return
        }
        
        if data == nil {
            print("err_data_is_nil")
            //how to throw error with custom description
            return
        }
        
        let decoder = JSONDecoder()
        do {
            let weatherData = try decoder.decode(WeatherData.self, from: data!)
            if (weatherData.weather.isEmpty){
                print("Retrieved empty list of weather data")
                return
            }
            delegate?.didUpdateWeather(weather: WeatherModel(city: weatherData.name, conditionId: weatherData.weather[0].id, temperature: weatherData.main.temp))
        } catch {
            print(error)
            delegate?.didFailWithError(error: error)
        }
    }
}
