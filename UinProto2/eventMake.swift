//
//  eventMake.swift
//  UinProto2
//
//  Created by Kareem Dasilva on 1/9/15.
//  Copyright (c) 2015 Kareem Dasilva. All rights reserved.
//

import UIKit
import MapKit

class eventMake: UIViewController, UITextFieldDelegate {
    var dateTime = String()
    var dateStr = String()
    var orderDate = NSDate()
    var endDate = NSDate()
    var startTime = String()
    var endTime = String()
    var eventTitlePass = (String)()
    var eventLocation = ""
    var eventID = (String)()
    var userId = (String)()
    var eventDisplay = (String)()
    var lat = (CLLocationDegrees)()
    var long = (CLLocationDegrees)()
    var locations = CLLocation()
    var address = ""
    
    @IBOutlet var displayLocation: UILabel!
  
    
    @IBOutlet var eventAddress: UILabel!
    @IBOutlet var eventLocationDescription: UIButton!

    @IBOutlet var locationConfirm: UIImageView!
   
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
         self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }
    
    

    
    @IBOutlet var startTimeCheck: UIImageView!
    @IBOutlet var endTimeCheck: UIImageView!
    @IBOutlet var onCampusIcon: UIImageView!
    @IBOutlet var hasFoodIcon: UIImageView!
    @IBOutlet var isFreeIcon: UIImageView!
    @IBOutlet var oncampusSegement: UISegmentedControl!
    @IBOutlet var freeSegment: UISegmentedControl!
    @IBOutlet var foodSegement: UISegmentedControl!
    @IBOutlet var publicSegment: UISegmentedControl!
    @IBOutlet weak var eventTitle: UITextField!
    
    @IBAction func startAction(sender: AnyObject) {
        self.performSegueWithIdentifier("sendtodate", sender: self)
    }
    
    @IBAction func endAction(sender: AnyObject) {
        
        self.performSegueWithIdentifier("sendtodate", sender: self)
    }
  
    @IBOutlet var start: UIButton!
    @IBOutlet var onCampus: UISegmentedControl!
    @IBOutlet var end: UIButton!
    var eventPublic:Bool = true
    var onsite:Bool = true
    var food:Bool = true
    var paid:Bool = true
    
    @IBAction func createLocation(sender: AnyObject) {
       textFieldShouldReturn(eventTitle)
        self.performSegueWithIdentifier("toLocation", sender: self)
   
    }
    
 
    @IBAction func publicEvent(sender: UISegmentedControl) {
        
        println(eventPublic)
        switch sender.selectedSegmentIndex {
        case 0:
            eventPublic = true
             sender.tintColor = UIColor(red: 52.0/255.0, green: 127.0/255.0, blue: 191.0/255, alpha:1 ) // blue
        case 1:
            eventPublic = false
                sender.tintColor = UIColor(red: 254.0/255.0, green: 186.0/255.0, blue: 1.0/255, alpha:1 ) //Yelow
            
        default:
            eventPublic = true
           
            break;
        }  //Switch
    }
    
    @IBAction func location(sender: UISegmentedControl) {
        println(onsite)
        switch sender.selectedSegmentIndex {
        case 0:
            onsite = true
            onCampusIcon.image = UIImage(named: "onCampus.png")
            sender.tintColor = UIColor(red: 135.0/255.0, green: 84.0/255.0, blue: 194.0/255, alpha:1 ) //Purple
        case 1:
            onsite = false
            onCampusIcon.image = UIImage(named: "offCampus.png")
               sender.tintColor = UIColor(red: 165.0/255.0, green: 169.0/255.0, blue: 172.0/255, alpha:1 ) //Gray
        default:
            onsite = true
            break;
        }  //Switch
        
    }
    
    @IBAction func isFood(sender: UISegmentedControl) {
        println(food)
        switch sender.selectedSegmentIndex {
        case 0:
            food = true
            hasFoodIcon.image = UIImage(named: "yesFood.png")
            sender.tintColor = UIColor(red: 224.0/255.0, green: 69.0/255.0, blue: 69.0/255, alpha:1 ) //Red
            
        case 1:
            food = false
            hasFoodIcon.image = UIImage(named: "noFood.png")
              sender.tintColor = UIColor(red: 165.0/255.0, green: 169.0/255.0, blue: 172.0/255, alpha:1 ) //Gray
        default:
            food = true
            break;
        }  //Switch
    }
    
    @IBAction func isPaid(sender: UISegmentedControl) {
        println(paid)
        switch sender.selectedSegmentIndex {
        case 0:
            paid = true
            isFreeIcon.image = UIImage(named: "yesFree.png")
             sender.tintColor = UIColor(red: 93.0/255.0, green: 175.0/255.0, blue: 76.0/255, alpha:1 ) //Green
        case 1:
            paid = false
            isFreeIcon.image = UIImage(named: "noFree.png")
             sender.tintColor = UIColor(red: 165.0/255.0, green: 169.0/255.0, blue: 172.0/255, alpha:1 ) //Gray
        default:
            paid = true
            break;
        }  //Switch
        
    }
    
    func displayAlert(title:String, error:String) {
        
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        func preferredStatusBarStyle() -> UIStatusBarStyle {
            return UIStatusBarStyle.Default
        }
        
    }
    // Creates the event and adds to the calendar
    
    @IBAction func makeEvent(sender: AnyObject) {
        
       var geopoint = PFGeoPoint(location: locations)
        var userFollowers = [String]()
        var allError = ""
        
        if eventTitle.text == "" {
            
            allError = "Enter a Title for your Event"
            println(allError)
            
        }
        
            
        
        if orderDate2.compare(orderDate1) == NSComparisonResult.OrderedAscending  {
            allError = "Your end date is before your start date"
        }
        
        
        if eventLocation == ""{
            
            allError = "Enter a location for your Event"
            println(allError)
        }
        if address == ""{
            allError = "Please enter in an address"
        }
        //if locations == "" {
          //Find a  no value for NSobject
        //}
        
        if dateTime1 == "" {
            
            allError = "Enter a Start Time"
            
        }
        
        if dateTime2 == ""{
            allError = "Enter a End Time"
        }
        println(allError)

        if allError == "" {
            //If the user is editing the event
            if editing == true {
                var eventQue = PFQuery(className: "Event")
                eventQue.getObjectInBackgroundWithId(eventID, block: {
                    
                    (eventItem:PFObject!, error:NSError!) -> Void in
                    
                    if error == nil {
                        eventItem["address"] = self.address
                        eventItem["locationGeopoint"] = geopoint
                        eventItem["start"] = orderDate1
                        eventItem["end"] = orderDate2
                        eventItem["isPublic"] = self.eventPublic
                        eventItem["hasFood"] = self.food
                        eventItem["isFree"] = self.paid
                        eventItem["onCampus"] = self.onsite
                        eventItem["location"] = self.eventLocation
                        eventItem["title"] = self.eventTitle.text
                        eventItem["author"] = PFUser.currentUser().username
                        eventItem["authorID"] = PFUser.currentUser().objectId
                        eventItem["isDeleted"] = false
                        eventItem.saveInBackgroundWithBlock({
                            (success:Bool, error:NSError!) -> Void in
                            
                            if error == nil {
                                orderDate1 = NSDate()
                                orderDate2 = NSDate()
                                dateTime1 = String()
                                dateTime2 = String()
                                dateStr1 = String()
                                dateStr2 = String()
                                startString = String()
                                endString = String()
                          
                            }
                                self.performSegueWithIdentifier("eventback", sender: self)
                        })
                        //Queries al the people who added this event to calendar
                        var findPeople = PFQuery(className: "UserCalendar")
                        var collectedPeople = [String]()
                        //Checks collects all the user that have push enablded
                        var checkPushEnabled = PFUser.query()
                        checkPushEnabled.whereKey("pushEnabled", equalTo: true)
                        checkPushEnabled.whereKey("tempAccount", equalTo: false)
                        findPeople.whereKey("eventID", equalTo:self.eventID )
                        findPeople.whereKey("user", notEqualTo: PFUser.currentUser().username)
                        findPeople.whereKey("user", matchesKey: "username", inQuery: checkPushEnabled)
                        findPeople.findObjectsInBackgroundWithBlock({
                            (results:[AnyObject]!, Error:NSError!) -> Void in
                            
                            for object in results {
                                collectedPeople.append(object["user"] as!String)
                            }
                            var push =  PFPush()
                            let data = [
                                "alert" : "\(PFUser.currentUser().username) has edited the event '\(self.eventTitle.text)'",
                                "badge" : "Increment",
                                "sound" : "default"
                            ]
                            var pfque = PFInstallation.query()
                            println()
                            println(collectedPeople)
                            println()
                            pfque.whereKey("user", containedIn: collectedPeople) //Adds all the people who added your event
                            push.setQuery(pfque)
                            push.setData(data)
                            push.sendPushInBackgroundWithBlock({
                                // Notifies the people you edited your event
                                (success: Bool, pushError: NSError!) -> Void in
                                if pushError == nil {
                                    println("the push was sent")
                                } else {
                                    println("push was not sent")
                                }
                                var theMix = Mixpanel.sharedInstance()
                                theMix.track("Edited Event (EM)")
                            })
                        })
                        var notify = PFObject(className: "Notification")
                        notify["senderID"] = PFUser.currentUser().objectId
                        notify["receiverID"] = PFUser.currentUser().objectId
                        notify["sender"] = PFUser.currentUser().username
                        notify["receiver"] = PFUser.currentUser().username
                        notify["eventID"] = eventItem.objectId
                        notify["type"] =  "editedEvent"
                        notify.saveInBackgroundWithBlock({
                            (success:Bool, notifyError: NSError!) -> Void in
                            if notifyError == nil {
                                println("notifcation has been saved")
                            }
                            else {
                                println("fail")
                            }
                        })
                
                    }
                })
            }
            else {
                var event = PFObject(className: "Event")
                event["address"] = address
                event["locationGeopoint"] = geopoint
                event["start"] = orderDate1
                event["end"] = orderDate2
                event["isPublic"] = self.eventPublic
                event["hasFood"] = self.food
                event["isFree"] = self.paid
                event["onCampus"] = self.onsite
                event["location"] = self.eventLocation
                event["title"] = self.eventTitle.text
                event["author"] = PFUser.currentUser().username
                event["authorID"] = PFUser.currentUser().objectId
                event["isDeleted"] = false
                event.saveInBackgroundWithBlock{
                    
                    (success:Bool,eventError:NSError!) -> Void in
                    
                    if (eventError == nil){
                            var push =  PFPush()
                            let data = [
                                "alert" : "\(PFUser.currentUser().username) has created an event '\(self.eventTitle.text)'",
                                "badge" : "Increment",
                                "sound" : "default"
                            ]
                            push.setChannel(PFUser.currentUser().objectId)
                            push.setData(data)
                            push.sendPushInBackgroundWithBlock({
                            
                                (success: Bool, pushError: NSError!) -> Void in
                                if pushError == nil {
                                    
                                    println("the push was sent")
                                    
                                }
                                
                                var theMix = Mixpanel.sharedInstance()
                                theMix.track("Created Event (EM)")
                                
                            })

                        

                        var notify = PFObject(className: "Notification")
                        notify["senderID"] = PFUser.currentUser().objectId
                        notify["receiverID"] = PFUser.currentUser().objectId
                        notify["sender"] = PFUser.currentUser().username
                        notify["receiver"] = PFUser.currentUser().username
                        notify["eventID"] = event.objectId
                        notify["type"] =  "event"
                        notify.save()

                        orderDate1 = NSDate()
                        orderDate2 = NSDate()
                        dateTime1 = String()
                        dateTime2 = String()
                        dateStr1 = String()
                        dateStr2 = String()
                        startString = String()
                        endString = String()
                        self.performSegueWithIdentifier("eventback", sender: self)
                        println("it worked")
                        
                    } else {
                        println(eventError)
                    }
                }
            }
        }
        else {
            displayAlert("Error", error: allError)
        }
    }
    
    @IBAction func deleteEvent(sender: AnyObject) {
        
        var alert = UIAlertController(title: "Are you sure", message: "Do you want to delete this event", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Destructive, handler: { action in
            switch action.style{
            case .Destructive:
                var eventQue = PFQuery(className: "Event")
                eventQue.getObjectInBackgroundWithId(self.eventID, block: {
                    
                    (eventItem:PFObject!, error:NSError!) -> Void in
                    
                    if error == nil {
                        
                        var theMix = Mixpanel.sharedInstance()
                        theMix.track("Deleted Event (EM)")
                        var name = PFUser.currentUser().username
                        eventItem["isDeleted"] = true
                        eventItem.save()
                 
                        var findPeople = PFQuery(className: "UserCalendar")
                        var collectedPeople = [String]()
                        var checkPushEnabled = PFUser.query()
                        checkPushEnabled.whereKey("pushEnabled", equalTo: true)
                        checkPushEnabled.whereKey("tempAccount", equalTo: false)
                        findPeople.whereKey("eventID", equalTo:self.eventID )
                        findPeople.whereKey("user", notEqualTo: PFUser.currentUser().username)
                        findPeople.whereKey("user", matchesKey: "username", inQuery: checkPushEnabled)
                        findPeople.findObjectsInBackgroundWithBlock({
                            (results:[AnyObject]!, Error:NSError!) -> Void in
                            
                            for object in results {
                                collectedPeople.append(object["user"] as!String)
                            }
                            var push =  PFPush()
                            let data = [
                                "alert" : "\(PFUser.currentUser().username) has cancelled the event '\(self.eventTitle.text)'",
                                "badge" : "Increment",
                                "sound" : "default"
                            ]
                            var pfque = PFInstallation.query()
                            pfque.whereKey("user", containedIn: collectedPeople) //Adds all the people who added your event
                            push.setQuery(pfque)
                            push.setData(data)
                            push.sendPushInBackgroundWithBlock({
                                // Notifies the people you edited your event
                                (success: Bool, pushError: NSError!) -> Void in
                                if pushError == nil {
                                    println("the push was sent")
                                } else {
                                    println("push was not sent")
                                }
                            })
                            //Creates the notfication for delete event
                            var notify = PFObject(className: "Notification")
                            notify["senderID"] = PFUser.currentUser().objectId
                            notify["receiverID"] = PFUser.currentUser().objectId
                            notify["sender"] = PFUser.currentUser().username
                            notify["receiver"] = PFUser.currentUser().username
                            notify["eventID"] = self.eventID
                            notify["type"] =  "deleteEvent"
                            notify.saveInBackgroundWithBlock({
                                (success:Bool, notifyError: NSError!) -> Void in
                                if notifyError == nil {
                                    println("notifcation has been saved")
                                }
                                else {
                                    println("fail")
                                }
                            })
                        })
                      
                        self.performSegueWithIdentifier("eventback", sender: self)
                        
                    }
                })
            case .Cancel:
                println("cancel")
                
            case .Default:
                println("destructive")
            }
        }))
        
    }
    override func viewWillAppear(animated: Bool) {
        if eventLocation == "" {
            eventLocationDescription.setTitle("Location", forState: UIControlState.Normal)
            displayLocation.hidden = true
            eventAddress.hidden = true
             eventLocationDescription.setBackgroundImage(UIImage(named: "addLocation"), forState: UIControlState.Normal)
            locationConfirm.image = UIImage(named: "add")
        } else {
        
            displayLocation.hidden = false
           eventLocationDescription.setTitle("", forState: UIControlState.Normal)
            displayLocation.text = eventLocation
           
            if address != "" {
                eventAddress.hidden = false
                eventAddress.text = address
                locationConfirm.image = UIImage(named: "confirmed.png")
                eventLocationDescription.setBackgroundImage(UIImage(named: "addedLocation"), forState: UIControlState.Normal)
            }
        }
      
        if (startString == ""){
            start.setTitle("Start Time", forState: UIControlState.Normal)
            startTimeCheck.hidden = true
        }
        else {
            start.setTitle(startString, forState: UIControlState.Normal)
            startTimeCheck.hidden = false
            start.setTitleColor(UIColor(red: 52.0/255.0, green: 127.0/255.0, blue: 191.0/255, alpha:1), forState: UIControlState.Normal)
         
        }
        if (endString == "") {
            endTimeCheck.hidden = true
            end.setTitle("End Time", forState: UIControlState.Normal)
        }
        else {
            end.setTitle(endString, forState: UIControlState.Normal)
            endTimeCheck.hidden = false
              end.setTitleColor(UIColor(red: 52.0/255.0, green: 127.0/255.0, blue: 191.0/255, alpha:1), forState: UIControlState.Normal)
        }

    }


    override func viewDidLoad() {
        super.viewDidLoad()
        var theMix = Mixpanel.sharedInstance()
        theMix.track("Create Event Opened")
        theMix.flush()
        self.tabBarController?.navigationItem.hidesBackButton = false
        self.tabBarController?.tabBar.hidden = true
        if editing == false {
            
            self.navigationItem.rightBarButtonItem = nil
        }
        else {
            eventTitle.text = eventTitlePass
            eventLocationDescription.setTitle(eventLocation, forState: UIControlState.Normal)
            var checkPublicStatus = PFQuery(className: "Event")
            var status = checkPublicStatus.getObjectWithId(eventID)
            if status["isPublic"] as!Bool == true {
                publicSegment.selectedSegmentIndex = 0
            } else {
                publicSegment.selectedSegmentIndex = 1
                  publicSegment.tintColor = UIColor(red: 254.0/255.0, green: 186.0/255.0, blue: 1.0/255, alpha:1 ) //Yelow
            }
        }
   
        if food == true {
           
            foodSegement.selectedSegmentIndex = 0
            hasFoodIcon.image = UIImage(named: "yesFood.png")
        }
        else {
         
            foodSegement.selectedSegmentIndex = 1
            hasFoodIcon.image = UIImage(named: "noFood.png")
            foodSegement.tintColor = UIColor(red: 165.0/255.0, green: 169.0/255.0, blue: 172.0/255, alpha:1 ) //Gray
        }
        if paid == true {
            println("OK IT WOKRS")
             isFreeIcon.image = UIImage(named: "yesFree.png")
            freeSegment.selectedSegmentIndex = 0
        }
        else {
            println("PAID IS NOT TRUE")
            freeSegment.selectedSegmentIndex = 1
             isFreeIcon.image = UIImage(named: "noFree.png")
            freeSegment.tintColor = UIColor(red: 165.0/255.0, green: 169.0/255.0, blue: 172.0/255, alpha:1 ) //Gray
        }
        if onsite == true {
            println("OK IT WOKRS")
            oncampusSegement.selectedSegmentIndex = 0
            onCampusIcon.image = UIImage(named: "onCampus.png")
        }
        else {
            
            oncampusSegement.selectedSegmentIndex = 1
            onCampusIcon.image = UIImage(named: "offCampus.png")
            oncampusSegement.tintColor = UIColor(red: 165.0/255.0, green: 169.0/255.0, blue: 172.0/255, alpha:1 ) //Gray
        }
        
        if PFUser.currentUser() == nil{
            
            self.performSegueWithIdentifier("register", sender: self)
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func cancelToPlayersViewController(segue:UIStoryboardSegue) {
        
    }
    
    @IBAction func savePlayerDetail(segue:UIStoryboardSegue) {
    
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toLocation" {
            var locationView:eventLocationView = segue.destinationViewController as! eventLocationView
            locationView.passedDisplayLocation = eventLocation
        }
       
        
    }
  
}
