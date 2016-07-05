//
//  City+CoreDataProperties.swift
//  
//
//  Created by rikky.chavhan on 01/07/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension City {

    @NSManaged var id1: String?
    @NSManaged var name: String?
    @NSManaged var country: String?
    @NSManaged var population: NSNumber?
    @NSManaged var lat: NSNumber?
    @NSManaged var lon: NSNumber?
    @NSManaged var relWeather: NSSet?

}
