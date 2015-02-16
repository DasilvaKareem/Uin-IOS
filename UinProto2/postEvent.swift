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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
  
    }
    
    func putIcons(){
        
        if  onsite == true {
            isSite.image = UIImage(named: "onCampus.png")
        }
        else{
            isSite.image = UIImage(named: "offCampus.png")
        }
     
        if food == true {
            isFood.image = UIImage(named: "yesFood.png")
        }
        else{
            isFood.image = UIImage(named: "noFood.png")
        }
        if cost == true {
            isPaid.image = UIImage(named: "yesFree.png")
        }
        else{
            isPaid.image = UIImage(named: "noFree.png")
       }
    }
    override func prepareForSegue(segue:UIStoryboardSegue, sender: AnyObject?){
 
        if segue.identifier == "gotoprofile" {
            var theotherprofile:userprofile = segue.destinationViewController as userprofile
            theotherprofile.theUser = users
      }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

        
        
    }
    
    
}
