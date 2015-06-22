//
//  eventReview.swift
//  Uin
//
//  Created by Sir Lancelot on 6/15/15.
//  Copyright (c) 2015 Kareem Dasilva. All rights reserved.
//

import UIKit

    //First event screen
    class eventLanding: UIViewController {
        
        @IBOutlet weak var eventTitle: UITextField!
        @IBOutlet weak var eventDescription: UITextView!
        
        
        @IBAction func submitEvent(sender: AnyObject) {
            self.performSegueWithIdentifier("create1", sender: self)
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
        }
        override func didReceiveMemoryWarning() {
            
        }
    }
//Global variables that contain event details
var gTitle = (String)()
var gDescrption = (String)()
var gAddress = (String)()
var gGPS = (PFGeoPoint)()
var gLocation = (String)()
var gStart = (NSDate)()
var gEnd = (NSDate)()

class eventReview: UIViewController {
    
    //Checks if all event info is stored
    func validateEvent() {
        var error = ""
        if gTitle.isEmpty == true {
            error == "Please fill out an event title"
        }
        if gDescrption.isEmpty == true {
            error == "Please fill out an event description"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        
    }
}




