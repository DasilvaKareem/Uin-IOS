//
//  eventFeedViewController.swift
//  UinProto2
//
//  Created by Kareem Dasilva on 1/9/15.
//  Copyright (c) 2015 Kareem Dasilva. All rights reserved.
//  This is the main feed for the appilcation

import UIKit
import EventKit

class eventFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var theFeed: UITableView!
    
    var refresher: UIRefreshControl!
    var onsite = [Bool]()
    var paid = [Bool]()
    var food = [Bool]()
    var eventTitle = [String]()
    var eventlocation = [String]()
    var eventStartTime = [String]()
    var eventEndTime = [String]()
    var eventStartDate = [String]()
    var eventEndDate = [String]()
    var usernames = [String]()
    var objectID = [String]()
    var publicPost = [Bool]()
    var eventEnd = [NSDate]()
    var eventStart = [NSDate]()
    var localizedTime = [String]()
    var localizedEndTime = [String]()
    var userId = [String]()
    var numSections = 0
    var rowsInSection = [Int]()
    var sectionNames = [String]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        self.tabBarController?.tabBar.hidden = false
        //var eventsItem = tabBarItem?[0] as UITabBarItem
        //eventsItem.selectedImage = UIImage(named: "addToCalendar.png")
        
 
     
    
        updateFeed()
    
        //Changes the navbar background
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navBarBackground.png"), forBarMetrics: UIBarMetrics.Default)
        
        // Changes text color on navbar
        var nav = self.navigationController?.navigationBar
        nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()];
        
        
        //Adds pull to refresh
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.theFeed.addSubview(refresher)
        
        
        
        
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
 
    override func viewDidDisappear(animated: Bool) {
        println("View disspear")
        
              updateFeed()
    }
    override func viewWillAppear(animated: Bool) {
    
         self.tabBarController?.tabBar.hidden = false
    }
    func updateFeed(){
        //Removes all leftover content in the array
        
        println("Before query")
        
        //adds content to the array
        var que1 = PFQuery(className: "Event")
        que1.whereKey("public", equalTo: true)
        
        var pubQue = PFQuery(className: "Subs")
        pubQue.whereKey("follower", equalTo: PFUser.currentUser().username)
        pubQue.whereKey("member", equalTo: true)
        var superQue = PFQuery(className: "Event")
        superQue.whereKey("author", matchesKey: "following", inQuery:pubQue)
        
        var newQue = PFQuery(className: "Event")
        newQue.whereKey("public", equalTo: false)
        newQue.whereKey("author", equalTo: PFUser.currentUser().username)
        
    
        var query = PFQuery.orQueryWithSubqueries([que1, superQue, newQue ])
        query.orderByAscending("startEvent")
        query.whereKey("startEvent", greaterThanOrEqualTo: NSDate())
        query.findObjectsInBackgroundWithBlock {
            (results: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                
                
               
                   
                    
                    self.onsite.removeAll(keepCapacity: true)
                    self.paid.removeAll(keepCapacity: true)
                    self.food.removeAll(keepCapacity: true)
                    self.eventTitle.removeAll(keepCapacity: true)
                    self.eventlocation.removeAll(keepCapacity: true)
                    self.eventStartTime.removeAll(keepCapacity: true)
                    self.eventEndTime.removeAll(keepCapacity: true)
                    self.eventStartDate.removeAll(keepCapacity: true)
                    self.eventEndDate.removeAll(keepCapacity: true)
                    self.usernames.removeAll(keepCapacity: true)
                    self.objectID.removeAll(keepCapacity: true)
                    self.publicPost.removeAll(keepCapacity: true)
                    self.eventStart.removeAll(keepCapacity: true)
                    self.eventEnd.removeAll(keepCapacity: true)
                    self.localizedTime.removeAll(keepCapacity: true)
                    self.localizedEndTime.removeAll(keepCapacity: true)
                
                      for object in results{
                    
                    
                    self.publicPost.append(object["public"] as Bool)
                    self.objectID.append(object.objectId as String)
                    self.usernames.append(object["author"] as String)
                    self.eventTitle.append(object["eventTitle"] as String)
                    self.eventStartDate.append(object["startDate"] as String)
                    self.eventEndDate.append(object["endDate"] as String)
                    self.eventStartTime.append(object["startTime"] as String)
                    self.eventEndTime.append(object["endTime"] as String)
                    self.food.append(object["food"] as Bool)
                    self.paid.append(object["paid"] as Bool)
                    self.onsite.append(object["location"] as Bool)
                    self.eventEnd.append(object["endEvent"] as NSDate)
                    self.eventStart.append(object["startEvent"] as NSDate)
                    self.eventlocation.append(object["eventLocation"] as String)
                    self.userId.append(object["userId"] as String)
                    
                    }
                    self.populateSectionInfo()
                    self.theFeed.reloadData()
                    self.refresher.endRefreshing()
                    
                }
                
                
            else {
                
                println("It failed")
                
            }
        }
        
        
        
        
    }
    func refresh() {
        
        updateFeed()
    }
    
    func populateSectionInfo(){
        var convertedDates = [String]()
        var currentDate = ""
        var i = 0
        
        //Initialisation
        numSections = 0
        rowsInSection.removeAll(keepCapacity: true)
        sectionNames.removeAll(keepCapacity: true)
        self.localizedTime.removeAll(keepCapacity: true)
        self.localizedEndTime.removeAll(keepCapacity: true)
        for i in eventStart {
            
            
           var dateFormatter = NSDateFormatter()
            dateFormatter.locale = NSLocale.currentLocale()
             dateFormatter.dateFormat = " EEEE MMM, dd yyyy"
           var realDate = dateFormatter.stringFromDate(i)
            var dateFormatter2 = NSDateFormatter()
            dateFormatter2.timeStyle = NSDateFormatterStyle.ShortStyle
            var localTime = dateFormatter2.stringFromDate(i)
            convertedDates.append(realDate)
            self.localizedTime.append(localTime)
            
            
        }
        
        for i in eventEnd {
            
            
            var dateFormatter2 = NSDateFormatter()
            dateFormatter2.locale = NSLocale.currentLocale()
            dateFormatter2.dateFormat = " EEEE MMM, dd yyyy"
            var realDate2 = dateFormatter2.stringFromDate(i)
            var dateFormatter3 = NSDateFormatter()
            dateFormatter3.timeStyle = NSDateFormatterStyle.ShortStyle
            var localTime = dateFormatter3.stringFromDate(i)
         
            self.localizedEndTime.append(localTime)
            
            
        }
    
        
        //For each date
        for date in convertedDates{
            //If there is a date change
            if (currentDate != date){
                //If the current date is not the init value
                if (currentDate != ""){
                    //The number of dates is added to the array
                    rowsInSection.append(i)
                    //The count is reset
                    i = 0
                }
                //The current date is set to the newly found date
                currentDate = date
                //The newly found date is added to the array
                sectionNames.append(currentDate)
                //The number of sections is incrememnted
                numSections++
            }
            //The count is incremented
            i++
        }
        //Because the loop is broken before a new date is found, that
        //  one needs to be added manually
        rowsInSection.append(i)
    }
    
    //Returns the index of the element at the specified section and row
    func getEventIndex(section: Int, row: Int) -> Int{
        var offset = 0
        for (var i = 0; i < section; i++){
            offset += rowsInSection[i]
        }
        return offset+row
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    
    /*func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    
    
    return sectionNames[section]
    
    }
    */
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var cell:dateCell = tableView.dequeueReusableCellWithIdentifier("dateCell") as dateCell
        
        cell.dateItem.text = sectionNames[section]
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return numSections
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return rowsInSection[section]
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        // Puts the data in a cell
        var cell:eventCell = tableView.dequeueReusableCellWithIdentifier("cell2") as eventCell
        
        var event = getEventIndex(indexPath.section, row: indexPath.row)
        
        var section = indexPath.section
        var row = indexPath.row
        
        if onsite[event] == true {
            
            cell.onCampusIcon.image = UIImage(named: "onCampus.png")
            cell.onCampusText.text = "On-Campus"
            cell.onCampusText.textColor = UIColor.darkGrayColor()
            
            
        }
        else{
            
            cell.onCampusIcon.image = UIImage(named: "offCampus.png")
            cell.onCampusText.text = "Off-Campus"
            cell.onCampusText.textColor = UIColor.lightGrayColor()
            
        }
        
        if food[event] == true {
            
            cell.foodIcon.image = UIImage(named: "yesFood.png")
            cell.foodText.text = "Food"
            cell.foodText.textColor = UIColor.darkGrayColor()
            
            
        }
        else{
            
            cell.foodIcon.image = UIImage(named: "noFood.png")
            cell.foodText.text = "No Food"
            cell.foodText.textColor = UIColor.lightGrayColor()
            
        }
        if paid[event] == true {
            
            cell.freeIcon.image = UIImage(named: "yesFree.png")
            cell.costText.text = "Free"
            cell.costText.textColor = UIColor.darkGrayColor()
            
            
        }
        else{
            
            
            cell.freeIcon.image = UIImage(named: "noFree.png")
            cell.costText.text = "Not Free"
            cell.costText.textColor = UIColor.lightGrayColor()
            
        }
        
        if publicPost[event] != true {
            
            cell.privateImage.image = UIImage(named: "privateEvent.png")
        }
        
        else {
            
            cell.privateImage.image = nil
        }
        
        cell.people.text = usernames[event]
        cell.time.text = localizedTime[event]
        cell.eventName.text = eventTitle[event]
        cell.poop.tag = event
        
        // Mini query to check if event is already saved
        //println(objectID[event])
        var minique = PFQuery(className: "GoingEvent")
        minique.whereKey("user", equalTo: PFUser.currentUser().username)
        var minique2 = PFQuery(className: "GoingEvent")
        minique.whereKey("eventID", equalTo: objectID[event])
        
        minique.getFirstObjectInBackgroundWithBlock{
            
            (results:PFObject!, error: NSError!) -> Void in
            
            if error == nil {
                
                cell.poop.setImage(UIImage(named: "addedToCalendar.png"), forState: UIControlState.Normal)
                
            }   else {
                
                cell.poop.setImage(UIImage(named: "addToCalendar.png"), forState: UIControlState.Normal)
            }
            
            
        }
              cell.poop.addTarget(self, action: "followButton:", forControlEvents: UIControlEvents.TouchUpInside)
        
        return cell
    }

    func followButton(sender: AnyObject){
        // Puts the data in a cell
     
    
     
   
 
        var first:Bool = Bool()
        
       var getFirst = PFUser.query()
        getFirst.getObjectInBackgroundWithId(PFUser.currentUser().objectId, block: {
            (results:PFObject!, error: NSError!) -> Void in
            
            if error == nil {
                
                if results["first"] as Bool == true {
                    
                    first = true
                }
                
                
            }
            
        })
        
      
      var que = PFQuery(className: "GoingEvent")
        que.whereKey("user", equalTo: PFUser.currentUser().username)
        que.whereKey("author", equalTo: self.usernames[sender.tag])
        que.whereKey("eventID", equalTo:self.objectID[sender.tag])
        que.getFirstObjectInBackgroundWithBlock({
            
            (results:PFObject!, queerror: NSError!) -> Void in
            
            
            if queerror == nil {
                results.delete()
                println(first)
                if first == true {
                    
                    var getFirst = PFUser.query()
                    getFirst.getObjectInBackgroundWithId(PFUser.currentUser().objectId, block: {
                        (results:PFObject!, error: NSError!) -> Void in
                        
                        if error == nil {
                          
                            results["first"] = false
                            results.save()
                            
                            
                        }
                        
                    })
                    self.displayAlert("Remove", error: "Tapping the blue checkmark removes an event from your calendar.")
                    
                }
                if results != nil {
                    var eventStore : EKEventStore = EKEventStore()
                    eventStore.requestAccessToEntityType(EKEntityTypeEvent, completion: {
                        
                        granted, error in
                        if (granted) && (error == nil) {
                            println("granted \(granted)")
                            println("error  \(error)")
                            var hosted = "Hosted by \(self.usernames[sender.tag])"
                            var event:EKEvent = EKEvent(eventStore: eventStore)
                         
                            event.title = self.eventTitle[sender.tag]
                            event.startDate = self.eventStart[sender.tag]
                            event.endDate = self.eventEnd[sender.tag]
                            event.notes = hosted
                            event.location = self.eventlocation[sender.tag]
                            event.calendar = eventStore.defaultCalendarForNewEvents
                        }
                    })
                    var predicate2 = eventStore.predicateForEventsWithStartDate(self.eventStart[sender.tag], endDate: self.eventEnd[sender.tag], calendars:nil)
                    var eV = eventStore.eventsMatchingPredicate(predicate2) as [EKEvent]!
                    println("Result is there")
                    if eV != nil { //
                        println("EV is not nil")
                        for i in eV {
                            println("\(i.title) this is the i.title")
                            println(self.eventTitle[sender.tag])
                            if i.title == self.eventTitle[sender.tag]  {
                          
                                println("removed")
                                var theMix = Mixpanel.sharedInstance()
                                theMix.track("RemovedFromEvent")
                                eventStore.removeEvent(i, span: EKSpanThisEvent, error: nil)
                            }
                        }
                    }
                    self.theFeed.reloadData()
                }
                
                
                
                
            } else {
                var eventStore : EKEventStore = EKEventStore()
                eventStore.requestAccessToEntityType(EKEntityTypeEvent, completion: {
                    
                    granted, error in
                    if (granted) && (error == nil) {
                        println("granted \(granted)")
                        println("error  \(error)")
                        var hosted = "Hosted by \(self.usernames[sender.tag])"
                        var event:EKEvent = EKEvent(eventStore: eventStore)
                        event.title = self.eventTitle[sender.tag]
                        event.startDate = self.eventStart[sender.tag]
                        event.endDate = self.eventEnd[sender.tag]
                        event.notes = hosted
                        var alarm = EKAlarm(relativeOffset: -3600.00)
                        event.addAlarm(alarm)
                        event.location = self.eventlocation[sender.tag]
                        event.calendar = eventStore.defaultCalendarForNewEvents
                        eventStore.saveEvent(event, span: EKSpanThisEvent, error: nil)
                        var theMix = Mixpanel.sharedInstance()
                        theMix.track("AddedToEvent")
                        println("saved")
                    }
                })

              println()
                println()
                println()
                println()
                println()
                println("the object does not exist")
        
                    var push = PFPush()
                
                    var pfque = PFInstallation.query()
                    pfque.whereKey("user", equalTo: self.usernames[sender.tag])
          
                    push.setQuery(pfque)
                    push.setMessage("\(PFUser.currentUser().username) has added your event to their calendar")
                    push.sendPushInBackgroundWithBlock({
                     
                        (success:Bool!, pushError: NSError!) -> Void in
                        
                        if pushError == nil {
                            
                            println("IT WORKED")
                            
                        }
                        
                    })
                
        
                var going = PFObject(className: "GoingEvent")
                going["user"] = PFUser.currentUser().username
                going["event"] = self.eventTitle[sender.tag]
                going["author"] = self.usernames[sender.tag]
                going["added"] = true
                going["eventID"] = self.objectID[sender.tag]
                going.saveInBackgroundWithBlock{
                    
                    (succeded:Bool!, savError:NSError!) -> Void in
                    
                    if savError == nil {
                        
                        println("it worked")
                        
                    }
                }
                
       
                println("Saved Event")
              self.theFeed.reloadData()

            }
            
       
       })

        
        
        
        
        
         if self.usernames[sender.tag] != PFUser.currentUser().username {
            var notify = PFObject(className: "Notification")
            notify["theID"] = self.objectID[sender.tag]
            notify["sender"] = PFUser.currentUser().username
            notify["receiver"] = self.usernames[sender.tag]
            notify["type"] =  "calendar"
            notify.saveInBackgroundWithBlock({
                
                (success:Bool!, notifyError: NSError!) -> Void in
                
                if notifyError == nil {
                    
                    println("notifcation has been saved")
                    
                }
                else{
                    println(notifyError)
                }
                
                
            })
        }

        }
    
    

    override func prepareForSegue(segue:UIStoryboardSegue, sender: AnyObject?){
        
        if segue.identifier == "example" {
            var secondViewController : postEvent = segue.destinationViewController as postEvent
            
            
            
            var theMix = Mixpanel.sharedInstance()
            theMix.track("Expaned View")
            var indexPath = theFeed.indexPathForSelectedRow() //get index of data for selected row
            var section = indexPath?.section
            var row = indexPath?.row
            
            var index = getEventIndex(section!, row: row!)
            secondViewController.storeStartDate = eventStart[index]
            secondViewController.endStoreDate =  eventEnd[index]
            secondViewController.userId = userId[index]
            secondViewController.storeLocation = eventlocation[index]
            secondViewController.storeTitle = eventTitle[index]
            secondViewController.storeStartTime = eventStartTime[index]
            secondViewController.storeEndTime = eventEndTime[index]
            secondViewController.storeDate = eventStartDate[index]
            secondViewController.storeEndDate = eventEndDate[index]
            secondViewController.onsite = onsite[index]
            secondViewController.cost = paid[index]
            secondViewController.food = food[index]
            secondViewController.localStart = localizedTime[index]
          secondViewController.localEnd = localizedEndTime[index]
            secondViewController.users = usernames[index]
            secondViewController.eventId = objectID[index]
            
            
        }
    }
}
