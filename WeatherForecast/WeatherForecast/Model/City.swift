//
//  City.swift
//  
//
//  Created by rikky.chavhan on 01/07/16.
//
//

import Foundation
import CoreData


class City: NSManagedObject {

    class func entity() -> String {
        return  "City"
    }
    
    class func createOrUpdateObjectWithData(data : AnyObject, context : NSManagedObjectContext){
        
        guard let dataDict = data["city"] as? NSDictionary else{ return }
        
        var obj = DatabaseManager.sharedInstance().getExistingObjectModel(self.entity(), value: String(dataDict["id"]), param: "id1", managedObjectContext: context)
        
        if obj == nil{
            let entityDescription = NSEntityDescription.entityForName(self.entity(),
                           inManagedObjectContext: context)
            obj = City(entity: entityDescription!, insertIntoManagedObjectContext: context)
        }
        
        let cityObj = obj as! City
        
        if let idVal = dataDict["id"] as? String {
            cityObj.id1 = idVal
        }
        if let nameVal = dataDict["name"] as? String {
            cityObj.name = nameVal
        }
        if let countryVal = dataDict["country"] as? String {
            cityObj.country = countryVal
        }
        if let populationVal = dataDict["population"] as? Float {
            cityObj.population = NSNumber(float: populationVal)
        }
        
        guard let coordDict = dataDict["coord"] as? NSDictionary else
        {
            return
        }
        
        if let lonVal = coordDict["lon"] as? Float {
            cityObj.lon = NSNumber(float: lonVal)
        }
        if let latVal = coordDict["lat"] as? Float {
            cityObj.lat = NSNumber(float: latVal)
        }
        
        guard let listArray = data["list"] as? [NSDictionary] else
        {
            return
        }
        
        for listItem in listArray {
            Weather.createOrUpdateObjectWithData(listItem, relativeModel: cityObj, context: context)
        }
        
    }
}
