//
//  detailWeather.swift
//  Weather
//
//  Created by IgorMac on 7/26/18.
//  Copyright © 2018 IgorMac. All rights reserved.
//

import UIKit

class DetailWeather: UIViewController, ServiceWeatherDelegate{

    @IBOutlet weak var lblCityName: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTemperature: UILabel!
    @IBOutlet weak var iconWeather: UIImageView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var mainWeather: UILabel!
    @IBOutlet weak var lblTempKelvin: UILabel!
    @IBOutlet weak var lblPressure: UILabel!
    @IBOutlet weak var lblHumidity: UILabel!
    var stringWors = String()
    var stringTitle = String()
    var servicelWeather = ServiceWeather()
    var currentWeatherCoreData = CurrenWeather()
    
    @IBOutlet weak var cancelButton: UIBarButtonItem! {
        didSet {
            cancelButton.action = #selector(dismissVC)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lblCityName.text = self.stringWors
        lblTitle.text = self.stringTitle
     //   lblTemperature.text = self.servicelWeather.currentTemp
      //  self.servicelWeather.delegate = self
        self.servicelWeather.getWatherCity(city: lblCityName.text!)
        lblDate.text = "Today is"

    }

    @IBAction func refreshWeather(_ sender: Any) {
        self.servicelWeather.delegate = self
        self.updateWeatherInfo()
        self.currentWeatherCoreData.searchUpdateRecordData(searchCity: lblCityName.text!)
    }
    
    @objc func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK : ServiceWeatherDelegate
    func updateWeatherInfo() {
        
        DispatchQueue.main.async {

            self.lblTemperature.text = self.servicelWeather.currentTemp
            // get main weather
            self.mainWeather.text = "\(self.servicelWeather.mainWeather!) - \(self.servicelWeather.mainDesription!)"
            //get temp kelvin
            self.lblTempKelvin.text = "\(self.servicelWeather.temperat!)K"
            //get pressure
            self.lblPressure.text = "\(self.servicelWeather.pressureCity!) hpa"
            //get Humidity
            self.lblHumidity.text = "\(self.servicelWeather.humidityCity!) %"
            // get icon
            let weatherIcon = self.servicelWeather.mainIcon
            print(weatherIcon!)
            let icon = self.servicelWeather.iconWeather(stringIcon: weatherIcon!)
            self.iconWeather.image = icon
            
        }
    }

}
