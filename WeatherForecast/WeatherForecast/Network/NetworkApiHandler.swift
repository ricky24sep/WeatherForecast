//
//  NetworkApiHandler.swift
//  WeatherForecast
//
//  Created by rikky.chavhan on 30/06/16.
//  Copyright © 2016 globallogic. All rights reserved.
//

import Foundation

class NetworkApiHandler: NSObject {
    
    override init() {
        super.init()
    }
    
    deinit{
    }
    
    func fetchDataFromServer(urlStr : AnyObject, fetchSuccess: (fetchResponseObj: AnyObject) -> Void, fetchFailure: (fetchError: NSError) -> Void){
        
        let reqUrl = NSURL(string: urlStr as! String)
        let request = NSMutableURLRequest(URL: reqUrl!)
        request.HTTPMethod = "GET"
        request.timeoutInterval = 120
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) {
            (let data, let response, let error) in
            
            guard let _:NSData = data, let _:NSURLResponse = response where error == nil else {
                print("error : \(error?.description)")
                fetchFailure(fetchError: error!)
                return
            }
            print("response : \(response)")
            fetchSuccess(fetchResponseObj: data!)
        }
        task.resume()
    }
}