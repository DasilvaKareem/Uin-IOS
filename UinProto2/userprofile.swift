//
//  userprofile.swift
//  UinProto2
//
//  Created by Kareem Dasilva on 2/1/15.
//  Copyright (c) 2015 Kareem Dasilva. All rights reserved.
//

import UIKit
import EventKit

class userprofile: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    
    @IBOutlet var username: UIBarButtonItem!
    @IBOutlet var theFeed: UITableView!
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
    var theUser = String()
    var localizedTime = [String]()
    var localizedEndTime = [String]()
    var areSubbed = Bool()
    var userId = (String)()
    var arrayofuser = [String]()
    var eventAddress = [String]()
   
    
    
 
    @IBOutlet var confirmedImage: UIImageView!
    @IBOutlet var subscribers: UILabel!
    @IBOutlet var subscriptions: UILabel!
    var numSections = 0
    var rowsInSection = [Int]()
    var sectionNames = [String]()
    
   
    func displayAlert(title:String, error:String) {
        
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        func preferredStatusBarStyle() -> UIStatusBarStyle {
            return UIStatusBarStyle.Default
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var theMix = Mixpanel.sharedInstance()
        theMix.track("User Profile Opened")
        theMix.flush()
        self.tabBarController?.tabBar.hidden = true
        self.navigationController?.navigationBar.backIndicatorImage = nil
        
        subticker()
        println()
        println()
        println(self.theUser)
        username.title = self.theUser
        println()
        println()
        println()
        updateFeed()
        //Changes the navbar background
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        // Changes text color on navbar
        var nav = self.navigationController?.navigationBar
        nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()];
        
        //Adds pull to refresh
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.theFeed.addSubview(refresher)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        
    }
    
    @IBOutlet weak var subbutton: UIButton!
    var amountofsubs = (String)()
    var amountofScript = (String)()
    func subticker(){
        
        var getNumberList = PFQuery(className:"Subscription")
        getNumberList.whereKey("publisher", equalTo: self.theUser)
        var amount = String(getNumberList.countObjects())
        self.amountofsubs = amount

        var getNumberList2 = PFQuery(className:"Subscription")
        getNumberList2.whereKey("subscriber", equalTo: self.theUser)
        amount = String(getNumberList2.countObjects())
        self.amountofScript = amount
    }

    func updateFeed(){
        //Removes all leftover content in the array
        
        println("Before query")
        
        //adds content to the array
        //Queries all public Events
        var que1 = PFQuery(className: "Event")
        que1.whereKey("isPublic", equalTo: true)
        que1.whereKey("author", equalTo: self.theUser)
        
        //Queries all Private events
        var pubQue = PFQuery(className: "Subcription")
        pubQue.whereKey("subscriber", equalTo: PFUser.currentUser().username)
        pubQue.whereKey("isMember", equalTo: true)
        pubQue.whereKey("publisher", equalTo: self.theUser)
        var superQue = PFQuery(className: "Event")
        superQue.whereKey("author", matchesKey: "subscriber", inQuery:pubQue)
    
        
   
        
        
        var query = PFQuery.orQueryWithSubqueries([que1, superQue])
        query.orderByAscending("start")
        query.whereKey("isDeleted", equalTo: false)
        query.whereKey("start", greaterThanOrEqualTo: NSDate())
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
                self.eventAddress.removeAll(keepCapacity: true)
                
                for object in results{
                    
                    self.eventAddress.append(object["address"] as!String)
                    self.publicPost.append(object["isPublic"] as!Bool)
                    self.objectID.append(object.objectId as String)
                    self.usernames.append(object["author"] as!String)
                    self.eventTitle.append(object["title"] as!String)
                    self.food.append(object["hasFood"] as!Bool)
                    self.paid.append(object["isFree"] as!Bool)
                    self.onsite.append(object["onCampus"] as!Bool)
                    self.eventEnd.append(object["end"] as!NSDate)
                    self.eventStart.append(object["start"] as!NSDate)
                    self.eventlocation.append(object["location"] as!String)
                   
                    
                }
                self.populateSectionInfo()
                self.theFeed.reloadData()
                self.refresher.endRefreshing()
                
            }
                
                
            else {
                if error.code == 100 {
                    
                    self.displayAlert("No Internet", error: "You have no internet connection")
                }
                
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
        //Because the loop is broken before a new date is found, that
        //  one needs to be added manually
        rowsInSection.append(i)
        numSections++
        
        if numSections == 0 {
            numSections++
        }

    }
    
    //Returns the index of the element at the specified section and row
    func getEventIndex(section: Int, row: Int) -> Int{
        var offset = 0
        for (var i = 0; i < section; i++){
            offset += rowsInSection[i]
        }
        return offset+row
    }
    
    //DATA SOURCES FOR TABLE VIEW
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return numSections
        
        
        
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if  section == 0 {
            let cell2:profileCell = tableView.dequeueReusableCellWithIdentifier("profile") as! profileCell
            var que = PFQuery(className:"Subscription")
            cell2.subscribe.adjustsImageWhenHighlighted = false
            que.whereKey("subscriber", equalTo:PFUser.currentUser().username)
            que.whereKey("publisher", equalTo: theUser)
            if PFUser.currentUser()["tempAccounts"] as!Bool == true {
                println("You are a temp account you cannot possibly subscribe to account fool, ya fool")
                cell2.subscribe.setTitleColor(UIColor(red: 254.0/255.0, green: 186.0/255.0, blue: 1.0/255.0, alpha: 1.0), forState: UIControlState.Normal) //Sets as Orange
                //Creates an alert to subscribe
                cell2.subscribe.addTarget(self, action: "subbing:", forControlEvents: UIControlEvents.TouchUpInside)
                
                cell2.subscriberTick.text =  amountofsubs
                cell2.subscriptionTick.text = amountofScript
                return cell2
                
            } else {
            que.getFirstObjectInBackgroundWithBlock{
    
                (object:PFObject!, error: NSError!) -> Void in
                
                if error == nil {
                    
                    
                    cell2.subscribe.setTitle("Unsubscribe", forState: UIControlState.Normal)
                    cell2.subscribe.setTitleColor(UIColor(red: 65.0/255.0, green: 146.0/255.0, blue: 199.0/255.0, alpha: 1.0), forState: UIControlState.Normal)
                    cell2.subscribe.setBackgroundImage(UIImage(named: "unsubscribeButton"), forState: UIControlState.Normal)
                    
                }
                else {
                    //If the user is using a temp account changes the function of the button
                       cell2.subscribe.setTitle("Subscribe", forState: UIControlState.Normal)
                        cell2.subscribe.setTitleColor(UIColor(red: 254.0/255.0, green: 186.0/255.0, blue: 1.0/255.0, alpha: 1.0), forState: UIControlState.Normal)
                        cell2.subscribe.setBackgroundImage(UIImage(named: "subscribeButton"), forState: UIControlState.Normal)


                }
            }
  
           
            cell2.subscribe.addTarget(self, action: "subbing:", forControlEvents: UIControlEvents.TouchUpInside)
            cell2.subscriberTick.text =  amountofsubs
            cell2.subscriptionTick.text = amountofScript
            return cell2
        }
        }
        var cell:dateCell = tableView.dequeueReusableCellWithIdentifier("dateCell") as! dateCell
        cell.dateItem.text = sectionNames[section]
        return cell
        }
    
    
    
    func subbing(sender: UIButton) {
        if PFUser.currentUser()["tempAccounts"] as!Bool == true {
            var theMix = Mixpanel.sharedInstance()
            theMix.track("Anon Subscribe Attempt (UP)")
            theMix.flush()
        var alert = UIAlertController(title: "Create an account to do this!", message: "It'll only take a few seconds...", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Create an account", style: .Default, handler: { action in

            self.performSegueWithIdentifier("createAccount", sender: self)
            
        }))
        alert.addAction(UIAlertAction(title: "Sign in", style: UIAlertActionStyle.Default, handler: { action in
            
            self.performSegueWithIdentifier("signInAccount", sender: self)
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { action in
            
            
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        func preferredStatusBarStyle() -> UIStatusBarStyle {
            return UIStatusBarStyle.Default
            }
        } else {
        var subQuery = PFQuery(className: "Subscription")
        subQuery.whereKey("publisher", equalTo: theUser)
        subQuery.whereKey("subscriber", equalTo: PFUser.currentUser().username)
        subQuery.getFirstObjectInBackgroundWithBlock({
            (results:PFObject!, error: NSError!) -> Void in
            if error == nil {
                sender.setTitle("Subscribe", forState: UIControlState.Normal)
                sender.setTitleColor(UIColor(red: 254.0/255.0, green: 186.0/255.0, blue: 1.0/255.0, alpha: 1.0), forState: UIControlState.Normal)
                 sender.setBackgroundImage(UIImage(named: "subscribeButton"), forState: UIControlState.Normal)
              
               
                var user = PFUser.currentUser()
                var currentInstallation = PFInstallation.currentInstallation()
                currentInstallation.removeObject(self.userId, forKey: "channels")
                currentInstallation.saveInBackgroundWithBlock({
                    (success:Bool, pushError: NSError!) -> Void in
                    
                    if pushError == nil {
                        println("the installtion did remove")
                        var theMix = Mixpanel.sharedInstance()
                        theMix.track("Unsubscribed (UP)")
                        theMix.flush()
                        
                    }
                    else{
                        println("the installtion did not remove")
                        println(pushError)
                    }
                })
                println("user is alreadt subscribed")
                results.delete()
                  self.subticker()
                
            }
                
            else {
                //Subscribing feature
                sender.setTitle("Subscribed", forState: UIControlState.Normal)
                sender.setTitleColor(UIColor(red: 65.0/255.0, green: 146.0/255.0, blue: 199.0/255.0, alpha: 1.0), forState: UIControlState.Normal)
                 sender.setBackgroundImage(UIImage(named: "unsubscribeButton"), forState: UIControlState.Normal)
                
                var currentInstallation = PFInstallation.currentInstallation()
                currentInstallation.addUniqueObject(self.userId, forKey: "channels")
                currentInstallation.saveInBackgroundWithBlock({
                    (success:Bool, saveerror: NSError!) -> Void in
                    if saveerror == nil {
                        println("Subscribed")
                        var theMix = Mixpanel.sharedInstance()
                        theMix.track("Subscribed (UP)")
                      
                        
                    }
                        
                    else {
                        println("User did not subscribe")
                    }
                })
                
                //Creats the subscribe object
                var subscribe = PFObject(className:"Subscription")
                subscribe["isMember"] = false
                subscribe["subscriber"] = PFUser.currentUser().username
                subscribe["subscriberID"] = PFUser.currentUser().objectId
                subscribe["publisher"] = self.theUser
                subscribe["publisherID"] = self.userId
                subscribe.save()
                
                //The notfications
                var notify = PFObject(className: "Notification")
                notify["senderID"] = PFUser.currentUser().objectId
                notify["sender"] = PFUser.currentUser().username
                notify["receiverID"] = self.userId
                notify["receiver"] = self.theUser
                notify["type"] =  "sub"
                notify.saveInBackgroundWithBlock({
                    
                    (success:Bool, notifyError: NSError!) -> Void in
                    
                    if notifyError == nil {
                        println("notifcation has been saved")
                    }
                })
                //Sends Push notification
                var user = PFUser.currentUser()
                var checkPush = PFUser.query()
                checkPush.whereKey("username", equalTo: self.theUser)
                var theOther = checkPush.getFirstObject()
                if theOther["pushEnabled"] as!Bool == true {
                    var push = PFPush()
                    var pfque = PFInstallation.query()
                    pfque.whereKey("user", equalTo: self.theUser)
                    push.setQuery(pfque)
                    push.setMessage("\(PFUser.currentUser().username) has subscribed to you ")
                    push.sendPushInBackgroundWithBlock({
                        
                        (success:Bool, pushError: NSError!) -> Void in
                        
                        if pushError == nil {
                            
                            println("Push was sent")
                        }
                    })
                    
                }
                  self.subticker()
               
                }
            })
        }
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        return rowsInSection[section]
        
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 64.0
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            
            return 150.0
        }
        return 25.0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        // Puts the data in a cell
        
        var cell:eventCell = tableView.dequeueReusableCellWithIdentifier("cell2") as! eventCell
        
        var event = getEventIndex(indexPath.section, row: indexPath.row)
        
        //println(onsite.count)
        //println(event)
        println(onsite[event])
        print(food[event])
        println(paid[event])
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
        var minique = PFQuery(className: "UserCalendar")
        minique.whereKey("user", equalTo: PFUser.currentUser().username)
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
    
    func followButton(sender: UIButton){
        // Adds the event to calendar
        
       var first = PFUser.currentUser()["firstRemoveFromCalendar"] as!Bool
        
        var que = PFQuery(className: "UserCalendar")
        que.whereKey("user", equalTo: PFUser.currentUser().username)
        que.whereKey("author", equalTo: self.usernames[sender.tag])
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
                            println(self.eventTitle[sender.tag])
                            println(self.eventStart[sender.tag])
                            println(self.eventEnd[sender.tag])
                            println(self.eventEnd[sender.tag])
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
                                
                                println("removed")
                                var theMix = Mixpanel.sharedInstance()
                                theMix.track("Removed from Calendar (UP)")
                                eventStore.removeEvent(i, span: EKSpanThisEvent, error: nil)
                            }
                        }
                    }
                    
                }
            } else {
                  sender.setImage(UIImage(named: "addedToCalendar.png"), forState: UIControlState.Normal)
                var eventStore : EKEventStore = EKEventStore()
                eventStore.requestAccessToEntityType(EKEntityTypeEvent, completion: {
                    
                    granted, error in
                    if (granted) && (error == nil) {
                        println("granted \(granted)")
                        println("error  \(error)")
                        var hosted = "Hosted by \(self.usernames[sender.tag])"
                        var event:EKEvent = EKEvent(eventStore: eventStore)
                        println()
                        println()
                        println()
                        println()
                        println(self.eventTitle[sender.tag])
                        println(self.eventStart[sender.tag])
                        println(self.eventEnd[sender.tag])
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
                        theMix.track("Added to Calendar (UP)")
                        println("saved")
                    }
                })
                
                println("the object does not exist")
                
                var push = PFPush()
                var pfque = PFInstallation.query()
                pfque.whereKey("user", equalTo: self.usernames[sender.tag])
                push.setQuery(pfque)
                var pushCheck = PFUser.query() //Checks if users has push enabled
                var userCheck = pushCheck.getObjectWithId(self.userId)
                println()
                println(userCheck)
                println()
                if userCheck["pushEnabled"] as!Bool {
                    if PFUser.currentUser()["tempAccounts"] as!Bool == true {
                        push.setMessage("Someone has added your event to their calendar")
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
                going["user"] = PFUser.currentUser().username
                going["event"] = self.eventTitle[sender.tag]
                going["author"] = self.usernames[sender.tag]
                going["added"] = true
                going["eventID"] = self.objectID[sender.tag]
                going.saveInBackgroundWithBlock{
                    
                    (succeded:Bool, savError:NSError!) -> Void in
                    if savError == nil {
                        
                    }
                }
                println("Saved Event")
                
            }
        })
    
        if self.usernames[sender.tag] != PFUser.currentUser().username {
            var notify = PFObject(className: "Notification")
            notify["sender"] = PFUser.currentUser().username
            notify["senderID"] = PFUser.currentUser().objectId
            notify["receiver"] = self.usernames[sender.tag]
            notify["receiverID"] = self.userId
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

    
    override func prepareForSegue(segue:UIStoryboardSegue, sender: AnyObject?){
        
        if segue.identifier == "example" {
            var secondViewController : postEvent = segue.destinationViewController as! postEvent
            var theMix = Mixpanel.sharedInstance()
            theMix.track("Tap Event View (UP)")
            
            var indexPath = theFeed.indexPathForSelectedRow() //get index of data for selected row
            var section = indexPath?.section
            var row = indexPath?.row
            
            var index = getEventIndex(section!, row: row!)
            secondViewController.address = eventAddress[index]
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