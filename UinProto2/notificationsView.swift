//
//  notificationsView.swift
//  UinProto2
//
//  Created by Kareem Dasilva on 2/14/15.
//  Copyright (c) 2015 Kareem Dasilva. All rights reserved.
//

import UIKit

class notificationsView: UITableViewController {
    
    
    var notes = [String]()
    var refresher: UIRefreshControl!
    var times = [NSDate]()
    var localTime = [String]()
    struct notificationItem {
        var type = (String)()
        var senderID = (String)()
        var receiverID = (String)()
        var message = (String)()
        var senderUsername = (String)()
        var receiverUsername = (String)()
        var eventID = (String)()
    }
    var notificationItems = [notificationItem]()
    
    override func viewDidAppear(animated: Bool) {
        var tabArray = self.tabBarController?.tabBar.items as NSArray!
        var tabItem = tabArray.objectAtIndex(1) as UITabBarItem
        tabItem.badgeValue = nil
    }
    override func viewWillAppear(animated: Bool) {
          navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navBarBackground.png"), forBarMetrics: UIBarMetrics.Default)
        self.tabBarController?.tabBar.hidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        var theMix = Mixpanel.sharedInstance()
        theMix.track("Notifications Opened")
        theMix.flush()
        self.tabBarController?.tabBar.hidden = false
        var tabArray = self.tabBarController?.tabBar.items as NSArray!
        var tabItem = tabArray.objectAtIndex(1) as UITabBarItem
        tabItem.badgeValue = nil
        self.tabBarController?.tabBar.hidden = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navBarBackground.png"), forBarMetrics: UIBarMetrics.Default)
        // Changes text color on navbar
        var nav = self.navigationController?.navigationBar
        nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()];
        notify()
        //refresher
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refresher)
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.notes.removeAll(keepCapacity: true)
        notify()
    }
    
    //Gets all a2c receipents and subscribtions
    var addedUsernames = [String]() //array of users who add your event to calendar
    var folusernames = [String]()
    func collectData(){
        var followQue = PFQuery(className: "Subscription")
        followQue.whereKey("subscriberID", equalTo: PFUser.currentUser().objectId)
        followQue.findObjectsInBackgroundWithBlock{
            (objects:[AnyObject]!, folError:NSError!) -> Void in
            
            if folError == nil {
                
                for object in objects{
                    println("it worked")
                    self.folusernames.append(object["publisher"] as String)
                }
                println(self.folusernames)
                var addedQue = PFQuery(className: "UserCalendar")
                addedQue.whereKey("userID", equalTo: PFUser.currentUser().objectId)
                addedQue.whereKeyExists("author")
                addedQue.findObjectsInBackgroundWithBlock{
                    (objects:[AnyObject]!, folError:NSError!) -> Void in
                    
                    if folError == nil {
                        
                        for object in objects{
                            self.addedUsernames.append(object["author"] as String)
                        }
                    
                        var eventQuery = PFQuery(className: "Notification")
                        eventQuery.whereKey("type", equalTo: "event" )
                        eventQuery.whereKey("sender", containedIn: self.folusernames)
                        eventQuery.whereKey("sender", notEqualTo: PFUser.currentUser().username)
                        
                        var subQuery = PFQuery(className: "Notification")
                        subQuery.whereKey("type", equalTo: "sub")
                        subQuery.whereKey("receiverID", equalTo: PFUser.currentUser().objectId)
                        
                        var deleteQuery = PFQuery(className: "Notification")
                        deleteQuery.whereKey("type", equalTo: "editedEvent" )
                        deleteQuery.whereKey("sender", containedIn: self.addedUsernames)
                        deleteQuery.whereKey("sender", notEqualTo: PFUser.currentUser().username)
                        
                        var editQuery = PFQuery(className: "Notification")
                        editQuery.whereKey("type", equalTo: "deleteEvent" )
                        editQuery.whereKey("sender", containedIn: self.addedUsernames)
                        editQuery.whereKey("sender", notEqualTo: PFUser.currentUser().username)
                        
                        var calendarQuery = PFQuery(className: "Notification")
                        calendarQuery.whereKey("receiver", equalTo: PFUser.currentUser().username)
                        calendarQuery.whereKeyExists("eventID")
                        calendarQuery.whereKey("type", equalTo: "calendar")
                        
                        var memberQuery = PFQuery(className: "Notification")
                        memberQuery.whereKey("receiver", equalTo: PFUser.currentUser().username)
                        memberQuery.whereKey("type", equalTo: "member")
                        
                        
                        var query = PFQuery.orQueryWithSubqueries([memberQuery, subQuery, calendarQuery, eventQuery, editQuery, deleteQuery ])
                        query.limit = 15
                        query.orderByDescending("createdAt")
                        query.findObjectsInBackgroundWithBlock({
                            (objects:[AnyObject]!,subError:NSError!) -> Void in
                            println("it queryed")
                            if subError == nil {
                                self.notificationItems.removeAll(keepCapacity: true)
                                var note = (String)()
                                for object in objects {
                                    
                                    
                                    self.times.append(object.createdAt)
                                    
                                    
                                    
                                    switch object["type"] as String {
                                    case "event":
                                        
                                        
                                        var getEventname = PFQuery(className: "Event")
                                        var eventObject = getEventname.getObjectWithId(object["eventID"] as String)
                                        var eventName =  eventObject["title"] as String
                                        var current = object["sender"] as String
                                        note = "\(current) has made an event,\(eventName)"
                                        println("Hey you actuallt got an event notficiations")
                                        self.notificationItems.append(notificationItem(type: object["type"] as String, senderID: object["senderID"] as String, receiverID: object["receiverID"] as String, message:note, senderUsername: object["sender"] as String, receiverUsername: object["receiver"] as String, eventID: object["eventID"] as String))
                                        
                                        break
                                    case "editedEvent":
                                        
                                        var getEventname = PFQuery(className: "Event")
                                        var eventObject = getEventname.getObjectWithId(object["eventID"] as String)
                                        var eventName =  eventObject["title"] as String
                                        var current = object["sender"] as String
                                        note = "\(current) has edited an event,\(eventName)"
                                        self.notificationItems.append(notificationItem(type: object["type"] as String, senderID: object["senderID"] as String, receiverID: object["receiverID"] as String, message:note, senderUsername: object["sender"] as String, receiverUsername: object["receiver"] as String, eventID: object["eventID"] as String))
                                        
                                        break
                                    case "deleteEvent":
                                       
                                        var getEventname = PFQuery(className: "Event")
                                        var eventObject = getEventname.getObjectWithId(object["eventID"] as String)
                                        var eventName =  eventObject["title"] as String
                                        var current = object["sender"] as String
                                        note = "\(current) has cancelled an event,\(eventName)"
                                        self.notificationItems.append(notificationItem(type: object["type"] as String, senderID: object["senderID"] as String, receiverID: object["receiverID"] as String, message:note, senderUsername: object["sender"] as String, receiverUsername: object["receiver"] as String, eventID: object["eventID"] as String))
                                        
                                        break
                                    case "calendar":
                                        
                                        var getEventname = PFQuery(className: "Event")
                                        var eventObject = getEventname.getObjectWithId(object["eventID"] as String)
                                        var eventName =  eventObject["title"] as String
                                        var current = object["sender"] as String
                                        //Checks if the user is a anon users and changes the notfications
                                        var characterSet:NSCharacterSet = NSCharacterSet(charactersInString: "$")
                                        var eventnote = ""
                                        
                                        if current.rangeOfCharacterFromSet(characterSet) != nil {
                                            note = "Someone has added your event to their calendar"
                                        } else {
                                            note = "\(current) has added your event to their calendar"
                                        }
                                        self.notificationItems.append(notificationItem(type: object["type"] as String, senderID: object["senderID"] as String, receiverID: object["receiverID"] as String, message:note, senderUsername: object["sender"] as String, receiverUsername: object["receiver"] as String, eventID: object["eventID"] as String))
                                        
                                        break
                                        
                                    case "sub":
                                        
                                        var current = object["sender"] as String
                                        note = "\(current) has subscribed to you"
                                        self.notificationItems.append(notificationItem(type: object["type"] as String, senderID: object["senderID"] as String, receiverID: object["receiverID"] as String, message:note, senderUsername: object["sender"] as String, receiverUsername: object["receiver"] as String, eventID: "nil"))
                                        
                                        break
                                        
                                    case "member":
                                        
                                        var current = object["sender"] as String
                                        note = "\(current) has change your member status"
                                        self.notificationItems.append(notificationItem(type: object["type"] as String, senderID: object["senderID"] as String, receiverID: object["receiverID"] as String, message:note, senderUsername: object["sender"] as String, receiverUsername: object["receiver"] as String, eventID: "nil"))
                                        
                                        
                                        break
                                    default:
                                        println("unknown has happen please refer back to parse database")
                                        break
                                    }
                                    
                                }
                                
                                for i in self.times {
                                    var dateFormatter = NSDateFormatter()
                                    //Creates table header for event time
                                    dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
                                    var completeDate = dateFormatter.stringFromDate(i)
                                    //Creates Time for Event from NSDAte
                                    var timeFormatter = NSDateFormatter() //Formats time
                                    timeFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
                                    var localTime = timeFormatter.stringFromDate(i)
                                    self.localTime.append("\(completeDate) \(localTime)")
                                }
                                self.tableView.reloadData()
                                self.refresher.endRefreshing()
                            }
                        })
                    } else {
                        println("failed to get fetch addedusernames")
                    }
                    println(self.addedUsernames)
                }

            }
        }
        
         }
    func notify(){
        
        collectData()
        
 
       
    }
    func refresh() {
        notify()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var items = notificationItems[indexPath.row]
        switch items.type {
        case "event":
            self.performSegueWithIdentifier("event", sender: self)
            break
        case "editedEvent":
            self.performSegueWithIdentifier("event", sender: self)
            break
        case "deleteEvent":
          
            break
        case "calendar":
            self.performSegueWithIdentifier("calendar", sender: self)
            break
        case "sub":
            self.performSegueWithIdentifier("sub", sender: self)
            break
        case "member":
            self.performSegueWithIdentifier("sub", sender: self)
        default:
            println("error")
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return notificationItems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:subCell = tableView.dequeueReusableCellWithIdentifier("Cell") as subCell
        var items = notificationItems[indexPath.row]
        switch items.type {
            case "event":
                cell.noteImage.image = UIImage(named: "noteCreated")
            break
            case "editedEvent":
                cell.noteImage.image = UIImage(named: "noteEdited")
            break
        case "deleteEvent":
                cell.noteImage.image = UIImage(named: "noteDeleted")
            break
        case "calendar":
                cell.noteImage.image = UIImage(named: "noteAdded")
            break
        case "sub":
                cell.noteImage.image = UIImage(named: "noteSubbed")
            break
        case "member":
                cell.noteImage.image = UIImage(named: "noteSubbed")
            break
        default:
            println("error")
        }
        cell.timeStamp.text = localTime[indexPath.row]
        cell.notifyMessage.text = items.message
        return cell
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  if segue.identifier == "event" {
    var indexpath = tableView.indexPathForSelectedRow()
    var row = indexpath?.row
    var item = notificationItems[row!]
    var theotherprofile:postEvent = segue.destinationViewController as postEvent
    theotherprofile.eventId = item.eventID
    theotherprofile.searchEvent = true
        }
if segue.identifier == "calendar" {
    var indexpath = tableView.indexPathForSelectedRow()
    var row = indexpath?.row
    var item = notificationItems[row!]
    var theotherprofile:postEvent = segue.destinationViewController as postEvent
    theotherprofile.eventId = item.eventID
    theotherprofile.searchEvent = true
        }
if segue.identifier == "sub" {
var indexpath = tableView.indexPathForSelectedRow()
var row = indexpath?.row
//selects the view controller
var theotherprofile:userprofile = segue.destinationViewController as userprofile
var item = notificationItems[row!]
theotherprofile.theUser = item.senderUsername
theotherprofile.userId = item.senderID
        }
    }
}
