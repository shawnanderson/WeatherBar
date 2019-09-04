//
//  StatusMenuController.swift
//  WeatherBar
//
//  Created by Brad Greenlee on 10/11/15.
//  Copyright © 2015 Etsy. All rights reserved.
//
//  Updated to Swift 5 compatiblity by Shawn Anderson on 8/18/2019
//  AppIcon made by Freepik from www.flaticon.com

import Cocoa

let DEFAULT_ZIP = "30309" //Use only 5 digit US zip codes

class StatusMenuController: NSObject, PreferencesWindowDelegate {    
    @IBOutlet weak var statusMenu: NSMenu!
    @IBOutlet weak var weatherView: WeatherView!

    var weatherMenuItem: NSMenuItem!
    var preferencesWindow: PreferencesWindow!

    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let weatherAPI = WeatherAPI()
    
    override func awakeFromNib() {
        statusItem.menu = statusMenu
        let icon = NSImage(named: "statusIcon")
        icon?.isTemplate = true // best for dark mode
        statusItem.image = icon
        statusItem.menu = statusMenu
        weatherMenuItem = statusMenu.item(withTitle: "Weather")
        weatherMenuItem.view = weatherView
        preferencesWindow = PreferencesWindow()
        preferencesWindow.delegate = self
        
        //Hardcoded to update every 15 minutes - this should be a preference.  Keep the daily limit of requests you can make in mind. :)
        Timer.scheduledTimer(timeInterval: 900.0, target: self, selector: #selector(updateWeather), userInfo: nil, repeats: true)
        
        updateWeather()
    }
    
    @objc func updateWeather() {        
        let defaults = UserDefaults.standard
        let zip = defaults.string(forKey: "zip") ?? DEFAULT_ZIP
        weatherAPI.fetchWeather(zip) { weather in
            self.weatherView.update(weather)
        }
    }
    
    @IBAction func updateClicked(_ sender: NSMenuItem) {
        updateWeather()
    }
    
    @IBAction func preferencesClicked(_ sender: NSMenuItem) {
        preferencesWindow.showWindow(nil)
    }
    
    @IBAction func quitClicked(_ sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
    
    func preferencesDidUpdate() {
        updateWeather()
    }
}
