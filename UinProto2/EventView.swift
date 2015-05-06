//
//  postEvent.swift
//  UinProto2
//
//  Created by Kareem Dasilva on 1/26/15.
//  Copyright (c) 2015 Kareem Dasilva. All rights reserved.
//

import UIKit
import EventKit

class postEvent: UIViewController {
    
    @IBOutlet var eventDescription: UILabel!
    @IBOutlet var calendarCount: UILabel!
    @IBOutlet var peopleView: UIImageView!
    @IBOutlet weak var foodIcon: UILabel!
    @IBOutlet weak var freeIcon: UILabel!
    @IBOutlet weak var onCampusIcon: UILabel!
    @IBOutlet var locationTitle: UILabel!
    @IBOutlet var dateTitle: UILabel!
    
    @IBOutlet var imageShower: UIButton!
    @IBOutlet weak var picture: UIImageView!
    var image = (UIImage)()
  
    @IBOutlet var location: UILabel!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet var startTime: UILabel!
    @IBOutlet var endTime: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var isFood: UIImageView!
    @IBOutlet weak var username: UIButton!
    @IBOutlet weak var isSite: UIImageView!
    @IBOutlet weak var isPaid: UIImageView!
    @IBAction func gotoProfile(sender: AnyObject) {
        if PFUser.currentUser().objectId != userId {
            self.performSegueWithIdentifier("gotoprofile", sender: self)
        } else {
            self.performSegueWithIdentifier("editEvent", sender: self)
        }
        
        
    }
    
    @IBOutlet var theeditButton: UIBarButtonItem!
    var alertTime:NSTimeInterval = -6000
    var profileEditing = false
    var address = String()
    var users = String()
    var storeTitle = String()
    var storeLocation = String()
    var storeStartTime = String()
    var storeEndTime = String()
    var storeEndDate = String()
    var storeDate = String()
    var storeSum = String()
    var data = Int()
    var onsite = Bool()
    var food = Bool()
    var cost = Bool()
    var storeStartDate = NSDate()
    var endStoreDate = NSDate()
    var eventId = String()
    var localStart = String()
    var localEnd = String()
    var userId = String()
    var eventDescriptionHolder = String()
    var searchEvent = false
    var imageFile = (PFFile)()
    var startDate = (String)()
    var endDate = (String)()
    func checkevent(){
        var minique = PFQuery(className: "UserCalendar")
        minique.whereKey("user", equalTo: PFUser.currentUser().username)
       
        minique.whereKey("eventID", equalTo: eventId)
        
        minique.getFirstObjectInBackgroundWithBlock{
            
            (results:PFObject!, error: NSError!) -> Void in
            
            if error == nil {
                self.longBar.setImage(UIImage(named: "addedToCalendarBig.png"), forState: UIControlState.Normal)
               
                self.calendarCount.textColor = UIColor(red: 52.0/255.0, green: 127.0/255.0, blue: 191.0/255, alpha:1) //blue color
            }   else {
                self.longBar.setImage(UIImage(named: "addToCalendarBig.png"), forState: UIControlState.Normal)
             
                self.calendarCount.textColor = UIColor(red: 254.0/255.0, green: 186.0/255.0, blue: 1.0/255, alpha:1 ) //yellow color
            }
        }
        getCount()
    }
    //Gets the amount of people added to calendar
    func getCount() {
        var minique2 = PFQuery(className: "UserCalendar")
        minique2.whereKey("eventID", equalTo: eventId)
        var goingCount = minique2.countObjects()
        self.calendarCount.text = String(goingCount)
    }
    //Queries from object ID

    override func viewWillAppear(animated: Bool) {
      
        if profileEditing == false {
            navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navBarBackground.png"), forBarMetrics: UIBarMetrics.Default)
            // Changes text color on navbar
            var nav = self.navigationController?.navigationBar
            nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()];
        }
    }

    func getEvents() {
       var getEvents = PFQuery(className: "Event")
        getEvents.getObjectInBackgroundWithId(eventId, block: {
            (result: PFObject!, error: NSError!) -> Void in
            if error == nil {
                println(result)
                var dateFormatter = NSDateFormatter()
                dateFormatter.locale = NSLocale.currentLocale() // Gets current locale and switches
                dateFormatter.dateFormat = "MMM. dd, yyyy - h:mm a"
                self.startDate = dateFormatter.stringFromDate(result["start"] as!NSDate) // Creates date
                self.endDate = dateFormatter.stringFromDate(result["end"] as!NSDate) // Creates date
                

                if result["picture"] == nil {
                    self.imageShower.removeFromSuperview()
                } else {
                    self.imageShower.superview
                    self.imageFile = result["picture"] as! PFFile
                    self.imageFile.getDataInBackgroundWithBlock({
                        (imageData: NSData!, error: NSError!) -> Void in
                        if error == nil {
                            self.image = UIImage(data: imageData)!
                            self.picture.image = UIImage(data: imageData)!
                            
                            
                        } else {
                            println(error)
                        }
                    })
                }
          
                self.users = result["author"] as!String!
                self.userId = result["authorID"] as!String!
                self.address = result["address"] as!String!
                self.storeLocation = result["location"] as!String!
                self.location.text = result["location"] as!String!
                self.eventTitle.text = result["title"] as!String!
                self.storeTitle = result["title"] as!String!
                self.date.text = self.startDate
                self.onsite = result["onCampus"] as!Bool
                self.cost = result["isFree"] as!Bool
                self.food = result["hasFood"] as!Bool
                self.eventDescription.text = result["description"] as! String
                
               
                self.eventId = result.objectId
                self.putIcons()
            }
        })
    }
    override func viewDidAppear(animated: Bool) {
     
    }
    
    override func viewDidLoad() {
        
        var theMix = Mixpanel.sharedInstance()
        theMix.track("Event View Opened")
        theMix.flush()
        super.viewDidLoad()
        
        if users == PFUser.currentUser().username{
            self.navigationItem.rightBarButtonItem?.title = "Edit"
        } else {
            self.navigationItem.rightBarButtonItem?.title = self.users
        }
        self.tabBarController?.tabBar.hidden = true
        if profileEditing == true {
        
            navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navBarBackground.png"), forBarMetrics: UIBarMetrics.Default)
            // Changes text color on navbar
            var nav = self.navigationController?.navigationBar
            nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()];
            
        } else {
            
            navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navBarBackground.png"), forBarMetrics: UIBarMetrics.Default)
            // Changes text color on navbar
            var nav = self.navigationController?.navigationBar
            nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()];
        }
        if searchEvent == true {
            getEvents()
         
            
        } else {
            getEvents()
         
            
        }
    
        
        checkevent()
        if PFUser.currentUser().username == users {
           
        }
    }
    
    @IBAction func eventShare(sender: AnyObject) {
        let textToShare = "Check out '\(storeTitle)' hosted by '\(users)' at '\(self.storeLocation)' on Uin! " + "iOS: http://apple.co/1G2pLXs " + "Android: http://bit.ly/1NwYAD9"
    
            let objectsToShare = [textToShare]
            let poop = UIActivityTypePostToFacebook
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            self.presentViewController(activityVC, animated: true, completion: nil)
        
    }
    @IBAction func changeForm(sender: AnyObject) {
      
      
    
    }
    func displayAlert(title:String, error:String) {
        
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
        func preferredStatusBarStyle() -> UIStatusBarStyle {
            return UIStatusBarStyle.Default
        }
        
    }
    //Adds the event to calenar and creats a notifcations,push, and changes the button itself
    @IBAction func addtocalendar(sender: AnyObject) {
        
        var que = PFQuery(className: "UserCalendar")
        que.whereKey("user", equalTo: PFUser.currentUser().username)
        que.whereKey("author", equalTo: users)
        que.whereKey("eventID", equalTo:eventId)
        que.getFirstObjectInBackgroundWithBlock({
            
            (results:PFObject!, queerror: NSError!) -> Void in
            
            if queerror == nil {
              results.delete()
                self.getCount()
                self.longBar.setImage(UIImage(named: "addToCalendarBig.png"), forState: UIControlState.Normal)
               
                self.calendarCount.textColor = UIColor(red: 254.0/255.0, green: 186.0/255.0, blue: 1.0/255, alpha:1 ) //yellow color
                if results != nil {
            var eventStore : EKEventStore = EKEventStore()
            eventStore.requestAccessToEntityType(EKEntityTypeEvent, completion: {
                
                granted, error in
                if (granted) && (error == nil) {
                    println("granted \(granted)")
                    println("error  \(error)")
                    var hosted = "Hosted by \(self.users)"
                    var event:EKEvent = EKEvent(eventStore: eventStore)
                    event.title = self.storeTitle
                    
                    event.startDate = self.storeStartDate
                    event.endDate = self.endStoreDate
                    event.notes = hosted
                    event.location = self.storeLocation
                    event.calendar = eventStore.defaultCalendarForNewEvents
                }
            })
                    var predicate2 = eventStore.predicateForEventsWithStartDate(self.storeStartDate, endDate: self.endStoreDate, calendars:nil)
                    var eV = eventStore.eventsMatchingPredicate(predicate2) as! [EKEvent]!
                    println("Result is there")
                    if eV != nil {

                        println("EV is not nil")
                        for i in eV {
                            println("\(i.title) this is the i.title")
                            println(self.storeTitle)
                            if i.title == self.storeTitle  {
                               
                                println("removed")
                                var theMix = Mixpanel.sharedInstance()
                                theMix.track("Removed from Calendar (EV)")
                                theMix.flush()
                                eventStore.removeEvent(i, span: EKSpanThisEvent, error: nil)
                            }
                        }
                    }
                }
            }
            
            else {
                var going = PFObject(className: "UserCalendar")
                going["user"] = PFUser.currentUser().username
                going["userID"] = PFUser.currentUser().objectId
                going["event"] = self.storeTitle
                going["author"] = self.users
                going["eventID"] = self.eventId
                going.saveInBackgroundWithBlock{
                    
                    (succeded:Bool, savError:NSError!) -> Void in
                    
                    if savError == nil {
                        self.getCount()
                        println("the user is going to the event")
                        self.longBar.setImage(UIImage(named: "addedToCalendarBig.png"), forState: UIControlState.Normal)
            
                        self.calendarCount.textColor = UIColor(red: 52.0/255.0, green: 127.0/255.0, blue: 191.0/255, alpha:1 ) //blue color
                        
                    }
                }
          
                var eventStore : EKEventStore = EKEventStore()
                eventStore.requestAccessToEntityType(EKEntityTypeEvent, completion: {
                    
                    granted, error in
                    if (granted) && (error == nil) {
                 
                        println("granted \(granted)")
                        println("error  \(error)")
                        var hosted = "Hosted by \(self.users)"
                        var event:EKEvent = EKEvent(eventStore: eventStore)
                        var alarm = EKAlarm(relativeOffset: self.alertTime)
                        event.addAlarm(alarm)
                        event.title = self.storeTitle
                        event.startDate = self.storeStartDate
                        event.endDate = self.endStoreDate
                        event.notes = hosted
                        event.location = self.storeLocation
                        event.calendar = eventStore.defaultCalendarForNewEvents
                        eventStore.saveEvent(event, span: EKSpanThisEvent, error: nil)
                        var theMix = Mixpanel.sharedInstance()
                        theMix.track("Added to Calendar (EV)")
                        theMix.flush()
                        println("saved")
                    
                    }
                })
                
                if self.users != PFUser.currentUser().username {
                    var notify = PFObject(className: "Notification")
                    notify["senderID"] = PFUser.currentUser().objectId
                    notify["sender"] = PFUser.currentUser().username
                    notify["receiverID"] =  self.userId
                    notify["receiver"] = self.users
                    notify["type"] =  "calendar"
                    notify.saveInBackgroundWithBlock({
                        (success:Bool, notifyError: NSError!) -> Void in
                        
                        if notifyError == nil {
                            
                            println("notifcation has been saved")
                            
                        }
                        else{
                            println(notifyError)
                        }
                    })
                    var push = PFPush()
                    var pfque = PFInstallation.query()
                    pfque.whereKey("user", equalTo: self.users)
                    push.setQuery(pfque)
                    if PFUser.currentUser()["tempAccounts"] as!Bool == true {
                        push.setMessage("Someone has added your event to their calendar")
                    } else {
                           push.setMessage("\(PFUser.currentUser().username) has added your event to their calendar")
                    }
                    push.sendPushInBackgroundWithBlock({
                        
                        (success:Bool, pushError: NSError!) -> Void in
                        if pushError == nil {
                            println("The push was sent")
                        }
                    })
                }
             
            }
        })
    }
    // Switch display location with the real addrss
    @IBAction func switchAddress(sender: AnyObject) {
        if address == storeLocation {
            address = address + " (address)"
            storeLocation = storeLocation + " (location)"
            if location.text == storeLocation {
                location.text = address
                locationTitle.text = "address"
            } else {
                location.text = storeLocation
                locationTitle.text = "location"
            }
        } else {
            if location.text == storeLocation {
                location.text = address
                locationTitle.text = "address"
            } else {
                location.text = storeLocation
                locationTitle.text = "location"
            }
        }
       
    }
    
    // Switch start time with the end time
    @IBAction func switchDates(sender: UIButton) {
        if self.startDate == self.endDate {
            self.dateTitle.text = "starts at and ends at"
        } else {
            if self.date.text == self.startDate {
                self.date.text = self.endDate
                dateTitle.text = "ends at"
            } else {
                self.date.text = self.startDate
                dateTitle.text = "starts at"
            }
        }
      
       
    }
    
    @IBOutlet var longBar: UIButton!
    
    func putIcons(){
        
        if  onsite == true {
            isSite.image = UIImage(named: "onCampus.png")
            onCampusIcon.text = "On-Campus"
            onCampusIcon.textColor = UIColor.darkGrayColor()
        }
        else{
            isSite.image = UIImage(named: "offCampus.png")
            onCampusIcon.text = "Off-Campus"
            onCampusIcon.textColor = UIColor.lightGrayColor()
        }
        
        if food == true {
            isFood.image = UIImage(named: "yesFood.png")
            foodIcon.text = "Food"
            foodIcon.textColor = UIColor.darkGrayColor()
        }
        else{
            isFood.image = UIImage(named: "noFood.png")
            foodIcon.text = "No Food"
            foodIcon.textColor = UIColor.lightGrayColor()
        }
        if cost == true {
            isPaid.image = UIImage(named: "yesFree.png")
            freeIcon.text = "Free"
            freeIcon.textColor = UIColor.darkGrayColor()
        }
        else{
            isPaid.image = UIImage(named: "noFree.png")
            freeIcon.text = "Not Free"
            freeIcon.textColor = UIColor.lightGrayColor()
        }
    }
    override func prepareForSegue(segue:UIStoryboardSegue, sender: AnyObject?){
        
        if segue.identifier == "gotoprofile" {
            var theMix = Mixpanel.sharedInstance()
            theMix.track("Tap Username (EV)")
            theMix.flush()
            var theotherprofile:userprofile = segue.destinationViewController as! userprofile
            theotherprofile.theUser = users
            theotherprofile.userId = userId
        }
        if segue.identifier == "editEvent" {
            var theMix = Mixpanel.sharedInstance()
            theMix.track("Tap Edit (EV)")
            theMix.flush()
            var editEvent:eventMake = segue.destinationViewController as! eventMake
            editEvent.editing = true
            editEvent.eventID = eventId
        }
        if segue.identifier == "imagePreview" {
            var theMix = Mixpanel.sharedInstance()
            theMix.track("Tap image Preview (EV)")
            theMix.flush()
            var imageView:imagePreview = segue.destinationViewController as! imagePreview
            imageView.eventID = self.eventId
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
class imagePreview: UIViewController {
    var eventID = (String)()
    var imageFile = (PFFile)()
    @IBOutlet var eventPicture: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
      
        var getImage = PFQuery(className: "Event")
        getImage.getObjectInBackgroundWithId(eventID, block: {
            (object:PFObject!, error:NSError!) -> Void in
            if error == nil {
                self.imageFile = object["picture"] as! PFFile
                self.imageFile.getDataInBackgroundWithBlock({
                    (imageData: NSData!, error: NSError!) -> Void in
                    if error == nil {
                        self.eventPicture.image = UIImage(data: imageData)
                        UIImageWriteToSavedPhotosAlbum(UIImage(data: imageData), nil, nil, nil)
                       
                        
                    } else {
                        println(error)
                    }
                })
            }
        })
     

        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}