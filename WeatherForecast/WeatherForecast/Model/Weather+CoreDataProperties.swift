//
//  Weather+CoreDataProperties.swift
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

extension Weather {

    @NSManaged var date1: NSDate?
    @NSManaged var pressure: NSNumber?
    @NSManaged var humidity: NSNumber?
    @NSManaged var speed: NSNumber?
    @NSManaged var deg: NSNumber?
    @NSManaged var clouds: NSNumber?
    @NSManaged var rain: NSNumber?
    @NSManaged var id1: NSNumber?
    @NSManaged var main: String?
    @NSManaged var description1: String?
    @NSManaged var icon: String?
    @NSManaged var relCity: City?

}
