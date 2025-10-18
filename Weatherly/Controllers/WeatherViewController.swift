//
//  ViewController.swift
//  Weatherly
//
//  Created by Alexandra on 16.10.25.
//

import UIKit

class WeatherViewController: UIViewController, UITextFieldDelegate, WeatherManagerDelegate {
    @IBOutlet weak var searchTextInput: UITextField!
    var weatherManager = WeatherManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextInput.delegate = self
        weatherManager.delegate = self
    }

    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextInput.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextInput.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        let isTextEmpty = textField.text == ""
        if isTextEmpty
        {
            textField.placeholder = "Waiting for your city, honey"
        }
        
        return !isTextEmpty
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if let city = textField.text {
            //WeatherManager().fetchWeather(cityName: city)
            weatherManager.getCityCoordinates(cityName: city)
        }
        textField.text = ""
    }
    
    func didUpdateWeather(weather: WeatherModel) {
        print(weather.temperatuteString)
    }
    
    func didCityCoordinatesRetrieve(city: CityData) {
        print(city.lat, city.lon)
        weatherManager.fetchWeather(lat: city.lat, lon: city.lon)
    }
}

