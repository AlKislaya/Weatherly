//
//  ViewController.swift
//  Weatherly
//
//  Created by Alexandra on 16.10.25.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    @IBOutlet weak var searchTextInput: UITextField!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var conditionImageView: UIImageView!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextInput.delegate = self
        weatherManager.delegate = self
        locationManager.delegate = self
        
        initLocation()
    }
    
    @IBAction func onLocationClicked(_ sender: UIButton) {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    func initLocation() {
        if CLLocationManager.locationServicesEnabled(), let location = locationManager.location {
            weatherManager.fetchWeather(lat: Double(location.coordinate.latitude), lon: Double(location.coordinate.longitude))
            return
        }
        
        weatherManager.fetchWeather(lat: 51.5074, lon: -0.1278) //london
    }
}

//MARK: - UITextFieldDelegate
extension WeatherViewController : UITextFieldDelegate {
    
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
}

//MARK: - WeatherManagerDelegate
extension WeatherViewController : WeatherManagerDelegate {
    
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

//MARK: - CLLocationManagerDelegate
extension WeatherViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.isEmpty {
            print("List of locations is empty")
            return
        }
        
        locationManager.stopUpdatingLocation()
        
        let lastLocation = locations.last!
        print(lastLocation.coordinate.latitude, lastLocation.coordinate.longitude)
        weatherManager.fetchWeather(lat: Double(lastLocation.coordinate.latitude), lon: Double(lastLocation.coordinate.longitude))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
         print(error.localizedDescription)
    }
}
