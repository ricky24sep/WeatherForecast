//
//  DatabaseManager.swift
//  WeatherForecast
//
//  Created by rikky.chavhan on 30/06/16.
//  Copyright © 2016 globallogic. All rights reserved.
//

import Foundation
import CoreData


class DatabaseManager: NSObject {
    
    struct Static {
        static var onceToken: dispatch_once_t = 0
        static var instance: DatabaseManager? = nil
    }
    
    class func sharedInstance() -> DatabaseManager {
        dispatch_once(&Static.onceToken) {
            Static.instance = DatabaseManager()
        }
        return Static.instance!
    }
    
    override init(){
        super.init()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.contextDidSaveContext(_:)), name: NSManagedObjectContextDidSaveNotification, object: nil)
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.globallogic.GoRssReader_Swift" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("WeatherForecast", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("WeatherForecast_db.sqlite")
        NSLog("document dirctory url : \(url)")
        
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    lazy var backgroundContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        
        let coordinator = self.persistentStoreCoordinator
        var backgroundContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        backgroundContext.persistentStoreCoordinator = coordinator
        return backgroundContext
    }()
    
    func saveContext (context: NSManagedObjectContext) {
        var error: NSError? = nil
        if context.hasChanges {
            do {
                try context.save()
            } catch let error1 as NSError {
                error = error1
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
    }
    
    func contextDidSaveContext(notification: NSNotification) {
        let sender = notification.object as! NSManagedObjectContext
        if sender === self.managedObjectContext {
            NSLog("******** Saved main Context in this thread")
            self.backgroundContext.performBlock {
                self.backgroundContext.mergeChangesFromContextDidSaveNotification(notification)
            }
        } else if sender === self.backgroundContext {
            NSLog("******** Saved background Context in this thread")
            self.managedObjectContext.performBlock {
                self.managedObjectContext.mergeChangesFromContextDidSaveNotification(notification)
            }
        }
    }
    
    func getExistingObjectModel(modelName : String, value : String, param : String, managedObjectContext : NSManagedObjectContext) -> AnyObject?{
        
        let entityDescription =
            NSEntityDescription.entityForName(modelName,
                                              inManagedObjectContext:managedObjectContext)
        
        let request = NSFetchRequest()
        request.entity = entityDescription
        request.predicate = NSPredicate(format: "(SELF.%K = %@)", param,value)
        
        do {
            let results = try managedObjectContext.executeFetchRequest(request)
            if results.count > 0 {
                return results[0]
            }
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
    
    func saveWeatherForecatsDataToDB(data : AnyObject, managedObjectContext : NSManagedObjectContext){
        
       City.createOrUpdateObjectWithData(data,
                context: managedObjectContext)
        saveContext(managedObjectContext)
        
        NSNotificationCenter.defaultCenter().postNotificationName(NotifConstants.kDataSavedSuccessfullyNotification, object: nil)
        
    }
    
    func getWeatherForecatsData() -> [AnyObject] {

        let request = NSFetchRequest()
        request.entity = NSEntityDescription.entityForName(
            City.entity(),inManagedObjectContext:managedObjectContext)

        var results : [AnyObject] = []
        do {
            results = try managedObjectContext.executeFetchRequest(request)
            if results.count > 0 {
                return results
            }
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
        return results
    }
}

