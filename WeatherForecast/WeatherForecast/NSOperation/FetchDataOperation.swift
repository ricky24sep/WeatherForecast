//
//  FetchDataOperation.swift
//  WeatherForecast
//
//  Created by rikky.chavhan on 30/06/16.
//  Copyright © 2016 globallogic. All rights reserved.
//

import Foundation

class FetchDataOperation: NSOperation {
    
    var cityName : String!
    
    override init() {
        super.init()
    }
    
    deinit{
    }
    
    func selectedCityName(name : String) {
        cityName = name.copy() as! String
    }
    
    override func main() {
        NetworkManager.sharedInstance().getWeatherForecastForCity(cityName)
    }
}
