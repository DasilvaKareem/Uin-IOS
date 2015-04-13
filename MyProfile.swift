//
//  NewProfile.swift
//  UinProto2
//
//  Created by Kareem Dasilva on 1/24/15.
//  Copyright (c) 2015 Kareem Dasilva. All rights reserved.
//

import UIKit

import EventKit

class NewProfile: UIViewController, UITableViewDelegate, UITableViewDataSource {

    

    @IBOutlet var orgnName: UILabel!
    @IBOutlet var subTicker: UILabel!
    @IBOutlet var subscriptionTicker: UILabel!
    @IBOutlet var subscribers: UIButton!
    @IBOutlet var subscription: UIButton!
    @IBOutlet weak var theFeed: UITableView!
    
    //Decalres all the arrays that hold the data
    
    var refresher: UIRefreshControl!
    var userId = [String]()
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
    var numSections = 0
    var rowsInSection = [Int]()
    var sectionNames = [String]()
    var eventAddress = [String]()
    var eventCountNumber = (Int)()
 

    
    
    // View Life Cycles
    override func viewWillAppear(animated: Bool) {
        subticker()
        checkUpdateFeed()
  
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true

         self.tabBarController?.tabBar.hidden = false
    }

    
    override func viewDidDisappear(animated: Bool) {
        checkUpdateFeed()
        subticker()
        notifications()
    }
    override func viewDidAppear(animated: Bool) {
        
        checkNotifications()
        notifications()
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameButton.title = PFUser.currentUser().username
        self.tabBarController?.tabBar.hidden = false
           self.navigationController?.navigationBar.backIndicatorImage = nil
        subticker()
        updateFeed()
        notifications()
        //Queries all the events and puts into the arrays above
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to Refresh")
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.theFeed.addSubview(refresher)
        var theMix = Mixpanel.sharedInstance()
        theMix.track("My Profile Opened")
        theMix.flush()
        

        
        //Makes Nav Bar Clear
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        
        //Makes Text in navbar white
        var nav = self.navigationController?.navigationBar
        nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()];

    }
    //Checks if any new events are created if not update feed will not execute
    func checkUpdateFeed(){
        var eventCheck = PFQuery(className: "Event")
        var eventNumber = eventCheck.countObjects()
        //Executes updateFeed if the number changes
        if eventCountNumber != eventCheck {
            println("No refresh is neccessary")
            
        } else {
            println("You need to refresh the update feed")
            updateFeed()
        }
    }
    var amountofsubs = (String)()
    var amountofScript = (String)()
    func subticker(){
        
        var getNumberList = PFQuery(className:"Subscription")
        getNumberList.whereKey("publisher", equalTo: PFUser.currentUser().username)
        var amount = String(getNumberList.countObjects())
        self.amountofsubs = amount
        
        var getNumberList2 = PFQuery(className:"Subscription")
        getNumberList2.whereKey("subscriber", equalTo: PFUser.currentUser().username)
        amount = String(getNumberList2.countObjects())
        self.amountofScript = amount
    }
    
    // Checks for notifcations and compares to any notications you recieved during that time
    
    
    var old = (Int)()
    var newCheck = (Int)()
    func notifications() {
        
        var check = PFQuery(className: "Notification")
        check.whereKey("receiver", equalTo: PFUser.currentUser().username)
        old = check.countObjects()
        
        
    }
    
    func checkNotifications() {
        
        var check = PFQuery(className: "Notification")
        check.whereKey("receiver", equalTo: PFUser.currentUser().username)
        newCheck = check.countObjects()
        
        if self.old != self.newCheck {
            var diffrence = self.newCheck - self.old
            var tabArray = self.tabBarController?.tabBar.items as NSArray!
            var tabItem = tabArray.objectAtIndex(1) as! UITabBarItem
            tabItem.badgeValue = String(diffrence)
            println()
            println()
            println("You have gotten a new notification")
            println()
            println()
        }
        else {
            println()
            println()
            println("You do not have a any new notification ")
            
            println()
            println()
        }
        
        
    }


    func updateFeed(){
    var que = PFQuery(className: "Event")
    self.eventCountNumber = que.countObjects()
    que.orderByAscending("start")
    que.whereKey("author", equalTo: PFUser.currentUser().username)
    que.whereKey("start", greaterThanOrEqualTo: NSDate())
    que.whereKey("isDeleted", equalTo: false)
    
    que.findObjectsInBackgroundWithBlock{
    (objects:[AnyObject]!,eventError:NSError!) -> Void in
    
    print("Refreshing list: ")
    
    if eventError == nil {
    println(objects.count)
    
    
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
        self.userId.removeAll(keepCapacity: true)
        self.eventAddress.removeAll(keepCapacity: true)
    
    for object in objects{
    
        self.eventAddress.append(object["address"] as!String)
        self.publicPost.append(object["isPublic"] as!Bool)
        self.objectID.append(object.objectId as String)
        self.usernames.append(object["author"] as!String)
        self.eventTitle.append(object["title"] as!String)
        self.food.append(object["hasFood"] as!Bool)
        self.paid.append(object["isFree"] as!Bool)
        self.userId.append(object["authorID"] as!String)
        self.onsite.append(object["onCampus"] as!Bool)
        self.eventEnd.append(object["end"] as!NSDate)
        self.eventStart.append(object["start"] as!NSDate)
        self.eventlocation.append(object["location"] as!String)
    
    
    }
    
    self.populateSectionInfo()
    self.theFeed.reloadData()
    self.refresher.endRefreshing()
    
    }
    else{
        if eventError.code == 100 {
             self.displayAlert("No Internet", error: "You have no internet connection")
            
        }
    println("Event Feed Query Error: \(eventError) ")
    }
    
    
    
    }
  
    }

    @IBOutlet var usernameButton: UIBarButtonItem!

    func refresh() {
        updateFeed()
        checkNotifications()
        notifications()
        
    }
    func populateSectionInfo(){
        var convertedDates = [String]()
        var currentDate = ""
        var i = 0
        
        //Initialisation
        numSections = 0
        rowsInSection.removeAll(keepCapacity: true)
        rowsInSection.append(0)
        sectionNames.removeAll(keepCapacity: true)
        self.localizedTime.removeAll(keepCapacity: true)
        self.localizedEndTime.removeAll(keepCapacity:true)
        for i in eventStart {
            //SORTS OUT EVENT STARTING TIME AND CREATES EVENT HEADER TIMES AND SHORTNED TIMES
            
            var dateFormatter = NSDateFormatter()
            //Creates table header for event time
            dateFormatter.locale = NSLocale.currentLocale() // Gets current locale and switches
            dateFormatter.dateFormat = " EEEE MMM, dd yyyy" // Formart for date I.E Monday, 03 1996
            var headerDate = dateFormatter.stringFromDate(i) // Creates date
            convertedDates.append(headerDate)
            dateFormatter.dateFormat = " MMM. dd, yyyy"
            var shortenTime = dateFormatter.stringFromDate(i)
            self.eventStartDate.append(shortenTime)
            //Creates Time for Event from NSDAte
            var timeFormatter = NSDateFormatter() //Formats time
            timeFormatter.locale = NSLocale.currentLocale()
            timeFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
            var localTime = timeFormatter.stringFromDate(i)
            self.eventStartTime.append(localTime)
            self.localizedTime.append(localTime)
            
            
        }

        //For each date
        sectionNames.insert("0", atIndex: 0)
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
        for i in eventEnd {
            //SORTS OUT EVENT ENDING TIME AND CREATES EVENT HEADER TIMES AND SHORTNED TIMES
            
            var dateFormatter = NSDateFormatter()
            //Creates table header for event time
            dateFormatter.locale = NSLocale.currentLocale() // Gets current locale and switches
            var headerDate = dateFormatter.stringFromDate(i) // Creates date
           dateFormatter.dateFormat = " MMM. dd, yyyy"
            var shortenTime = dateFormatter.stringFromDate(i)
            self.eventEndDate.append(shortenTime)
            //Creates Time for Event from NSDAte
            var timeFormatter = NSDateFormatter() //Formats time
            timeFormatter.locale = NSLocale.currentLocale()
            timeFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
            var localTime = timeFormatter.stringFromDate(i)
            self.localizedEndTime.append(localTime)
            self.eventEndTime.append(localTime)
        }
        //Because the loop is broken before a new date is found, that
        //  one needs to be added manually
       
        rowsInSection.append(i)
         numSections++
        
        if numSections == 0 {
            numSections++
        }

            
        
        
        
       
        println()
        println(rowsInSection)
         println(numSections)
        println(sectionNames)
        println()
    }
    
    func getEventIndex(section: Int, row: Int) -> Int{
        var offset = 0
        for (var i = 0; i < section; i++){
            offset += rowsInSection[i]
        }
       
        return offset+row
        
    }


    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 65.0
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
   func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            
            return 150.0
        }
        return 23.0
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
 
    

    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       
        
       
        
        if  section != 0 {
             var cell:dateCell = tableView.dequeueReusableCellWithIdentifier("dateCell") as! dateCell
            cell.dateItem.text = sectionNames[section]
            return cell
        }
        let cell2:profileCell = tableView.dequeueReusableCellWithIdentifier("profile") as! profileCell
        
        //THIS IS WHERE YOU ARE GOING TO PUT THE LABEL
        
        cell2.subscriberTick.text = amountofsubs
        cell2.subscriptionTick.text = amountofScript
        
        return cell2

      
    }
    
    
    
    

    
    var number = [Int]()
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        // Puts the data in a cell
        
    
        var cell:eventCell = tableView.dequeueReusableCellWithIdentifier("cell2") as! eventCell
     
        var event = getEventIndex(indexPath.section, row: indexPath.row)


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
        cell.people.text = usernames[event]
        cell.time.text = localizedTime[event]
        cell.eventName.text = eventTitle[event]
        cell.poop.tag = event
        //Mini query to check if event is already saved
        //println(objectID[event])
        var minique = PFQuery(className: "UserCalendar")
        minique.whereKey("userID", equalTo: PFUser.currentUser().objectId)
        var minique2 = PFQuery(className: "UserCalendar")
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
    
    //end data source
    
    func followButton(sender: UIButton){
        // Adds the event to calendar
        var first:Bool = Bool()
        
        first = PFUser.currentUser()["firstRemoveFromCalendar"] as!Bool
        
        var que = PFQuery(className: "UserCalendar")
        que.whereKey("userID", equalTo: PFUser.currentUser().objectId)
        que.whereKey("eventID", equalTo:self.objectID[sender.tag])
        
        que.getFirstObjectInBackgroundWithBlock({
            
            (results:PFObject!, queerror: NSError!) -> Void in
            
            
            if queerror == nil {
                results.delete()
                println(first)
                if first == true {
                    
                    PFUser.currentUser()["firstRemoveFromCalendar"] = false
                    PFUser().save()
                    self.displayAlert("Remove", error: "Tapping the blue checkmark removes an event from your calendar.")
                    
                }
                if results != nil {
                    sender.setImage(UIImage(named: "addToCalendar.png"), forState: UIControlState.Normal)
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
                    var eV = eventStore.eventsMatchingPredicate(predicate2) as! [EKEvent]!
                    println("Result is there")
                    if eV != nil { //
                        println("EV is not nil")
                        for i in eV {
                            println("\(i.title) this is the i.title")
                            println(self.eventTitle[sender.tag])
                            if i.title == self.eventTitle[sender.tag]  {
                                
                                println("removed event")
                                var theMix = Mixpanel.sharedInstance()
                                theMix.track("Removed from Calendar (MP)")
                                eventStore.removeEvent(i, span: EKSpanThisEvent, error: nil)
                            }
                        }
                    }
                    self.theFeed.reloadData()
                }
                
                
                
                
            } else {
                 sender.setImage(UIImage(named: "addedToCalendar.png"), forState: UIControlState.Normal) // Changes the a2c button blue
                var eventStore : EKEventStore = EKEventStore()
                eventStore.requestAccessToEntityType(EKEntityTypeEvent, completion: {
                    //Saves the event to calenadar
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
                        theMix.track("Added to Calendar (MP)")
                        println("saved")
                    }
                })
                
                println("the object does not exist")
                //Sends a push notifications
                var push = PFPush()
                var pfque = PFInstallation.query()
                pfque.whereKey("user", equalTo: self.usernames[sender.tag])
                push.setQuery(pfque)
                var pushCheck = PFUser.query() //Checks if users has push enabled
                var userCheck = pushCheck.getObjectWithId(self.userId[sender.tag])
                println()
                println(userCheck)
                println()
                //Checks if user has push enabled
                if userCheck["pushEnabled"] as!Bool {
                    if PFUser.currentUser()["tempAccounts"] as!Bool == true {
                        push.setMessage("Someone has added your event to their calendar") //If user is temp changes messages
                    } else {
                        
                        push.setMessage("\(PFUser.currentUser().username) has added your event to their calendar")
                    }
                    push.sendPushInBackgroundWithBlock({
                        (success:Bool, pushError: NSError!) -> Void in
                        if pushError == nil {
                            println("Push was Sent")
                        }
                    })
                } else {
                    println("user does not have push enabled")
                }

            
                
                var going = PFObject(className: "UserCalendar")
                going["userID"] = PFUser.currentUser().objectId
                going["event"] = self.eventTitle[sender.tag]
                going["author"] = self.usernames[sender.tag]
                going["added"] = true
                going["eventID"] = self.objectID[sender.tag]
                going.saveInBackgroundWithBlock{
                    
                    (succeded:Bool, savError:NSError!) -> Void in
                    
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
                
                (success:Bool, notifyError: NSError!) -> Void in
                
                if notifyError == nil {
                    
                    println("notifcation has been saved")
                    
                }
                else{
                    println(notifyError)
                }
                
                
            })
        }
        
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
    
    override func prepareForSegue(segue:UIStoryboardSegue, sender: AnyObject?){
        
        if segue.identifier == "example" {
            var secondViewController : postEvent = segue.destinationViewController as! postEvent
            
            
            var theMix = Mixpanel.sharedInstance()
            theMix.track("Tap Event View (MP)")
            theMix.flush()
            
            var indexPath = theFeed.indexPathForSelectedRow() //get index of data for selected row
            var section = indexPath?.section
            var row = indexPath?.row
            
            var index = getEventIndex(section!, row: row!)
            secondViewController.address = eventAddress[index]
            secondViewController.profileEditing = true
            secondViewController.storeStartDate = eventStart[index]
            secondViewController.endStoreDate =  eventEnd[index]
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
