//
//  ViewController.swift
//  Weatherly
//
//  Created by Alexandra on 16.10.25.
//

import UIKit

class WeatherViewController: UIViewController, UITextFieldDelegate, WeatherManagerDelegate {
    @IBOutlet weak var searchTextInput: UITextField!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var conditionImageView: UIImageView!
    
    var weatherManager = WeatherManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextInput.delegate = self
        weatherManager.delegate = self
        weatherManager.fetchWeather(lat: 51.5074, lon: -0.1278) //london
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
            weatherManager.getCityCoordinates(cityName: city)
        }
        textField.text = ""
    }
    
    func didUpdateWeather(weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatuteString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.city
        }
    }
    
    func didCityCoordinatesRetrieve(city: CityData) {
        print(city.lat, city.lon)
        weatherManager.fetchWeather(lat: city.lat, lon: city.lon)
    }
    
    func didFailWithError(error: any Error) {
        
    }
}

