//
//  WeatherManager.swift
//  Weatherly
//
//  Created by Alexandra on 17.10.25.
//

import Foundation

struct WeatherManager {
    let AppId = "4ce2cef5670d81290a93126ab1aa7170"
    let apiVerData = "2.5"
    let apiVerGeo = "1.0"
    
    func fetchWeather(cityName: String) {
        //let url = "https://api.openweathermap.org/data/\(apiVerData)/weather?lat=\(lat)&lon=\(lon)&units=metric&appid=\(AppId)"
    }
    
    func getCityLatLong(cityName: String) {
        let url = "https://api.openweathermap.org/geo/\(apiVerGeo)/direct?q=\(cityName)&limit=1&appid=\(AppId)"
        performRequest(url)
    }
    
    func performRequest(_ urlString: String){
        let url = URL(string: urlString)
        if (url == nil) {
            print("err_url_is_nil")
            return
        }
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url!, completionHandler: urlTaskHandler(data:response:error:))
        task.resume()
    }
    
    func urlTaskHandler(data: Data?, response: URLResponse?, error: Error?){
        if let safeError = error {
            print(safeError)
            return
        }
        
        if data == nil {
            print("err_data_is_nil")
            return
        }
        
        let dataString = String(data: data!, encoding: .utf8)
        print(dataString!)
    }
}
