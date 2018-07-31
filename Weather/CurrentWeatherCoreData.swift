//
//  CurrentWeather.swift
//  Weather
//
//  Created by IgorMac on 7/27/18.
//  Copyright © 2018 IgorMac. All rights reserved.
//

import Foundation
import CoreData
import UIKit


class CurrenWeather: UIViewController, CurrentWeatherDataDelegate {

    
    
    var city: String?
    var nameCity: String?
    var currentTemp: String?
    var currentTempKelvin: String?
    var pressureCity: Double?
    var humidityCity: String?
    var mainWeather: String?
    var mainDesription: String?
    var mainIcon: String?
    var dateNowCity: Double?
    var timeWeatherCity: Double?
    var showCity: [City] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var tableView: UITableView!
   // var delegate: CurrenWeather!
    var servicelWeather = ServiceWeather()
    //var detailWeather = DetailWeather()
  
    
    
    //MARK : ServiceWeatherDelegate
    /*
    func updateWeatherInfo() {
        
        DispatchQueue.main.async {
            
            self.nameCity = self.servicelWeather.nameCity
            self.currentTemp = self.servicelWeather.currentTemp
            print("City is \(self.nameCity) now \(self.currentTemp!)")
            print("its all ok")
            self.currentTempKelvin = self.servicelWeather.temperat
            self.pressureCity = self.servicelWeather.pressureCity
            self.humidityCity = self.servicelWeather.humidityCity
            self.mainWeather = self.servicelWeather.mainWeather
            self.mainDesription = self.servicelWeather.mainDesription
            self.mainIcon = self.servicelWeather.mainIcon
        }
        
    }
 */
    func updateWatherData() {
        <#code#>
    }
    
    func updateWeatherInfo() {
        DispatchQueue.main.async {
            self.currentTemp = self.servicelWeather.currentTemp
            print(self.currentTemp)
            
            //
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "City")
            request.predicate = NSPredicate(format: "cityName == %@", self.nameCity!)
            if self.nameCity == "" {
                // self.tableView.reloadData()
            } else {
                do {
                    let result = try self.context.fetch(request)
                    if result.count > 0 {
                        let namecity = (result[0] as AnyObject).value(forKey: "cityName") as! String
                        print (namecity)
                        
                        print(result)
                        let currenTemperature = (result[0] as AnyObject).setValue("300", forKey: "currentTemp")
                        print("->")
                        print(currenTemperature)
                        print("->")
                        
                        self.showCity = try self.context.fetch(request) as! [City]
                        
                        //  self.tableView.reloadData()
                        
                    } else {
                        print("City is not present in CoreData")
                    }
                } catch let error as NSError {
                    print("Could not search data \(error), \(error.userInfo)")
                }
            }

        }
    }
 
    func searchUpdateRecordData(searchCity: String) {
        self.servicelWeather.delegate = self as! ServiceWeatherDelegate

        let searchCityData = searchCity
        print(searchCityData)
        nameCity = searchCityData
        
       
        let setServiceWeather = servicelWeather.currentTemp
        print("->")
        print(setServiceWeather)
        
      //      self.currentTempKelvin = self.detailWeather.lblTempKelvin.text

       //     print(self.currentTempKelvin)
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "City")
        print(request)
        request.predicate = NSPredicate(format: "cityName == %@", nameCity!)
        if searchCityData == "" {
           // self.tableView.reloadData()
        } else {
            do {
                let result = try self.context.fetch(request)
                if result.count > 0 {
                    let namecity = (result[0] as AnyObject).value(forKey: "cityName") as! String
                    print (namecity)
                    
                    print(result)
          //          let currenTemperature = (result[0] as AnyObject).setValue("", forKey: "currentTemp")
                    print("->")
         //           print(currenTemperature)
                    print("->")

                    self.showCity = try self.context.fetch(request) as! [City]

                  //  self.tableView.reloadData()
                    
                } else {
                    print("City is not present in CoreData")
                }
            } catch let error as NSError {
                print("Could not search data \(error), \(error.userInfo)")
            }
        }
    }
    
}

