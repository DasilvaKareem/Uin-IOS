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
    
    @IBOutlet var subscribers: UILabel!
    @IBOutlet var subscriptions: UILabel!
    var numSections = 0
    var rowsInSection = [Int]()
    var sectionNames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.hidden = true
        self.navigationController?.navigationBar.backIndicatorImage = nil
        
        subticker()
        ChangeSub()
        username.title = PFUser.currentUser().username
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
     
    }

    
    @IBOutlet weak var subbutton: UIButton!
     var amountofsubs = [String]()
       var amountofScript = [String]()
    

    func subticker(){
       
        var que2 = PFQuery(className: "Subs")
        
        que2.whereKey("follower", equalTo:PFUser.currentUser().username)
        que2.whereKey("following", equalTo: theUser)
        que2.getFirstObjectInBackgroundWithBlock{
            
            (object:PFObject!, error: NSError!) -> Void in
            
            if error == nil {
                
                self.areSubbed = false
                
            }
            
            else {
                
                self.areSubbed = true
            }
            
        }

        
        var getNumberList = PFQuery(className:"Subs")
        getNumberList.whereKey("following", equalTo: self.theUser)
        getNumberList.findObjectsInBackgroundWithBlock{
            
            (objects:[AnyObject]!, folError:NSError!) -> Void in
            
            
            if folError == nil {
                
                
                for object in objects{
                    
                    self.amountofsubs.append(object["follower"] as String)
                    
                    
                    
                }
                
                
                //self.subscribers.text = " \(amountofsubs.count) SubScribers  "
            }
            
            
        }
        
     
        var getNumberList2 = PFQuery(className: "Subs")
        getNumberList2.whereKey("follower", equalTo: self.theUser)
        getNumberList2.findObjectsInBackgroundWithBlock{
            
            (objects:[AnyObject]!, folError:NSError!) -> Void in
            
            
            if folError == nil {
                
                
                for object in objects{
                    
                    self.amountofScript.append(object["following"] as String)
                    
                    
                    
                }
                
                
                //self.subscriptions.text = "\(amountofScript.count) Subscriptions "
            }
            
            
        }
        
        
        println(self.areSubbed)
        
    }

    
    @IBAction func subscribe(sender: AnyObject) {
        
        var que = PFQuery(className: "Subs")
        
        que.whereKey("follower", equalTo:PFUser.currentUser().username)
        que.whereKey("following", equalTo: theUser)
        que.getFirstObjectInBackgroundWithBlock{

        
            (object:PFObject!, error: NSError!) -> Void in
            
            if object == nil {

                var currentInstallation = PFInstallation.currentInstallation()
                currentInstallation.addUniqueObject(self.theUser, forKey: "channels")
                currentInstallation.saveInBackgroundWithBlock({
                    
                    (success:Bool!, saveerror: NSError!) -> Void in
                    
                    if saveerror == nil {
                        
                        println("it worked")
                        self.areSubbed = true
                        
                    }
                        
                    else {
                        
                        println("It didnt work")
                        
                    }
                    
                    
                })
           
             self.subbutton.setTitle("Unsubscribe", forState: UIControlState.Normal)
            var subscribe = PFObject(className: "Subs")
                var push = PFPush()
                var pfque = PFInstallation.query()
                pfque.whereKey("user", equalTo: self.theUser)
                push.setQuery(pfque)
                push.setMessage("\(PFUser.currentUser().username) has subscribed to you ")
                push.sendPushInBackgroundWithBlock({
                    
                    (success:Bool!, pushError: NSError!) -> Void in
                    
                    if pushError == nil {
                        
                        println("IT WORKED")
                        
                    }
                    
                })

            subscribe["member"] = false
            subscribe["follower"] = PFUser.currentUser().username
            subscribe["following"] = self.theUser
            subscribe.saveInBackgroundWithBlock{
                        
                (success:Bool!,subError:NSError!) -> Void in
 
                if (subError == nil){
                    
                    
                    var notify = PFObject(className: "Notification")
                    notify["sender"] = PFUser.currentUser().username
                    notify["receiver"] = self.theUser
                    notify["type"] =  "sub"
                    notify.saveInBackgroundWithBlock({
                        
                        (success:Bool!, notifyError: NSError!) -> Void in
                        
                        if notifyError == nil {
                            
                            println("notifcation has been saved")
                            
                        }
                        
                        
                    })
                    
                   
                    
                }
                
                
                
                }
                
                }
            
            else {
                
                
                // self.subbutton.setTitle("subscribe", forState: UIControlState.Normal)
                var unsub = PFQuery(className: "Subs")
                
                unsub.whereKey("follower", equalTo:PFUser.currentUser().username)
                unsub.whereKey("following", equalTo: self.theUser)
                unsub.getFirstObjectInBackgroundWithBlock{
                    
                    (object:PFObject!, error: NSError!) -> Void in
                    
                    
                    if object != nil{
                        
                        
                        object.delete()
                        var currentInstallation = PFInstallation.currentInstallation()
                        currentInstallation.removeObject(self.theUser, forKey: "channels")
                        currentInstallation.saveInBackgroundWithBlock({
                            
                            (success:Bool!, pushError: NSError!) -> Void in
                            
                            if pushError == nil {
                                
                                self.areSubbed = false
                                println("the installtion did remove")
                                
                            }
                            else{
                                println("the installtion did not remove")
                            }

                            
                        })
       
                
            }       else {
                        println("fail")
                    }
                }
            }
        }
    }
    func updateFeed(){
        //Removes all leftover content in the array
        
        println("Before query")
        
        //adds content to the array
        var que = PFQuery(className: "Event")
        que.orderByAscending("startEvent")
        que.whereKey("author", equalTo: self.theUser)
        que.whereKey("public", equalTo: true)
        
        
        
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
                
                for object in objects{
                    
                    
                    self.publicPost.append(object["public"] as Bool)
                    self.objectID.append(object.objectId as String)
                    self.usernames.append(object["author"] as String)
                    self.eventTitle.append(object["eventLocation"] as String)
                    self.eventStartDate.append(object["startDate"] as String)
                    self.eventEndDate.append(object["endDate"] as String)
                    self.eventStartTime.append(object["startTime"] as String)
                    self.eventEndTime.append(object["endTime"] as String)
                    self.food.append(object["food"] as Bool)
                    self.paid.append(object["paid"] as Bool)
                    self.onsite.append(object["location"] as Bool)
                    self.eventEnd.append(object["endEvent"] as NSDate)
                    self.eventStart.append(object["startEvent"] as NSDate)
                    self.eventlocation.append(object["eventTitle"] as String)
                    
                    
                }
                
                self.populateSectionInfo()
                self.theFeed.reloadData()
                self.refresher.endRefreshing()
                
            }
            else{
                println("Something went south: \(eventError) ")
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
            println()
            println()
            println()
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
        //For each date
        sectionNames.insert("0", atIndex: 0)
        for date in eventStartDate{
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
            
            
            var dateFormatter2 = NSDateFormatter()
            dateFormatter2.locale = NSLocale.currentLocale()
            dateFormatter2.dateFormat = " EEEE MMM, dd yyyy"
            var realDate2 = dateFormatter2.stringFromDate(i)
            var dateFormatter3 = NSDateFormatter()
            dateFormatter3.timeStyle = NSDateFormatterStyle.ShortStyle
            var localTime = dateFormatter3.stringFromDate(i)
            
            self.localizedEndTime.append(localTime)
            
            
        }
        //Because the loop is broken before a new date is found, that
        //  one needs to be added manually
        
        rowsInSection.append(i)
        numSections++
        
        if numSections == 0 {
            println("Yo")
            numSections++
        }
        else {
            
            println("Hey it doesnt work")
            
            
        }
        
        
        
        println()
        println(rowsInSection)
        println(numSections)
        println(sectionNames)
        println()
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
            let cell2:profileCell = tableView.dequeueReusableCellWithIdentifier("profile") as profileCell
            if self.areSubbed == true {
                
                //cell2.subscribe.setImage("", forState: UIControlState.Normal)
                
            }
            else {
                
                //cell2.subscribe.setImage("", forState: UIControlState.Normal)
                
            }
            //THIS IS WHERE YOU ARE GOING TO PUT THE LABEL
            cell2.subscribe.addTarget(self, action: "subbing:", forControlEvents: UIControlEvents.TouchUpInside)
            
            cell2.subscriberTick.text = "\(self.amountofsubs.count)"
            cell2.subscriptionTick.text = "\(self.amountofScript.count)"
            
            return cell2
        }

        var cell:dateCell = tableView.dequeueReusableCellWithIdentifier("dateCell") as dateCell
        
        cell.dateItem.text = sectionNames[section]
        return cell
    }
    
    func subbing(sender: AnyObject) {
        var que = PFQuery(className: "Subs")
        
        que.whereKey("follower", equalTo:PFUser.currentUser().username)
        que.whereKey("following", equalTo: theUser)
        que.getFirstObjectInBackgroundWithBlock{
            
            
            (object:PFObject!, error: NSError!) -> Void in
            
            if object == nil {
                
                var currentInstallation = PFInstallation.currentInstallation()
                currentInstallation.addUniqueObject(self.theUser, forKey: "channels")
                currentInstallation.saveInBackgroundWithBlock({
                    
                    (success:Bool!, saveerror: NSError!) -> Void in
                    
                    if saveerror == nil {
                        
                        println("it worked")
                        
                    }
                        
                    else {
                        
                        println("It didnt work")
                        
                    }
                    
                    
                })
                
               println("Subscribed to user")
                var subscribe = PFObject(className: "Subs")
                let data = [
                    "alert" : "\(PFUser.currentUser().username) has subscribed to you ",
                    "badge" : "Increment",
                    "sound" : "default"
                ]
                var push = PFPush()
                var pfque = PFInstallation.query()
                pfque.whereKey("user", equalTo: self.theUser)
                push.setQuery(pfque)
               push.setData(data)
                push.sendPushInBackgroundWithBlock({
                    
                    (success:Bool!, pushError: NSError!) -> Void in
                    
                    if pushError == nil {
                        
                        println("IT WORKED")
                        
                    }
                    
                })
                
                subscribe["member"] = false
                subscribe["follower"] = PFUser.currentUser().username
                subscribe["following"] = self.theUser
                subscribe.saveInBackgroundWithBlock{
                    
                    (success:Bool!,subError:NSError!) -> Void in
                    
                    if (subError == nil){
                        
                        
                        var notify = PFObject(className: "Notification")
                        notify["sender"] = PFUser.currentUser().username
                        notify["receiver"] = self.theUser
                        notify["type"] =  "sub"
                        notify.saveInBackgroundWithBlock({
                            
                            (success:Bool!, notifyError: NSError!) -> Void in
                            
                            if notifyError == nil {
                                
                                println("notifcation has been saved")
                                
                            }
                            
                            
                        })
                        
                        
                        
                    }
                    
                    
                    
                }
                
            }
                
            else {
                
                
                println("USer has unsubscribe")
                var unsub = PFQuery(className: "Subs")
                
                unsub.whereKey("follower", equalTo:PFUser.currentUser().username)
                unsub.whereKey("following", equalTo: self.theUser)
                unsub.getFirstObjectInBackgroundWithBlock{
                    
                    (object:PFObject!, error: NSError!) -> Void in
                    
                    
                    if object != nil{
                        
                        
                        object.delete()
                        var currentInstallation = PFInstallation.currentInstallation()
                        currentInstallation.removeObject(self.theUser, forKey: "channels")
                        currentInstallation.saveInBackgroundWithBlock({
                            
                            (success:Bool!, pushError: NSError!) -> Void in
                            
                            if pushError == nil {
                                
                                println("the installtion did remove")
                                
                            }
                            else{
                                println("the installtion did not remove")
                            }
                            
                            
                        })
                        
                        
                    }       else {
                        println("fail")
                    }
                }
            }
        }

        
        
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        return rowsInSection[section]
        
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            
            return 150.0
        }
        return 40.0
    }
    
    
    func ChangeSub(){
        
        var que = PFQuery(className: "Subs")
        
        que.whereKey("follower", equalTo:PFUser.currentUser().username)
        que.whereKey("following", equalTo: theUser)
        que.getFirstObjectInBackgroundWithBlock{
            
            (object:PFObject!, error: NSError!) -> Void in
            
            
            if object == nil{
                
               
                
            }
            
            else {
                
               //self.subbutton.setTitle("Unsubscribe", forState: UIControlState.Normal)
                
            }
            
            
        }


    }



    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        // Puts the data in a cell
        
        var cell:eventCell = tableView.dequeueReusableCellWithIdentifier("cell2") as eventCell
        
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
        cell.time.text = eventStartTime[event]
        cell.eventName.text = eventlocation[event]
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
        
        
        var eventStore : EKEventStore = EKEventStore()
        eventStore.requestAccessToEntityType(EKEntityTypeEvent, completion: {
            
            granted, error in
            if (granted) && (error == nil) {
                println("granted \(granted)")
                println("error  \(error)")
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
                var notify = PFObject(className: "Notification")
                notify["sender"] = PFUser.currentUser().username
                notify["receiver"] = self.usernames[sender.tag]
                notify["type"] =  "calendar"
                notify.saveInBackgroundWithBlock({
                    
                    (success:Bool!, notifyError: NSError!) -> Void in
                    
                    if notifyError == nil {
                        
                        println("notifcation has been saved")
                        
                    }
                    
                    
                })
                
                
                var hosted = "Hosted by \(self.usernames[sender.tag])"
                var event:EKEvent = EKEvent(eventStore: eventStore)
                event.title = self.eventTitle[sender.tag]
                
                event.startDate = self.eventStart[sender.tag]
                event.endDate = self.eventEnd[sender.tag]
                event.notes = hosted
                event.location = self.eventlocation[sender.tag]
                event.calendar = eventStore.defaultCalendarForNewEvents
                eventStore.saveEvent(event, span: EKSpanThisEvent, error: nil)
                println("Saved Event")
                
            }
        })
        updateFeed()
    }
    
    override func prepareForSegue(segue:UIStoryboardSegue, sender: AnyObject?){
        
        if segue.identifier == "example" {
            var secondViewController : postEvent = segue.destinationViewController as postEvent
            
            
            
            
            var indexPath = theFeed.indexPathForSelectedRow() //get index of data for selected row
            var section = indexPath?.section
            var row = indexPath?.row
            
            var index = getEventIndex(section!, row: row!)
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
