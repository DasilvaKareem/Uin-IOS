//
//  eventFeedViewController.swift
//  UinProto2
//
//  Created by Kareem Dasilva on 1/9/15.
//  Copyright (c) 2015 Kareem Dasilva. All rights reserved.
//  This is the main feed for the appilcation

import UIKit
import EventKit

class eventFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UITextFieldDelegate {
    

    @IBOutlet weak var theFeed: UITableView!
    
    @IBOutlet var eventCreate: UIBarButtonItem!
    @IBOutlet var menuTrigger: UIBarButtonItem!
    var refresher: UIRefreshControl!

    //Text that is display on cell
  
    var usernames = [String]()
    //Creats  single event  objects
    struct Event {
        //Add author REAL NAME TO IT
        var organizationID = (String)()
        
        var title = (String)()
        var address = (String)()
        var location = (String)()
        //Start and end date of Event
        var end = (NSDate)()
        var start = (NSDate)()
        var tag1 = (String)()
        var tag2 = (String)()
        var tag3 = (String)()
        var eventID = (String)()
        var publicPost = (Bool)()
    }
    var events = [Event]() //holds all the events in the feed
    
   
    //Date Header information
    var numSections = 0 //Number of unique Ids
    var rowsInSection = [Int]() //Number of events in each date
    var sectionNames = [String]() // Date title
    //Geo-locations
    var currentPoint = (PFGeoPoint)()
    var eventCountNumber = (Int)()
    //If Feed has a problem
    var appProblem:Bool = false
    var channelID = "localEvent"
    var alertTime:NSTimeInterval = -3600
    //Search functionailty
    var searchActive:Bool = Bool()
    struct searchItem {
        var type = (String)() //Type of search item
        var name = (String)()
        var id = (String)() //object id of item
    }
    var filteredSearchItems = [searchItem]() //the displayed search itmes
    var diction = [String:[String]]()
    var searchItems = [searchItem]() // the array that contains search itme
    @IBOutlet var searchBar: UISearchBar!
    //Fills all events into an array to be search through
    
    //Removes keyboard

    func getSearchItems() {
        
        let eventQuery = PFQuery(className: "Event")
        eventQuery.whereKey("start", greaterThanOrEqualTo: NSDate())
        eventQuery.whereKey("isPublic", equalTo: true)
        eventQuery.findObjectsInBackgroundWithBlock({
            (results: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                for object in results!{
                    self.searchItems.append(searchItem(type: "Event", name: object["title"] as! String, id: object.objectId!))

                }
                let userQuery = PFUser.query()!
                userQuery.findObjectsInBackgroundWithBlock({
                    (objects: [PFObject]?, error: NSError?) -> Void in
                    if error == nil {
                        for object in results!{
                            self.searchItems.append(searchItem(type: "Username", name: object["username"] as! String, id: object.objectId!))
                            
                            
                        }
                    }
                })
            }
        })
    }
    
    func searchBarResultsListButtonClicked(searchBar: UISearchBar) {
        self.searchActive = false
        print("THe result button was button", terminator: "")
    }
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.searchActive = true;
        self.searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        endSearch()
        self.theFeed.reloadData()
    }
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        self.searchActive = false;
    }
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.searchActive = false;
        self.searchBar.showsCancelButton = false
    }
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.filteredSearchItems = self.searchItems.filter({( searchItem: searchItem) -> Bool in
            let stringMatch = searchItem.name.rangeOfString(searchText)
            return  (stringMatch != nil)
        
        })
        self.theFeed.reloadData()
    }
    func endSearch() {
        self.searchBar.endEditing(true)
        self.searchActive = false
        self.searchBar.text = ""
        self.searchBar.setShowsCancelButton(false, animated: true)
    }
    
    //Left panel Configurations

    // View cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Loads search Items
        searchBar.delegate = self
        //getSearchItems()
        let theMix = Mixpanel.sharedInstance()
        theMix.track("Event Feed Opened")
        theMix.flush()
        //Creates search about tableview
        var newBounds:CGRect = self.theFeed.bounds
        newBounds.origin.y = newBounds.origin.y - searchBar.bounds.size.height
        self.theFeed.bounds = newBounds
       
        

        //Changes the navbar background
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navBarBackground.png"), forBarMetrics: UIBarMetrics.Default)
    
        // Changes text color on navbar
        let nav = self.navigationController?.navigationBar
        nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()];
      
        
        //Gets current notfications
      
        
        //Adds pull to refresh
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.theFeed.addSubview(refresher)

    
    }
    
    override func viewWillDisappear(animated: Bool) {
        print("View disappear", terminator: "")
        endSearch()
        
    }
    override func viewWillAppear(animated: Bool) {
      
        print("", terminator: "")
        setupCalendar()
        updateFeed()
        //Setups Ui
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navBarBackground.png"), forBarMetrics: UIBarMetrics.Default)
        if self.revealViewController() != nil {
            menuTrigger.target = self.revealViewController()
            menuTrigger.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
    }
    override func viewDidAppear(animated: Bool) {
        
    }
    
    //2 nav buttons 1 leads to settings while the other send to log in
    @IBAction func eventMake(sender: AnyObject) {
       
        //Checks if the account is a temporary account
       
           self.performSegueWithIdentifier("eventMake", sender: self)
            
    }
   
    // Alert function
    func displayAlert(title:String, error:String) {
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        func preferredStatusBarStyle() -> UIStatusBarStyle {
            return UIStatusBarStyle.Default
        }
        
    }
    
    func setupCalendar(){
        if channelID != "localEvent" || channelID != "subbedEvents" {
            let calendarQue = PFQuery(className: "Channel")
            calendarQue.getObjectInBackgroundWithId(channelID, block: {
                (object: PFObject?, error: NSError?) -> Void in
                if error == nil {
                    let pObject = object!
                    self.navigationItem.title = pObject["name"] as! String
                    self.alertTime = pObject["alertTime"] as! NSTimeInterval
                } else {
                    print(error.debugDescription)
                }
                
            })
        }
    }
    func updateFeed(){
       //where updating the feed takes place
        events.removeAll()
        let query = PFQuery(className: "Event")
        query.orderByDescending("start")
        query.whereKey("start", greaterThanOrEqualTo: NSDate())
        query.whereKey("isDeleted", equalTo: false)
        query.findObjectsInBackgroundWithBlock({
            (objects: [PFObject]?, error: NSError?) -> Void in
            print(objects!.count)
            for object in objects! {
                print(object)
                var event = Event()
                event.eventID = object.objectId!
                event.address = object["address"] as! String
                event.end = object["end"] as! NSDate!
                event.start = object["start"] as! NSDate!
                event.tag1 = ""
                event.tag2 = ""
                event.tag3 = ""
                if object["hasFood"] as! Bool == true {
                    event.tag1 = "Food"
                }
                if object["onCampus"] as! Bool == true {
                    event.tag2 = "Campus"
                }
                if object["isFree"] as! Bool == true {
                    event.tag3 = "Free"
                }
                
                event.publicPost = object["isPublic"] as! Bool
                event.location = object["location"] as! String
                event.title = object["title"] as! String
                event.organizationID = object["authorID"] as! String
                self.events.append(event)
            }
            self.populateSectionInfo()
            self.theFeed.reloadData()
            self.refresher.endRefreshing()
        })
    }
 
    func refresh() {
        
        endSearch()
        updateFeed()
        
    }
    var localizedTime = [String]()
    var localizedEndTime = [String]()
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
        for i in events {
            //SORTS OUT EVENT STARTING TIME AND CREATES EVENT HEADER TIMES AND SHORTNED TIMES
            
            let dateFormatter = NSDateFormatter()
            //Creates table header for event time
            dateFormatter.locale = NSLocale.currentLocale() // Gets current locale and switches
            dateFormatter.dateFormat = "EEEE, MMM dd" // Formart for date I.E Monday, 03 1996
            let headerDate = dateFormatter.stringFromDate(i.start) // Creates date
            convertedDates.append(headerDate)
            dateFormatter.dateFormat = "MMM dd, yyyy"
            var shortenTime = dateFormatter.stringFromDate(i.start)
            
            //Creates Time for Event from NSDAte
            let timeFormatter = NSDateFormatter() //Formats time
            timeFormatter.locale = NSLocale.currentLocale()
            timeFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
            let localTime = timeFormatter.stringFromDate(i.start)
            
            self.localizedTime.append(localTime)
            
            
        }
        
        for i in events {
             //SORTS OUT EVENT ENDING TIME AND CREATES EVENT HEADER TIMES AND SHORTNED TIMES
            
            let dateFormatter = NSDateFormatter()
            //Creates table header for event time
            dateFormatter.locale = NSLocale.currentLocale() // Gets current locale and switches
            var headerDate = dateFormatter.stringFromDate(i.end) // Creates date
            dateFormatter.dateFormat = "MMM dd, yyyy"
            var shortenTime = dateFormatter.stringFromDate(i.end)
            
            //Creates Time for Event from NSDAte
            let timeFormatter = NSDateFormatter() //Formats time
            timeFormatter.locale = NSLocale.currentLocale()
            timeFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
            let localTime = timeFormatter.stringFromDate(i.end)
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
        if numSections == 0 {
            if rowsInSection.isEmpty {
                self.appProblem = true
            }
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell:dateCell = tableView.dequeueReusableCellWithIdentifier("dateCell") as! dateCell
        if appProblem {
            return nil
        } else {
            if searchActive {
                return nil
            } else {
                cell.dateItem.text = sectionNames[section]
            }
        }
       
        
        
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        if appProblem == true {
            return 1
        }
        if searchActive {
            return 1
        }
        return numSections
        
    }
    //Clears the search field and forces it to end and turns off the searcha active
   
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
     
        if searchActive == false {
            
            endSearch()
            self.performSegueWithIdentifier("event", sender: self)
            print("search is \(self.searchActive)", terminator: "")
            
        } else {
            if filteredSearchItems.count == 0 {
                print("No items selected", terminator: "")
            } else {
                let item = filteredSearchItems[indexPath.row]
                
                if item.type == "Event" {
                    endSearch()
                    self.performSegueWithIdentifier("searchEvent", sender: self)
                    print("search is \(self.searchActive)", terminator: "")
                    
                } else {
                    endSearch()
                    self.performSegueWithIdentifier("profile", sender: self)
                    print("search is \(self.searchActive)", terminator: "")
                }
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
      
        if(searchActive) {
            if filteredSearchItems.count == 0 {
                return 1
            } else {
                return filteredSearchItems.count
            }
            
        }
        if appProblem == true {
                return 1
        }
        
        return rowsInSection[section]
        
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25.0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 64.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        // Puts the data in a cell
        let cell:eventCell = tableView.dequeueReusableCellWithIdentifier("cell2") as! eventCell
       
            
    
        let event = getEventIndex(indexPath.section, row: indexPath.row)
        
        var section = indexPath.section
        var row = indexPath.row
            //Puts image for three icons
            let icon1:Icon = setIcon(events[event].tag1) //icon object for tag 1
            let icon2:Icon = setIcon(events[event].tag2) //icon object for tag 2
            let icon3:Icon = setIcon(events[event].tag3) //icon object for tag 3
            cell.tag1.image = icon1.iconImage
            cell.tag1Text.text = icon1.caption
        
            
            cell.tag2.image = icon2.iconImage
            cell.tag2Text.text = icon2.caption
            
            cell.tag3.image = icon3.iconImage
            cell.tag3Text.text = icon3.caption
        //cell.privateImage.image = UIImage(named: "poop")
        cell.people.text = events[event].organizationID
        cell.time.text = localizedTime[event]
        cell.eventName.text = events[event].title
        cell.uinBtn.tag = event
        cell.uinBtn.addTarget(self, action: "followButton:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        return cell
        
    }
    
    func followButton(sender: UIButton){
        // Adds the event to calendar
        let que = PFQuery(className: "UserCalendar")
        que.whereKey("author", equalTo: self.events[sender.tag].organizationID)
        que.whereKey("eventID", equalTo:self.events[sender.tag].eventID)
        
        que.getFirstObjectInBackgroundWithBlock {
            (results, queerror) -> Void in
            if queerror == nil {
                //Deletes the event
                results?.deleteInBackground()
                if results != nil {
                    sender.setImage(UIImage(named: "addToCalendar.png"), forState: UIControlState.Normal)
                    UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 3.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: ({
                        sender.frame.offsetInPlace(dx: 0, dy: 5.0)
                    }), completion: nil)
                    let eventStore : EKEventStore = EKEventStore()
                    let predicate2 = eventStore.predicateForEventsWithStartDate(self.events[sender.tag].start, endDate: self.events[sender.tag].end, calendars:nil)
                    let eV = eventStore.eventsMatchingPredicate(predicate2) as [EKEvent]!
                    print("Result is there")
                    if eV != nil { //
                        print("EV is not nil")
                        for i in eV {
                            print("\(i.title) this is the i.title")
                            if i.title == self.events[sender.tag].title  {
                                var theMix = Mixpanel.sharedInstance()
                                theMix.track("Removed from Calendar (EF)")
                                try! eventStore.removeEvent(i, span: EKSpan.ThisEvent)
                            }
                        }
                    }
                    
                    
                }
            } else {
                sender.setImage(UIImage(named: "addedToCalendar.png"), forState: UIControlState.Normal)
                UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 3.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: ({
                    sender.frame.offsetInPlace(dx: 0, dy: 5.0)
                }), completion: nil)
                let eventStore : EKEventStore = EKEventStore()
                eventStore.requestAccessToEntityType(EKEntityType.Event, completion: {
                    granted, error in
                    if (granted) && (error == nil) {
                        print("granted \(granted)")
                        print("error  \(error)")
                        var hosted = "Hosted by \(self.usernames[sender.tag]) address:\(self.events[sender.tag].address)"
                        var event:EKEvent = EKEvent(eventStore: eventStore)
                        event.title = self.events[sender.tag].title
                        event.startDate = self.events[sender.tag].start
                        event.endDate = self.events[sender.tag].end
                        event.notes = hosted
                        event.location = self.events[sender.tag].location
                        event.calendar = eventStore.defaultCalendarForNewEvents
                        try! eventStore.saveEvent(event, span: EKSpan.ThisEvent, commit: true)
                        
                        let going = PFObject(className: "UserCalendar")
                        going["user"] = PFUser.currentUser()!.username
                        going["userID"] = PFUser.currentUser()!.objectId
                        going["event"] = self.events[sender.tag].eventID
                        going["author"] = self.events[sender.tag].organizationID
                        going.saveInBackgroundWithBlock{
                            (succeded:Bool, savError:NSError?) -> Void in
                            if savError == nil {
                                print("it worked")
                                
                                
                            }
                        }
                        let theMix = Mixpanel.sharedInstance()
                        theMix.track("Added to Calendar (EF)")
                        print("saved")
                    }
                })
                print("the object does not exist")
                var push = PFPush()
                var pfque = PFInstallation.query()
                pfque!.whereKey("user", equalTo: self.usernames[sender.tag])
                push.setQuery(pfque)
                var pushCheck = PFUser.query() //Checks if users has push enabled
                pushCheck?.getObjectInBackgroundWithId(self.events[sender.tag].organizationID)
                print("Saved Event")
            }

           
            }
        
        
    }
    override func prepareForSegue(segue:UIStoryboardSegue, sender: AnyObject?){
        if segue.identifier == "event" {
            var secondViewController : postEvent = segue.destinationViewController as! postEvent
            let theMix = Mixpanel.sharedInstance()
            theMix.track("Opened Event View (EF)")
            let indexPath = theFeed.indexPathForSelectedRow //get index of data for selected row
            let section = indexPath?.section
            let row = indexPath?.row
            let index = getEventIndex(section!, row: row!)
            print(index)
            print(events[index].eventID)
            secondViewController.eventId = events[index].eventID       
        }
        if segue.identifier == "profile" {
            //Gets the indexpath for the filtered item
           
        }
        if segue.identifier == "searchEvent"{
            //Gets the indexpath for the filtered item
            let indexpath = theFeed.indexPathForSelectedRow
            let row = indexpath?.row
            let item = filteredSearchItems[row!]
            let theotherprofile:postEvent = segue.destinationViewController as! postEvent
            theotherprofile.eventId = item.id
            theotherprofile.searchEvent = true
        }
       
        
    }
}
