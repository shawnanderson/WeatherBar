//
//  WeatherAPI.swift
//  WeatherBar
//
//  Created by Brad Greenlee on 10/11/15.
//  Copyright © 2015 Etsy. All rights reserved.
//
//  Updated to Swift 5 compatiblity by Shawn Anderson on 8/18/2019
//
//  AppIcon made by Freepik from www.flaticon.com

import Foundation

struct Weather: CustomStringConvertible {
    var city: String
    var sunRise: String
    var sunSet: String
    var humidity: NSNumber
    var currentTemp: NSNumber
    var conditions: String
    var icon: String
    
    var description: String {
        return "\(city): \(currentTemp)F and \(conditions)"
    }
}

class WeatherAPI {
    let API_KEY = "your-api-key-here"
    let BASE_URL = "http://api.openweathermap.org/data/2.5/weather"
    
    func fetchWeather(_ query: String, success: @escaping (Weather) -> Void) {
        let session = URLSession.shared
        // url-escape the query string we're passed
        let escapedQuery = query.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let url = URL(string: "\(BASE_URL)?APPID=\(API_KEY)&units=imperial&zip=\(escapedQuery!),us")
        
        //Write out the query string to log for debugging.  Put query string in Postman for debugging.
        NSLog("Query string is: \(url!)")
        
        let task = session.dataTask(with: url!) { data, response, err in
            // first check for a hard error
            if let error = err {
                NSLog("weather api error: \(error)")
            }
            
            // then check the response code
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200: // all good!
                    if let weather = self.weatherFromJSONData(data!) {
                        success(weather)
                    }
                case 401: // unauthorized
                    NSLog("weather api returned an 'unauthorized' response. Did you set your API key?")
                default:
                    NSLog("weather api returned response: %d %@", httpResponse.statusCode, HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))
                }
            }
        }
        task.resume()
    }
    
    func weatherFromJSONData(_ data: Data) -> Weather? {
        typealias JSONDict = [String:AnyObject]
        let json : JSONDict
        
        do {
            json = try JSONSerialization.jsonObject(with: data, options: []) as! JSONDict
        } catch {
            NSLog("JSON parsing failed: \(error)")
            return nil
        }
        
        let mainDict = json["main"] as! JSONDict
        let weatherList = json["weather"] as! [JSONDict]
        let sysDict = json["sys"] as! JSONDict
        let weatherDict = weatherList[0]
        
        let weather = Weather(
            city: json["name"] as! String,
            sunRise: self.getTimeFromUnixDateTime(sysDict["sunrise"] as! Double),
            sunSet: self.getTimeFromUnixDateTime(sysDict["sunset"] as! Double),
            humidity: mainDict["humidity"] as! NSNumber,
            currentTemp: mainDict["temp"] as! NSNumber,
            conditions: weatherDict["main"] as! String,
            icon: weatherDict["icon"] as! String
        )
        
        return weather
    }
    
    func getTimeFromUnixDateTime(_ dateTime: Double) -> String{
            let date = Date(timeIntervalSince1970: dateTime)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a"
            
        return dateFormatter.string(from: date)
    }
}
