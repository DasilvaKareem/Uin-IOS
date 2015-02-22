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
    
    @IBOutlet weak var foodIcon: UILabel!
    @IBOutlet weak var freeIcon: UILabel!
    @IBOutlet weak var onCampusIcon: UILabel!
    
    @IBOutlet var endDate: UILabel!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet var startTime: UILabel!
    @IBOutlet var endTime: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var isFood: UIImageView!
    @IBOutlet weak var username: UIButton!
    @IBOutlet weak var isSite: UIImageView!
    @IBOutlet weak var isPaid: UIImageView!
    @IBAction func gotoProfile(sender: AnyObject) {
        
        self.performSegueWithIdentifier("gotoprofile", sender: self)
        
    }
    
    @IBOutlet var theeditButton: UIBarButtonItem!
    var profileEditing = false
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
    
    func checkevent(){
        var minique = PFQuery(className: "GoingEvent")
        minique.whereKey("user", equalTo: PFUser.currentUser().username)
        var minique2 = PFQuery(className: "GoingEvent")
        minique.whereKey("eventID", equalTo: eventId)
        
        minique.getFirstObjectInBackgroundWithBlock{
            
            (results:PFObject!, error: NSError!) -> Void in
            
            if error == nil {
                
                self.longBar.setImage(UIImage(named: "addedToCalendarLongBar.png"), forState: UIControlState.Normal)
                
            }   else {
                
                
                self.longBar.setImage(UIImage(named: "addToCalendarLongBar.png"), forState: UIControlState.Normal)
            }
            
            
        }
        
    }
    override func viewDidAppear(animated: Bool) {
        if profileEditing == false {
            
            navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navBarBackground.png"), forBarMetrics: UIBarMetrics.Default)
            
            // Changes text color on navbar
            var nav = self.navigationController?.navigationBar
            nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()];
            
            
        }
    }

    override func viewDidLoad() {
       
        super.viewDidLoad()
        if users != PFUser.currentUser().username{
            
            self.navigationItem.rightBarButtonItem = nil
            
            
            
        }
    
        if profileEditing == true {
            
            navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navBarBackground.png"), forBarMetrics: UIBarMetrics.Default)
            
            // Changes text color on navbar
            var nav = self.navigationController?.navigationBar
            nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()];
            
        }
        if profileEditing == false {
            
            navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navBarBackground.png"), forBarMetrics: UIBarMetrics.Default)
            
            // Changes text color on navbar
            var nav = self.navigationController?.navigationBar
            nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()];

            
        }
    
        println(food)
        println(onsite)
        println(cost)
       username.setTitle(users, forState: UIControlState.Normal)
        endDate.text = storeEndDate
       location.text = storeLocation
        eventTitle.text = storeTitle
        startTime.text = storeStartTime
        endTime.text = storeEndTime
        date.text = storeDate
        putIcons()
        checkevent()
        if PFUser.currentUser().username == users {
            
             username.enabled = false
            
        }
    }
  
    @IBAction func addtocalendar(sender: AnyObject) {
        var eventStore : EKEventStore = EKEventStore()
        eventStore.requestAccessToEntityType(EKEntityTypeEvent, completion: {
            
            granted, error in
            if (granted) && (error == nil) {
                println("granted \(granted)")
                println("error  \(error)")
                var going = PFObject(className: "GoingEvent")
                going["user"] = PFUser.currentUser().username
                going["event"] = self.storeTitle
                going["author"] = self.users
                going["added"] = true
                //going["eventID"] = self.objectID[sender.tag]
                going.saveInBackgroundWithBlock{
                    
                    (succeded:Bool!, savError:NSError!) -> Void in
                    
                    if savError == nil {
                        
                        println("it worked")
                        
                    }
                }
                var notify = PFObject(className: "Notification")
                notify["sender"] = PFUser.currentUser().username
                notify["receiver"] = self.users
                notify["type"] =  "calendar"
                notify.saveInBackgroundWithBlock({
                    
                    (success:Bool!, notifyError: NSError!) -> Void in
                    
                    if notifyError == nil {
                        
                        println("notifcation has been saved")
                        
                    }
                    
                    
                })
                
                
                var hosted = "Hosted by \(self.users)"
                var event:EKEvent = EKEvent(eventStore: eventStore)
                event.title = self.storeTitle
                
                event.startDate = self.storeStartDate
                event.endDate = self.endStoreDate
                event.notes = hosted
                event.location = self.storeLocation
                event.calendar = eventStore.defaultCalendarForNewEvents
                eventStore.saveEvent(event, span: EKSpanThisEvent, error: nil)
                println("Saved Event")
                
            }
        })
        self.longBar.setImage(UIImage(named: "addedToCalendarLongBar.png"), forState: UIControlState.Normal)

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
            var theotherprofile:userprofile = segue.destinationViewController as userprofile
            theotherprofile.theUser = users
      }
        if segue.identifier == "editEvent" {
        
            var editEvent:eventMake = segue.destinationViewController as eventMake
            editEvent.startTime = storeStartTime
            //editEvent.end.setTitle(storeEndTime, forState: UIControlState.Normal)
            editEvent.editing = true
            startString =  "\(storeDate)  \(storeStartTime)"
            endString = "\(storeEndDate)  \(storeEndTime)"
            editEvent.eventTitlePass = storeTitle
            editEvent.eventLocation = storeLocation
            editEvent.onsite =  onsite
            editEvent.food = food
            editEvent.paid = cost
            
            //Make this into a switch statement later on kareem
            
            
        
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
   }

    
}
