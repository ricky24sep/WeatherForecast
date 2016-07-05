//
//  Weather.swift
//  
//
//  Created by rikky.chavhan on 01/07/16.
//
//

import Foundation
import CoreData


class Weather: NSManagedObject {

    class func entity() -> String {
        return "Weather"
    }

    
    class func createOrUpdateObjectWithData(dataDict : NSDictionary, relativeModel : NSManagedObject?, context : NSManagedObjectContext){
    
        let entityDescription = NSEntityDescription.entityForName(self.entity(),
            inManagedObjectContext: context)
        let weatherObj = Weather(entity: entityDescription!, insertIntoManagedObjectContext: context)
        if let pressueVal = dataDict["pressure"] as? Float {
           weatherObj.pressure = NSNumber(float: pressueVal)
        }
        if let humidityVal = dataDict["humidity"] as? Float {
            weatherObj.humidity = NSNumber(float: humidityVal)
        }
        if let speedVal = dataDict["speed"] as? Float {
            weatherObj.speed = NSNumber(float: speedVal)
        }
        if let degVal = dataDict["deg"] as? Float {
            weatherObj.deg = NSNumber(float: degVal)
        }
        if let cloudsVal = dataDict["clouds"] as? Float {
            weatherObj.clouds = NSNumber(float: cloudsVal)
        }
        if let rainVal = dataDict["rain"] as? Float {
            weatherObj.rain = NSNumber(float: rainVal)
        }
        
        if let dtVal = dataDict["dt"] as? Double {
            weatherObj.date1 = NSDate(timeIntervalSince1970: dtVal)
        }
        
        guard let listArray = dataDict["weather"] as? [NSDictionary] else
        {
            return
        }
        let listDict = listArray[0]
        //weatherObj.id1 = NSNumber(int: listDict["id"] as! Int32)
        
        if let mainVal = listDict["main"] as? String {
            weatherObj.main = mainVal
        }
        if let descriptionVal = listDict["description"] as? String {
            weatherObj.description1 = descriptionVal
        }
        if let iconVal = listDict["icon"] as? String {
            var imgStr = "http://openweathermap.org/img/w/"
            imgStr += iconVal
            imgStr += ".png"
            weatherObj.icon = imgStr
        }
    
        weatherObj.relCity = relativeModel as? City
    }
}
