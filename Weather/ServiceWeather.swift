//
//  ServiceWeather.swift
//  Weather
//
//  Created by IgorMac on 7/27/18.
//  Copyright © 2018 IgorMac. All rights reserved.
//

import Foundation
import Alamofire

protocol ServiceWeatherDelegate {
    func updateWeatherInfo()
}

protocol CurrentWeatherDataDelegate {
    func updateWatherData()
}

class ServiceWeather {
  
    
    var delegate: ServiceWeatherDelegate!
    var nameCity: String?
    var currentTemp: String?
    var temperat: Double?
    var pressureCity: Double?
    var humidityCity: String?
    var mainWeather: String?
    var mainDesription: String?
    var mainIcon: String?
    typealias JSONStandard = Dictionary<String, AnyObject>
    let serviceAPIKey = "8909c04fa24962ecc74701abaacdf850"
    let serviceURL = "https://api.openweathermap.org/data/2.5/weather?q="
    // https://api.openweathermap.org/data/2.5/weather?q=Vena&appid=8909c04fa24962ecc74701abaacdf850

    var temperature: String {
        return currentTemp ?? "0 °C"
    }
    
    func  getWatherCity(city: String) {
        
        let customUrl = URL(string: serviceURL + "\(city)&appid=\(serviceAPIKey)" )
        
        request(customUrl!, method: .get).responseJSON(completionHandler: {(respone)  in
            
            if (respone.result.error != nil) {
                NSLog("Error: \(String(describing: respone.result.error))" )
            } else {
                if let dict = respone.result.value as? JSONStandard, let main = dict["main"] as? JSONStandard, let temp = main["temp"] as? Double, let pressure = main["pressure"] as? Double, let humidity = main["humidity"] as? Double, let weather = dict["weather"] as? [JSONStandard], let mainWeather = weather[0]["main"] as? String, let mainDescription = weather[0]["description"] as? String, let iconMain = weather[0]["icon"] as? String {
                    self.temperat = temp
                    print("Temperature")
                    print(temp)
                    self.currentTemp = String(format: "%.0f °C", temp - 273.15)
                    self.pressureCity = pressure
                    self.humidityCity = String(humidity)
                    self.mainWeather = mainWeather
                    self.mainDesription = mainDescription
                    self.mainIcon = iconMain
                    print(self.currentTemp!)
                    print(self.pressureCity!)
                    print(self.humidityCity!)
                    print(self.mainDesription!)
                    print(self.mainIcon!)
                }
                // add in dataCore
                
            }
            /*
            DispatchQueue.global(qos: .userInitiated).async {
                
                self.delegate.updateWeatherInfo()
                DispatchQueue.main.async {
                    self.currentTemp = self.temperat
                }
           }
            */
        })
    }
    
    func timeUnix(unixTime: Int) -> String {
        let timeInSecond = TimeInterval(unixTime)
        let dataWeather = Date(timeIntervalSince1970:  timeInSecond)
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat! = "HH:mm"
        
        return dateFormat.string(from: dataWeather)
    }
    
 
    func iconWeather(stringIcon: String) -> UIImage {
        
        let imagesName: String
        
        switch stringIcon {
        case "01d": imagesName = "01d"         //clear sky
        case "02d": imagesName = "02d"         //few clouds
        case "03d": imagesName = "03d_cloudy"         //scattered clouds
        case "04d": imagesName = "04d"         //scattered clouds
        case "09d": imagesName = "09d"         //scattered clouds
        case "10d": imagesName = "10d"         //rain
        case "11d": imagesName = "11d"         //thunderstorm
        case "13d": imagesName = "13d"         //snow
        case "50d": imagesName = "50d"         //mist
        case "01n": imagesName = "01n"         //night clear sky
        case "02n": imagesName = "02n"         //night few clouds
        case "03n": imagesName = "03n"         //night scattered clouds
        case "04n": imagesName = "04n"         //night scattered clouds
        case "09n": imagesName = "09n"         //night scattered clouds
        case "10n": imagesName = "10n"         //night rain
        case "11n": imagesName = "11n"         //night thunderstorm
        case "13n": imagesName = "13n"         //night snow
        case "50n": imagesName = "50n"         //night mist
        default: imagesName = "na"
        }
        
        let iconImage = UIImage(named: imagesName)
        return iconImage!
    }
    
}
