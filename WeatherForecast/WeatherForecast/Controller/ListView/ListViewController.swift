//
//  ViewController.swift
//  WeatherForecast
//
//  Created by rikky.chavhan on 30/06/16.
//  Copyright © 2016 globallogic. All rights reserved.
//

import UIKit
import CoreData
import MapKit
import SDWebImage

class ListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,NSFetchedResultsControllerDelegate {

    @IBOutlet weak var listTableView : UITableView?
    var listArray : NSMutableArray!
    let cellIdentifier = "listCell"
    let cellHeaderIdentifier = "listHeaderCell"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listArray = NSMutableArray()
        listTableView?.dataSource = self
        listTableView?.delegate = self
        
        listTableView?.registerNib(UINib.init(nibName: String(ListViewCell), bundle: nil), forCellReuseIdentifier: cellIdentifier)
        listTableView?.registerNib(UINib.init(nibName: String(ListHeaderView), bundle: nil),forHeaderFooterViewReuseIdentifier:cellHeaderIdentifier)
        
        self.fetchWeatherData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.fetchWeatherData), name:NotifConstants.kDataSavedSuccessfullyNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /* #pragma mark - Public Methods */
    
    @IBAction func currentCityButton(sender: UIButton) {
        
        let location = LocationManager.sharedInstance().currentLocation
        if location == nil {
            return
        }
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            if error != nil {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }
            
            if placemarks!.count > 0 {
                let placemark : CLPlacemark = placemarks![0]
                let currentCity : String = placemark.locality!
                
                dispatch_async(dispatch_get_main_queue(), {
                    let oper = FetchDataOperation()
                    oper.selectedCityName(currentCity)
                    NetworkManager.sharedInstance().operationQueue.addOperation(oper)
                })
            }
            else {
                print("Problem with the data received from geocoder")
            }
        })
    }
    
    func fetchWeatherData(){
       
        dispatch_async(dispatch_get_main_queue(), {
            self.listArray.removeAllObjects()
            let list =  DatabaseManager.sharedInstance().getWeatherForecatsData()
            self.listArray.addObjectsFromArray(list)
            self.listTableView?.reloadData()
        })
        
    }
    
    
    /*  #pragma mark - UITableViewDataSource */

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return listArray.count
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let obj = listArray[section] as! City
        let list : Array = obj.relWeather!.allObjects
        return  list.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let obj = listArray[section] as! City
        return obj.name
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ListViewCell
        
        let obj = listArray[indexPath.section] as! City
        let list : Array = obj.relWeather!.allObjects
        
        let weatherObj = list[indexPath.row] as! Weather
        cell.titleLabel?.text = weatherObj.main
        cell.descriptionLabel?.text = weatherObj.description1
        cell.dateLabel?.text = weatherObj.date1?.dateStringFromDate()
        cell.posterImageView?.sd_setImageWithURL(NSURL(string: weatherObj.icon!))
        return cell
    }

}

