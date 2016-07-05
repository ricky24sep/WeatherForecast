//
//  AddCityViewController.swift
//  WeatherForecast
//
//  Created by rikky.chavhan on 30/06/16.
//  Copyright © 2016 globallogic. All rights reserved.
//

import UIKit

class AddCityViewController: UIViewController {

    @IBOutlet var containerView : UIView?
    @IBOutlet var cityTextFeild : UITextField!
    @IBOutlet var addButton : UIButton?
    @IBOutlet var closeButton : UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.customizeView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func customizeView() {
        
        self.view.bringSubviewToFront(containerView!)
        containerView?.layer.borderColor = UIColor.lightGrayColor().CGColor
        containerView?.layer.borderWidth = 1.0
        //containerView?.layer.cornerRadius = 7.0
        //containerView?.layer.masksToBounds = true
        
        cityTextFeild?.layer.borderColor = UIColor.lightGrayColor().CGColor
        cityTextFeild?.layer.borderWidth = 1.0
        
        addButton?.layer.cornerRadius = 5.0
        addButton?.layer.masksToBounds = true
    }
    
    @IBAction func addButton(sender: UIButton) {
        
        let oper = FetchDataOperation()
        oper.selectedCityName((cityTextFeild.text)!)
        NetworkManager.sharedInstance().operationQueue.addOperation(oper)
        
        self.dismissViewController()
    }
    
    @IBAction func closeButton(sender: UIButton) {
        self.dismissViewController()
    }
    
    func dismissViewController(){
        self.dismissViewControllerAnimated(true) {
            print("view controller dismiss")
        }
    }


}
