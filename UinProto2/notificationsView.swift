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
    
    func notify(){
        
        var folusernames = [String]()
        var followque = PFQuery(className: "Subscription")
        followque.whereKey("subscriber", equalTo: PFUser.currentUser().objectId)
        followque.findObjectsInBackgroundWithBlock{
            (objects:[AnyObject]!, folError:NSError!) -> Void in
            
            if folError == nil {
                
                for object in objects{
                    println("it worked")
                    folusernames.append(object["subscriber"] as String)
                }
            }
        }
        
        var eventQuery = PFQuery(className: "Notification")
        eventQuery.whereKey("type", equalTo: "event" )
        eventQuery.whereKey("sender", containedIn: folusernames)
        eventQuery.whereKey("sender", notEqualTo: PFUser.currentUser().username)
        
        var subQuery = PFQuery(className: "Notification")
        subQuery.whereKey("type", equalTo: "sub")
        subQuery.whereKey("receiverID", equalTo: PFUser.currentUser().objectId)
        
        var calendarQuery = PFQuery(className: "Notification")
        calendarQuery.whereKey("receiver", equalTo: PFUser.currentUser().username)
        calendarQuery.whereKeyExists("eventID")
        calendarQuery.whereKey("type", equalTo: "calendar")
        
        var memberQuery = PFQuery(className: "Notification")
        memberQuery.whereKey("receiver", equalTo: PFUser.currentUser().username)
        memberQuery.whereKey("type", equalTo: "member")
        
        
        var query = PFQuery.orQueryWithSubqueries([memberQuery, subQuery, calendarQuery, eventQuery ])
        query.limit = 15
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock({
            (objects:[AnyObject]!,subError:NSError!) -> Void in
            println("it queryed")
            if subError == nil {
                self.notificationItems.removeAll(keepCapacity: true)
                var note = (String)()
                for object in objects {
                    println(object.objectId)
                    
                    self.times.append(object.createdAt)
                    
                    
                    
                    switch object["type"] as String {
                    case "event":
                        var current = object["sender"] as String
                        note = "\(current) has made an event"
                        self.notificationItems.append(notificationItem(type: object["type"] as String, senderID: object["senderID"] as String, receiverID: object["receiverID"] as String, message:note, senderUsername: object["sender"] as String, receiverUsername: object["receiver"] as String, eventID: object["eventID"] as String))
                        
                        break
                    case "calendar":
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
                    
                    
                    //Creates Time for Event from NSDAte
                    var timeFormatter = NSDateFormatter() //Formats time
                    timeFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
                    var localTime = timeFormatter.stringFromDate(i)
                    self.localTime.append(localTime)
                }
                self.tableView.reloadData()
                self.refresher.endRefreshing()
            }
        })
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
        cell.timeStamp.text = localTime[indexPath.row]
        cell.notifyMessage.text = items.message
        println(items.message)
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
