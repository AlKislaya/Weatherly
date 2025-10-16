//
//  ViewController.swift
//  Weatherly
//
//  Created by Alexandra on 16.10.25.
//

import UIKit

class WeatherViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var searchTextInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextInput.delegate = self
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
        //Search for weather in the given city
        textField.text = ""
    }
}

