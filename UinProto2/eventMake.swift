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
    var lat = (CLLocationDegrees)()
    var long = (CLLocationDegrees)()
    var locations = CLLocation()
    var geopoint = PFGeoPoint()

    var address = ""
    var channel = ["xOI5cjHcDo"]
    
    @IBOutlet var onCampusButton: UIButton!
    @IBOutlet var isFreeButton: UIButton!
    @IBOutlet var hasFoodButton: UIButton!
    
    @IBOutlet var onCampusText: UILabel!
    @IBOutlet var isFreeText: UILabel!
    @IBOutlet var hasFoodText: UILabel!
    
    
    var onsite:Bool = true
    var food:Bool = true
    var paid:Bool = true
    @IBAction func onCampusSwitch(sender: AnyObject) {
        if self.onsite == true {
            self.onsite = false
          
            onCampusButton.setBackgroundImage(UIImage(named: "emNoLocation"), forState: UIControlState.Normal)
            onCampusText.text = "Off Campus"
            onCampusText.textColor = UIColor(red: 165.0/255.0, green: 169.0/255.0, blue: 172.0/255, alpha:1 ) //Gray
            println(self.onsite)
        } else {
            self.onsite = true
                 onCampusButton.setBackgroundImage(UIImage(named: "emYesLocation"), forState: UIControlState.Normal)
            onCampusText.text = "On Campus"
            onCampusText.textColor =  UIColor(red: 135.0/255.0, green: 84.0/255.0, blue: 194.0/255, alpha:1 ) //Purple
            println(self.onsite)
        }
    }
    
    @IBAction func isFreeSwitch(sender: AnyObject) {
        if self.paid == true {
            self.paid = false
            isFreeButton.setBackgroundImage(UIImage(named: "noFree.png"), forState: UIControlState.Normal)
            isFreeText.text = "Not Free"
            isFreeText.textColor = UIColor(red: 165.0/255.0, green: 169.0/255.0, blue: 172.0/255, alpha:1 ) //Gray
            
        } else {
            self.paid = true
            isFreeButton.setBackgroundImage(UIImage(named: "yesFree.png"), forState: UIControlState.Normal)
            isFreeText.text = "Free"
            isFreeText.textColor = UIColor(red: 93.0/255.0, green: 175.0/255.0, blue: 76.0/255, alpha:1) //Green
        }
    }
    
    @IBAction func hasFoodSwitch(sender: AnyObject) {
        if self.food == true {
            self.food = false
            hasFoodButton.setBackgroundImage(UIImage(named: "emNoFood"), forState: UIControlState.Normal)
            hasFoodText.text = "No Food"
            hasFoodText.textColor = UIColor(red: 165.0/255.0, green: 169.0/255.0, blue: 172.0/255, alpha:1 ) //Gray
        } else {
            self.food = true
            hasFoodButton.setBackgroundImage(UIImage(named: "emYesFood"), forState: UIControlState.Normal)
            hasFoodText.text = "Food"
            hasFoodText.textColor = UIColor(red: 224.0/255.0, green: 69.0/255.0, blue: 69.0/255, alpha:1 ) //Red
        }
    }
    
    @IBOutlet var displayLocation: UILabel!
    @IBOutlet var eventDescription: UITextView!
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
        
        if orderDate1 == "" {
            
            allError = "Enter a Start Date"
            
        }
        
        if orderDate2 == ""{
            allError = "Enter a End Date"
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
                        eventItem["locationGeopoint"] = self.geopoint
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
                        eventItem["channels"] = self.channel
                        eventItem["inLocalFeed"] = true
                        eventItem["description"] = self.eventDescription.text
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
                            
                        })
                        //Adds the event to channels it is asccoiated with
                     
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
                    self.performSegueWithIdentifier("eventback", sender: self)
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
                event["channels"] = self.channel
                event["description"] = self.eventDescription.text
                event["inLocalFeed"] = true
                event.saveInBackgroundWithBlock{
                    
                    (success:Bool,eventError:NSError!) -> Void in
                    
                    if (eventError == nil){
                        //Adds the event to channels it is asccoiated with
                        var channelSelect = PFObject(className: "ChannelEvent")
                            channelSelect["eventID"] = event.objectId
                            channelSelect["channelID"] = self.channel
                            channelSelect.saveInBackgroundWithBlock({
                                (success: Bool, error: NSError!) -> Void in
                                if error == nil {
                                    println("Channles selceted are \(self.channel)")
                                } else {
                                    println(error.debugDescription)
                                    println("Error was found selecting channels")
                                }
                            })
                        
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
    /*
        Setups the date and location of the event
    */
    func setupDate(){
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
    //Se\tups the icons on editing the event
    func setupBooleans(){
        if food == true {
            
            hasFoodText.text = "Food"
            hasFoodText.textColor = UIColor(red: 224.0/255.0, green: 69.0/255.0, blue: 69.0/255, alpha:1 ) //Red
            hasFoodButton.setBackgroundImage(UIImage(named: "yesFood.png"), forState: UIControlState.Normal)
        }
        else {
            
            hasFoodText.text = "No Food"
            hasFoodText.textColor = UIColor(red: 165.0/255.0, green: 169.0/255.0, blue: 172.0/255, alpha:1 ) //Gray
            hasFoodButton.setBackgroundImage(UIImage(named: "noFood.png"), forState: UIControlState.Normal)
            
        }
        if paid == true {
            isFreeText.text = "Free"
            isFreeText.textColor = UIColor(red: 93.0/255.0, green: 175.0/255.0, blue: 76.0/255, alpha:1) //Green
            isFreeButton.setBackgroundImage(UIImage(named: "yesFree.png"), forState: UIControlState.Normal)
        }
        else {
            isFreeText.text = "Not Free"
            isFreeText.textColor = UIColor(red: 165.0/255.0, green: 169.0/255.0, blue: 172.0/255, alpha:1 ) //Gray
            isFreeButton.setBackgroundImage(UIImage(named: "noFree.png"), forState: UIControlState.Normal)
        }
        if onsite == true {
            println("OK IT WOKRS")
            onCampusText.text = "On Campus"
            onCampusText.textColor =  UIColor(red: 135.0/255.0, green: 84.0/255.0, blue: 194.0/255, alpha:1 ) //Purple
            onCampusButton.setBackgroundImage(UIImage(named: "onCampus.png"), forState: UIControlState.Normal)
            
        }
        else {
            
            
            onCampusButton.setBackgroundImage(UIImage(named: "offCampus.png"), forState: UIControlState.Normal)
            onCampusText.text = "Off Campus"
            onCampusText.textColor = UIColor(red: 165.0/255.0, green: 169.0/255.0, blue: 172.0/255, alpha:1 ) //Gray
        }
    }
    override func viewWillAppear(animated: Bool) {
            setupDate()
        setupBooleans()
        if editing == false {
                  geopoint = PFGeoPoint(location: locations)
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
            //Set event data to event creation
            var eventQuery = PFQuery(className: "Event")
            eventQuery.getObjectInBackgroundWithId(eventID, block: {
                (object:PFObject!, error:NSError!) -> Void in
                
                self.eventTitle.text = object["title"] as! String //Sets the title
                self.eventDescription.text = object["description"] as! String //Sets the Descriptions
                self.address = object["address"] as! String //sets the address
                self.eventLocation = object["location"] as! String
                self.food = object["hasFood"] as! Bool
                self.paid = object["isFree"] as! Bool
                self.onsite = object["onCampus"] as! Bool
                orderDate1 = object["start"] as! NSDate
                orderDate2 = object["end"] as! NSDate
                //Convert date into an String for start time and end time
                var dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "MMM. dd, yyyy - h:mm a"
                startString = dateFormatter.stringFromDate(object["start"] as! NSDate)
                endString = dateFormatter.stringFromDate(object["end"] as! NSDate)
                self.geopoint = object["locationGeopoint"] as! PFGeoPoint
                if object["isPublic"] as!Bool == true {
                    self.eventPublic = true
                    self.publicSegment.selectedSegmentIndex = 0
                } else {
                    self.eventPublic = false
                    self.publicSegment.selectedSegmentIndex = 1
                    self.publicSegment.tintColor = UIColor(red: 254.0/255.0, green: 186.0/255.0, blue: 1.0/255, alpha:1 ) //Yelow
                }
                self.setupDate()
                self.setupBooleans()
                
            
            })
      
        
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
