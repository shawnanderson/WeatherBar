//
//  WeatherView.swift
//  WeatherBar
//
//  Created by Brad Greenlee on 10/13/15.
//  Copyright © 2015 Etsy. All rights reserved.
//
//  Updated to Swift 5 compatiblity by Shawn Anderson on 8/18/2019
//
//  AppIcon made by Freepik from www.flaticon.com

import Cocoa

class WeatherView: NSView {
    @IBOutlet weak var imageView: NSImageView!
    @IBOutlet weak var cityTextField: NSTextField!
    @IBOutlet weak var currentConditionsTextField: NSTextField!
    @IBOutlet weak var humidityTextField: NSTextField!
    @IBOutlet weak var sunRiseTextField: NSTextField!
    @IBOutlet weak var sunSetTextField: NSTextField!
    
    func update(_ weather: Weather) {
        // do UI updates on the main thread
        DispatchQueue.main.async {
            self.cityTextField.stringValue = weather.city
            self.currentConditionsTextField.stringValue = "\(Int(truncating: weather.currentTemp))°F and \(weather.conditions)"
            self.humidityTextField.stringValue = "\(Int(truncating: weather.humidity))% Humidity"
            self.sunRiseTextField.stringValue = "Sunrise: \(weather.sunRise)"
            self.sunSetTextField.stringValue = "Sunset: \(weather.sunSet)"
            self.imageView.image = NSImage(named: weather.icon)
        }
    }
}
