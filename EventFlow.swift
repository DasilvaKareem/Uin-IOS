//
//  EventFlow.swift
//  Uin
//
//  Created by Kareem Dasilva on 7/23/15.
//  Copyright (c) 2015 Kareem Dasilva. All rights reserved.
//

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
  
    
    @IBOutlet weak var eventDescription: UITextField!
    
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
var firstIcon = (Int)()
var secondIcon = (Int)()
var thirdIcon = (Int)()

class eventReview: UIViewController {
    
    //Labels
    
    
    @IBOutlet weak var eTitle: UILabel!
    @IBOutlet weak var eDescription: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBAction func changeTitle(sender: AnyObject) {
        self.performSegueWithIdentifier("changeTitleDescription", sender: self)
    }
    @IBAction func changeAddressLocation(sender: AnyObject) {
        self.performSegueWithIdentifier("changeAddressLocation", sender: self)
    }
    
    @IBAction func changeStartEndTime(sender: AnyObject) {
        self.performSegueWithIdentifier("changeStartEndTime", sender: self)
    }
    @IBAction func changeTags(sender: AnyObject) {
        self.performSegueWithIdentifier("changeTags", sender: self)
    }
    
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
        start.text = dateTimeformat.stringFromDate(gStart)
        end.text = dateTimeformat.stringFromDate(gEnd)
        println(firstIcon)
        println(secondIcon)
        println(thirdIcon)
        
    }
    
    func createEvent(){
        
        var event = PFObject(className: "Event")
        event["title"] = gTitle
        event["description"] = gDescrption
        event["address"] = gAddress
        event["author"] = PFUser.currentUser().username
        event["start"] = gStart
        event["end"] = gEnd
        event["isDeleted"] = false
        event["location"] = gLocation
        event["isPublic"] = true
        event["tag1"] = firstIcon
        event["tag2"] = secondIcon
        event["tag3"] = thirdIcon
        event.saveInBackgroundWithBlock({
            (success:Bool , error:NSError!)-> Void in
            let alertStartError = UIAlertView()
            alertStartError.title = "Error"
            alertStartError.message = "You need to create a start date."
            alertStartError.addButtonWithTitle("Dismiss")
            if (self.start.text?.isEmpty != nil) {
                alertStartError.show()
            } else {
                //do nothing
            }
            let alertEndError = UIAlertView()
            alertEndError.title = "Error"
            alertEndError.message = "You need to create an end date."
            alertEndError.addButtonWithTitle("Dismiss")
            if (self.end.text?.isEmpty != nil) {
                alertEndError.show()
            } else {
                //do nothing
            }

            if error == nil {
                print("Event is made")
            } else {
                print("Event was not made")
            }
        })
            }
    
    
    @IBAction func submitEvent(sender: AnyObject) {
        createEvent()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        displayInfo()
    }
    
    override func didReceiveMemoryWarning() {
        
    }
}