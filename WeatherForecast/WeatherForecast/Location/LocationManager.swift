//
//  LocationManager.swift
//  WeatherForecast
//
//  Created by rikky.chavhan on 30/06/16.
//  Copyright © 2016 globallogic. All rights reserved.
//

import UIKit
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {

    var locationManager:CLLocationManager!
    var currentLocation:CLLocation!
    
    struct Static {
        static var onceToken: dispatch_once_t = 0
        static var instance: LocationManager? = nil
    }
    
    class func sharedInstance() -> LocationManager {
        dispatch_once(&Static.onceToken) {
            Static.instance = LocationManager()
        }
        return Static.instance!
    }
    
    override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.allowsBackgroundLocationUpdates = true
        
        self.startMonitoringlocation()
    }
    
    deinit {
        self.stopMonitoringlocation()
    }
    
    
    /* #pragma mark - Public Methods */
    
    func startMonitoringlocation(){
        
        if CLLocationManager.locationServicesEnabled() {
           
            if CLLocationManager.authorizationStatus() == .NotDetermined {
                locationManager.requestWhenInUseAuthorization()
            }
            else if CLLocationManager.authorizationStatus() == .Restricted || CLLocationManager.authorizationStatus() == .Denied {
                print("location authorized access denied or restricted")
            }
            else if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
                locationManager.startUpdatingLocation()
            }
        }
        else{
            print("location manager not enabled")
        }
    }
    
    func stopMonitoringlocation(){
        locationManager.stopUpdatingLocation()
    }
    
    
    /* #pragma mark - CLLocationManagerDelegate Methods */
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location : CLLocation = locations[0] else {
            print("updated location is nil")
            return
        }
        currentLocation = location
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
       print("location update failed")
    }
}
