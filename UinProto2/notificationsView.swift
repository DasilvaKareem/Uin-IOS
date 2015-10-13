//
//  notificationsView.swift
//  UinProto2
//
//  Created by Kareem Dasilva on 2/14/15.
//  Copyright (c) 2015 Kareem Dasilva. All rights reserved.
//

import UIKit

class notificationsView: UITableViewController {
    
    @IBOutlet var sideBar: UIBarButtonItem!
    
    var notes = [String]()
    var refresher: UIRefreshControl!
    var times = [NSDate]()
    var localTime = [String]()
    struct notificationItem {
        var type = (String)()
        var senderID = (String)()
        var receiverID = (String)()
        var message = NSMutableAttributedString()
        var senderUsername = (String)()
        var receiverUsername = (String)()
        var eventID = (String)()
    }
    var notificationItems = [notificationItem]()
    
    override func viewDidAppear(animated: Bool) {
        
        let userTimeCheck = PFUser.currentUser()
        userTimeCheck["notificationsTimestamp"] = NSDate()
        userTimeCheck.saveInBackgroundWithBlock({
            (success:Bool, error:NSError!) -> Void in
            if error == nil {
                print("The stamp was updated")
            } else {
                print(error.debugDescription)
            }
        })
    }
    override func viewWillAppear(animated: Bool) {
          navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navBarBackground.png"), forBarMetrics: UIBarMetrics.Default)
    
        if self.revealViewController() != nil {
            sideBar.target = self.revealViewController()
            sideBar.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
                self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let theMix = Mixpanel.sharedInstance()
        theMix.track("Notifications Opened")
        theMix.flush()
       
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navBarBackground.png"), forBarMetrics: UIBarMetrics.Default)
        // Changes text color on navbar
        let nav = self.navigationController?.navigationBar
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
        /*
            Queries users Subscriptions and A2Cs then find last 15 notifcations
        
        */
        let followQue = PFQuery(className: "Subscription")
        followQue.whereKey("subscriberID", equalTo: PFUser.currentUser().objectId)
        followQue.findObjectsInBackgroundWithBlock{
            (objects:[AnyObject]!, folError:NSError!) -> Void in
            
            if folError == nil {
                
                for object in objects{
                    print("it worked")
                    self.folusernames.append(object["publisher"] as!String)
                }
                print(self.folusernames)
                let addedQue = PFQuery(className: "UserCalendar")
                addedQue.whereKey("userID", equalTo: PFUser.currentUser().objectId)
                addedQue.whereKeyExists("author")
                addedQue.findObjectsInBackgroundWithBlock{
                    (objects:[AnyObject]!, folError:NSError!) -> Void in
                    
                    if folError == nil {
                        
                        for object in objects{
                            self.addedUsernames.append(object["author"] as!String)
                        }
                    
                        let eventQuery = PFQuery(className: "Notification")
                        eventQuery.whereKey("type", equalTo: "event" )
                        eventQuery.whereKey("sender", containedIn: self.folusernames)
                        eventQuery.whereKeyExists("eventID")
                        eventQuery.whereKey("sender", notEqualTo: PFUser.currentUser().username)
                        
                        let subQuery = PFQuery(className: "Notification")
                        subQuery.whereKey("type", equalTo: "sub")
                        subQuery.whereKey("receiverID", equalTo: PFUser.currentUser().objectId)
                        
                        let deleteQuery = PFQuery(className: "Notification")
                        deleteQuery.whereKey("type", equalTo: "deleteEvent" )
                        deleteQuery.whereKeyExists("eventID")
                        deleteQuery.whereKey("sender", containedIn: self.addedUsernames)
                        deleteQuery.whereKey("sender", notEqualTo: PFUser.currentUser().username)
                        
                        let editQuery = PFQuery(className: "Notification")
                        editQuery.whereKey("type", equalTo: "editedEvent" )
                        editQuery.whereKeyExists("eventID")
                        editQuery.whereKey("sender", containedIn: self.addedUsernames)
                        editQuery.whereKey("sender", notEqualTo: PFUser.currentUser().username)
                        
                        let calendarQuery = PFQuery(className: "Notification")
                        calendarQuery.whereKey("receiver", equalTo: PFUser.currentUser().username)
                        calendarQuery.whereKeyExists("eventID")
                        calendarQuery.whereKey("type", equalTo: "calendar")
                        
                        let memberQuery = PFQuery(className: "Notification")
                        memberQuery.whereKey("receiver", equalTo: PFUser.currentUser().username)
                        memberQuery.whereKey("type", equalTo: "member")
                        
                        
                        let query = PFQuery.orQueryWithSubqueries([memberQuery, subQuery, calendarQuery, eventQuery, editQuery, deleteQuery ])
                        query.limit = 15
                        query.orderByDescending("createdAt")
                        query.findObjectsInBackgroundWithBlock({
                            (objects:[AnyObject]!,subError:NSError!) -> Void in
                            print("it queryed")
                            self.notificationItems.removeAll(keepCapacity: true)
                            if subError == nil {
                                //Setups NSSString and NSmutableatrString so we can make them nice and colorful
                                
                                var unEditedNote = (NSString)()
                                var note = NSMutableAttributedString()
                                for object in objects {
                                    
                                    //Adds the time so we can get time stamp
                                    self.times.append(object.createdAt)
                
                                    switch object["type"] as!String {
                                    case "event":
                                        
                                        //Creates an Atr. String that has yellow color
                                        let getEventname = PFQuery(className: "Event")
                                        let eventObject = getEventname.getObjectWithId(object["eventID"] as!String)
                                        let eventName =  eventObject["title"] as!NSString
                                        let current = object["sender"] as!NSString
                                        unEditedNote = "\(current) has created the event \(eventName)"
                                        note = NSMutableAttributedString(string: unEditedNote as String)
                                        //Add string attr here
                                        note.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 254.0/255.0, green: 186.0/255.0, blue: 1.0/255.0, alpha: 1), range: NSRange(location:current.length,length:unEditedNote.length - current.length))
                                        self.notificationItems.append(notificationItem(type: object["type"] as!String, senderID: object["senderID"] as!String, receiverID: object["receiverID"] as!String, message:note, senderUsername: object["sender"] as!String, receiverUsername: object["receiver"] as!String, eventID: object["eventID"] as!String))
                                        
                                        break
                                    case "editedEvent":
                                        //Creates an Atr. String that has green color
                                        let getEventname = PFQuery(className: "Event")
                                        let eventObject = getEventname.getObjectWithId(object["eventID"] as!String)
                                        let eventName =  eventObject["title"] as!NSString
                                        let current = object["sender"] as!NSString
                                        //Converts into a NSMutableString so we can get atr from the variables
                                        unEditedNote = "\(current) has edited the event, \(eventName)"
                                        note = NSMutableAttributedString(string: unEditedNote as String)
                                        //Add string attr here
                                        note.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 92.0/255.0, green: 184.0/255.0, blue: 113.0/255.0, alpha: 1), range: NSRange(location:current.length,length:unEditedNote.length - current.length))
                                        self.notificationItems.append(notificationItem(type: object["type"] as!String, senderID: object["senderID"] as!String, receiverID: object["receiverID"] as!String, message:note, senderUsername: object["sender"] as!String, receiverUsername: object["receiver"] as!String, eventID: object["eventID"] as!String))
                                        
                                        break
                                    case "deleteEvent":
                                        //Creates an Atr. String that has red color
                                        let getEventname = PFQuery(className: "Event")
                                        let eventObject = getEventname.getObjectWithId(object["eventID"] as!String)
                                        let eventName =  eventObject["title"] as!NSString
                                        let current = object["sender"] as!NSString
                                        //Converts into a NSMutableString so we can get atr from the variables
                                       unEditedNote = "\(current) has cancelled the event \(eventName)"
                                        note = NSMutableAttributedString(string: unEditedNote as String)
                                        note.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 219.0/255.0, green: 80.0/255.0, blue: 97.0/255.0, alpha: 1), range: NSRange(location:current.length,length:unEditedNote.length - current.length))
                                        self.notificationItems.append(notificationItem(type: object["type"] as!String, senderID: object["senderID"] as!String, receiverID: object["receiverID"] as!String, message:note, senderUsername: object["sender"] as!String, receiverUsername: object["receiver"] as!String, eventID: object["eventID"] as!String))
                                        
                                        break
                                    case "calendar":
                                        //Creates an Atr. String that has blue color
                                        let getEventname = PFQuery(className: "Event")
                                        let eventObject = getEventname.getObjectWithId(object["eventID"] as!String)
                                        let eventName =  eventObject["title"] as!NSString
                                        let current = object["sender"] as!NSString
                                        //Converts into a NSMutableString so we can get atr from the variables
                                        //Checks if the user is a anon users and changes the notfications
                                        let characterSet:NSMutableCharacterSet = NSMutableCharacterSet(charactersInString: "$")
                                    
                                        if current.rangeOfCharacterFromSet(characterSet).location != NSNotFound {
                                            unEditedNote = "Someone has added your event, \(eventName), to their calendar" //Use fixed length becasue someone is always someone LOL
                                            note = NSMutableAttributedString(string: unEditedNote as String)
                                            note.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 66.0/255.0, green: 146.0/255.0, blue: 198.0/255.0, alpha: 1), range: NSRange(location:8,length:22 + eventName.length))
                                        } else {
                                           unEditedNote = "\(current) has added your event, \(eventName), to their calendar"
                                            note = NSMutableAttributedString(string: unEditedNote as String)
                                            note.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 66.0/255.0, green: 146.0/255.0, blue: 198.0/255.0, alpha: 1), range: NSRange(location:current.length,length:24 + eventName.length))
                                       }
                                        
                                        self.notificationItems.append(notificationItem(type: object["type"] as!String, senderID: object["senderID"] as!String, receiverID: object["receiverID"] as!String, message:note, senderUsername: object["sender"] as!String, receiverUsername: object["receiver"] as!String, eventID: object["eventID"] as!String))
                                        
                                        break
                                        
                                    case "sub":
                                        //Creates an Atr. String that has purplish color
                                        let current = object["sender"] as!NSString
                                        unEditedNote = "\(current) subscribed to you"
                                        //Converts into a NSMutableString so we can get atr from the variables
                                        note = NSMutableAttributedString(string: unEditedNote as String)
                                        //Add string attr here
                                        note.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 182.0/255.0, green: 96.0/255.0, blue: 165.0/255.0, alpha: 1), range: NSRange(location:current.length,length:11))

                                        self.notificationItems.append(notificationItem(type: object["type"] as!String, senderID: object["senderID"] as!String, receiverID: object["receiverID"] as!String, message:note, senderUsername: object["sender"] as!String, receiverUsername: object["receiver"] as!String, eventID: "nil"))
                                        
                                        break
                                        
                                    case "member":
                                        //Creates an Atr. String that has purplish color
                                        let current = object["sender"] as!NSString
                                        unEditedNote = "\(current) has change your member status"
                                        //Converts into a NSMutableString so we can get atr from the variables
                                        note = NSMutableAttributedString(string: unEditedNote as String)
                                        note.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 182.0/255.0, green: 96.0/255.0, blue: 165.0/255.0, alpha: 1), range: NSRange(location:current.length ,length:30))
                                        self.notificationItems.append(notificationItem(type: object["type"] as!String, senderID: object["senderID"] as!String, receiverID: object["receiverID"] as!String, message:note, senderUsername: object["sender"] as!String, receiverUsername: object["receiver"] as!String, eventID: "nil"))
                                        
                                        
                                        break
                                    default:
                                        print("unknown has happen please refer back to parse database")
                                        break
                                    }
                                }
                                for i in self.times {
                                    let dateFormatter = NSDateFormatter()
                                    //Creates table header for event time
                                    dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
                                    let completeDate = dateFormatter.stringFromDate(i)
                                    //Creates Time for Event from NSDAte
                                    let timeFormatter = NSDateFormatter() //Formats time
                                    timeFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
                                    let localTime = timeFormatter.stringFromDate(i)
                                    self.localTime.append("\(completeDate) \(localTime)")
                                }
                                self.tableView.reloadData()
                                self.refresher.endRefreshing()
                            }
                        })
                    } else {
                        print("failed to get fetch addedusernames")
                    }
                    print(self.addedUsernames)
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
        let items = notificationItems[indexPath.row]
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
            print("error")
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
        let cell:subCell = tableView.dequeueReusableCellWithIdentifier("Cell") as! subCell
        let items = notificationItems[indexPath.row]
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
            print("error")
        }
        cell.timeStamp.text = localTime[indexPath.row]
        cell.notifyMessage.attributedText = items.message
        return cell
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  if segue.identifier == "event" {
    let indexpath = tableView.indexPathForSelectedRow
    let row = indexpath?.row
    let item = notificationItems[row!]
    let theotherprofile:postEvent = segue.destinationViewController as! postEvent
    theotherprofile.eventId = item.eventID
    theotherprofile.searchEvent = true
        }
if segue.identifier == "calendar" {
    let indexpath = tableView.indexPathForSelectedRow
    let row = indexpath?.row
    let item = notificationItems[row!]
    let theotherprofile:postEvent = segue.destinationViewController as! postEvent
    theotherprofile.eventId = item.eventID
    theotherprofile.searchEvent = true
        }

    }
}
