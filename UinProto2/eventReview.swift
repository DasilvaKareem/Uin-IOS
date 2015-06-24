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
            //Checks if event descritpion and title are empty
            if eventTitle.text.isEmpty {
                
            } else {
                gTitle = eventTitle.text
                gDescrption = eventDescription.text
                self.performSegueWithIdentifier("create1", sender: self)
            
            }
           
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
    
    //Labels
   
 
    @IBOutlet weak var eTitle: UILabel!
    @IBOutlet weak var eDescription: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var location: UILabel!
    
    @IBOutlet weak var start: UILabel!
    
    @IBOutlet weak var end: UILabel!
    
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
    func displayInfo(){
        eTitle.text = gTitle
        eDescription.text = gDescrption
        address.text = gAddress
        location.text = gLocation
        //convert NSDate to strings
        var dateTimeformat = NSDateFormatter()
        dateTimeformat.dateStyle = NSDateFormatterStyle.MediumStyle
        start.text =  dateTimeformat.stringFromDate(gStart)
        end.text = dateTimeformat.stringFromDate(gEnd)
      
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        displayInfo()
    }
    
    override func didReceiveMemoryWarning() {
        
    }
}




