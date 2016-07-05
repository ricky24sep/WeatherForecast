//
//  NetworkManager.swift
//  WeatherForecast
//
//  Created by rikky.chavhan on 30/06/16.
//  Copyright © 2016 globallogic. All rights reserved.
//

import Foundation

class NetworkManager: NetworkApiHandler {
    
    var operationQueue : NSOperationQueue!
    
    struct Static {
        static var onceToken: dispatch_once_t = 0
        static var instance: NetworkManager? = nil
    }
    
    class func sharedInstance() -> NetworkManager {
        dispatch_once(&Static.onceToken) {
            Static.instance = NetworkManager()
        }
        return Static.instance!
    }
    
    override init(){
        super.init()
        operationQueue = NSOperationQueue()
    }
    
    deinit{
    }
    
    func getWeatherForecastForCity(value : AnyObject){
        
        var str = "http://api.openweathermap.org/data/2.5/forecast/daily?mode=json&units=metric&cnt=14&apiKey=d62c92d7e9a0df8794f801ef0505ca17"
        str += "&"+"q=\(value as! String)"
        NSLog("url string : \(str)")
        
        fetchDataFromServer(str, fetchSuccess: { (fetchResponseObj) in
            let oper = ParseDataOperation()
            oper.parseResponseData(fetchResponseObj as! NSData)
            self.operationQueue.addOperation(oper)
            })
        { (fetchError) in
            
        }
    }
    
    func getWeatherForecastForCurrentCity(parameters : NSDictionary){
        
        let str = "http://api.openweathermap.org/data/2.5/forecast/daily?lat=35&lon=139&cnt=14&apiKey=d62c92d7e9a0df8794f801ef0505ca17"
        fetchDataFromServer(str, fetchSuccess: { (fetchResponseObj) in
            let oper = ParseDataOperation()
            oper.parseResponseData(fetchResponseObj as! NSData)
            self.operationQueue.addOperation(oper)
            })
        { (fetchError) in
            
        }
    }

    
    
    
}
