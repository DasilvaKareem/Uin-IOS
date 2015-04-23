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
    //Icons variables
    var onsite = [Bool]()
    var paid = [Bool]()
    var food = [Bool]()
    //Text that is display on cell
    var eventTitle = [String]()
    var eventAddress = [String]()
    var eventlocation = [String]()
    var eventStartTime = [String]()
    var eventEndTime = [String]()
    var eventStartDate = [String]()
    var eventEndDate = [String]()
    var usernames = [String]()
    //Event specfici ID and publicty status
    var objectID = [String]()
    var publicPost = [Bool]()
    //Start and end date of Event
    var eventEnd = [NSDate]()
    var eventStart = [NSDate]()
    var localizedTime = [String]() //Gets the current locale
    var localizedEndTime = [String]() //Gets the current locale
    //Id of the author of the event
    var userId = [String]()
    //Date Header information
    var numSections = 0 //Number of unique Ids
    var rowsInSection = [Int]() //Number of events in each date
    var sectionNames = [String]() // Date title
    //Geo-locations
    var currentPoint = (PFGeoPoint)()
    var eventCountNumber = (Int)()
    //If Feed has a problem
    var appProblem:Bool = Bool()
    var channelID = "localEvent"
    
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
        
        var eventQuery = PFQuery(className: "Event")
        eventQuery.whereKey("start", greaterThanOrEqualTo: NSDate())
        eventQuery.whereKey("isPublic", equalTo: true)
        eventQuery.findObjectsInBackgroundWithBlock({
            (results: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                for object in results{
                    self.searchItems.append(searchItem(type: "Event", name: object["title"] as! String, id: object.objectId as String))

                }
                var userQuery = PFUser.query()
                userQuery.whereKey("tempAccounts", equalTo: false)
                userQuery.findObjectsInBackgroundWithBlock({
                    (results: [AnyObject]!, error: NSError!) -> Void in
                    if error == nil {
                        for object in results{
                            self.searchItems.append(searchItem(type: "Username", name: object["username"] as! String, id: object.objectId))
                            
                            
                        }
                    }
                })
            }
        })
    }
    
    func searchBarResultsListButtonClicked(searchBar: UISearchBar) {
        self.searchActive = false
        println("THe result button was button")
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
        getSearchItems()
        var theMix = Mixpanel.sharedInstance()
        theMix.track("Event Feed Opened")
        theMix.flush()
        
        //Creates search about tableview
        var newBounds:CGRect = self.theFeed.bounds
        newBounds.origin.y = newBounds.origin.y - searchBar.bounds.size.height
        self.theFeed.bounds = newBounds
       
        

        //Changes the navbar background
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navBarBackground.png"), forBarMetrics: UIBarMetrics.Default)
        
        // Changes text color on navbar
        var nav = self.navigationController?.navigationBar
        nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()];
      
        
        //Gets current notfications
        notifications()
        
        //Adds pull to refresh
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.theFeed.addSubview(refresher)

    
    }
    
    override func viewWillDisappear(animated: Bool) {
        println("View disappear")
        notifications()
        endSearch()
        
    }
    override func viewWillAppear(animated: Bool) {
      //  setupEventFeed()
        println()
        updateFeed()
        //Setups Ui
               navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navBarBackground.png"), forBarMetrics: UIBarMetrics.Default)
        
         var user = PFUser.currentUser()
       
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
        var user = PFUser.currentUser()
        //Checks if the account is a temporary account
        if user["tempAccounts"] as! Bool == false {
           self.performSegueWithIdentifier("eventMake", sender: self)
            var theMix = Mixpanel.sharedInstance()
            theMix.track("Tap Create Event (EF)")
            theMix.flush()
            

        } else {
            var theMix = Mixpanel.sharedInstance()
            theMix.track("Tap Create Account (EF)")
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
        }
    }
   
  
    // Checks for notifcations and compares to any notications you recieved during that time
    var old = (Int)()
    var newCheck = (Int)()
    func notifications() {
        
        var check = PFQuery(className: "Notification")
        check.whereKey("receiver", equalTo: PFUser.currentUser().username)
        check.whereKey("sender", notEqualTo: PFUser.currentUser().username)
        old = check.countObjects()
    }
    
    func checkNotifications() {
        
        var check = PFQuery(className: "Notification")
        check.whereKey("receiver", equalTo: PFUser.currentUser().username)
        check.whereKey("sender", notEqualTo: PFUser.currentUser().username)
         newCheck = check.countObjects()
        
        if self.old != self.newCheck {
            var diffrence = self.newCheck - self.old
            var tabArray = self.tabBarController?.tabBar.items as NSArray!
            var tabItem = tabArray.objectAtIndex(1) as! UITabBarItem
            tabItem.badgeValue = String(diffrence)
            
            println("You have gotten a new notification")
            
        }
        else {
          
            println("You do not have a any new notification ")
           
        }
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
    
      func updateFeed(){
        //Removes all leftover content in the array
    
        PFGeoPoint.geoPointForCurrentLocationInBackground {
            (geoPoint: PFGeoPoint!, error: NSError!) -> Void in
         
                    //Customizes Event Feed 
                    //Adds or remove the create event functionailty
                    println()
                    println()
                    println(self.channelID)
                    println()
                    println()
                    self.currentPoint = geoPoint
                    //adds content to the array
                    //Queries all public Events
                    var eventQuery = PFQuery(className: "Event")
                      var pubQue = PFQuery(className: "Subscription")
                    var superQue = PFQuery(className: "Event")
                    var newQue = PFQuery(className: "Event")
                    var query = PFQuery.orQueryWithSubqueries([eventQuery, superQue, newQue ])
                    switch self.channelID {
                        case "localEvent":
                            eventQuery.whereKey("inLocalFeed", equalTo: true)
                            eventQuery.whereKey("isPublic", equalTo: true)
                            //Queries all Private events
                            pubQue.whereKey("subscriber", equalTo: PFUser.currentUser().username)
                            pubQue.whereKey("isMember", equalTo: true)
                            superQue.whereKey("author", matchesKey: "publisher", inQuery:pubQue)
                            superQue.whereKey("inLocalFeed", equalTo: true)
                            superQue.whereKey("isPublic", equalTo: false)
                            //Queries all of the current user events
                            newQue.whereKey("isPublic", equalTo: false)
                            newQue.whereKey("author", equalTo: PFUser.currentUser().username)
                            newQue.whereKey("inLocalFeed", equalTo: true)
                            var userTimeCheck = PFUser.currentUser()
                            userTimeCheck["notificationsTimestamp"] = NSDate()
                            userTimeCheck.saveInBackgroundWithBlock({
                                (success:Bool, error:NSError!) -> Void in
                                if error == nil {
                                    println("The stamp was updated")
                                } else {
                                    println(error.debugDescription)
                                }
                            })
                       
                        break
                        case "subbedEvents":
                            var subscriptionQuery = PFQuery(className: "Subscription")
                            subscriptionQuery.whereKey("subscriberID", equalTo: PFUser.currentUser().objectId)
                            eventQuery.whereKey("authorID", matchesKey: "publisherID", inQuery: subscriptionQuery)
                            
                           //Queries all Private events
                            pubQue.whereKey("subscriberID", equalTo: PFUser.currentUser().objectId)
                            pubQue.whereKey("isMember", equalTo: true)
                            superQue.whereKey("authorID", matchesKey: "publisherID", inQuery:pubQue)
                            superQue.whereKey("isPublic", equalTo: false)
                            //Queries all of the current user events
                            newQue.whereKey("isPublic", equalTo: false)
                            newQue.whereKey("authorID", matchesKey: "publisherID", inQuery:pubQue)
                            newQue.whereKey("author", equalTo: PFUser.currentUser().username)
                            var userTimeCheck = PFUser.currentUser()
                            userTimeCheck["notificationsTimestamp"] = NSDate()
                            userTimeCheck.saveInBackgroundWithBlock({
                                (success:Bool, error:NSError!) -> Void in
                                if error == nil {
                                    println("The stamp was updated")
                                } else {
                                    println(error.debugDescription)
                                }
                            })
                      
                        
                        break
                        case "trending":
                            
                        break
                    default:
                        
                    
                        eventQuery.whereKey("channels", equalTo:self.channelID)
                        eventQuery.whereKey("isPublic", equalTo: true)
                        
                        //Queries all Private events
                       
                        pubQue.whereKey("subscriber", equalTo: PFUser.currentUser().username)
                        pubQue.whereKey("isMember", equalTo: true)
                     
                        superQue.whereKey("channels", equalTo:self.channelID)
                          
                        superQue.whereKey("isPublic", equalTo: false)
                        
                        //Queries all of the current user events
                      
                        newQue.whereKey("isPublic", equalTo: false)
                        newQue.whereKey("channels", equalTo:self.channelID)
                        newQue.whereKey("author", equalTo: PFUser.currentUser().username)
            
                        break
                    }
           
                    
                    query.orderByAscending("start")
                    println(self.currentPoint)
            
                    //query.whereKey("locationGeopoint", nearGeoPoint: self.currentPoint, withinMiles: 7.0)
                    query.whereKey("start", greaterThanOrEqualTo: NSDate())
                    query.whereKey("isDeleted", equalTo: false)
                    query.findObjectsInBackgroundWithBlock {
                        (results: [AnyObject]!, error: NSError!) -> Void in
                        if error == nil {
                        
                            self.eventAddress.removeAll(keepCapacity: true)
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
                                self.userId.append(object["authorID"] as!String)
                                self.eventAddress.append(object["address"] as!String)
                                
                            }
                            self.populateSectionInfo()
                            self.theFeed.reloadData()
                            self.refresher.endRefreshing()
                            
                        }
                            
                            
                        else {
                            if error.code == 100 {
                                println("No internet")
                                self.displayAlert("No Internet", error: "You have no internet connection")
                            }
                            println("It failed")
                        }
                    }
                    
                
            
           /* if error == nil {
                self.theFeed.superview //Add tableview to screen
                self.currentPoint = geoPoint
                //adds content to the array
                //Queries all public Events
                var que1 = PFQuery(className: "Event")
                que1.whereKey("isPublic", equalTo: true)
                
                //Queries all Private events
                var pubQue = PFQuery(className: "Subscription")
                pubQue.whereKey("subscriber", equalTo: PFUser.currentUser().username)
                pubQue.whereKey("isMember", equalTo: true)
                var superQue = PFQuery(className: "Event")
                superQue.whereKey("author", matchesKey: "publisher", inQuery:pubQue)
                superQue.whereKey("isPublic", equalTo: false)
                
                //Queries all of the current user events
                var newQue = PFQuery(className: "Event")
                newQue.whereKey("isPublic", equalTo: false)
                newQue.whereKey("author", equalTo: PFUser.currentUser().username)
                
                
                var query = PFQuery.orQueryWithSubqueries([que1, superQue, newQue ])
                query.orderByAscending("start")
                println(self.currentPoint)
                query.whereKey("locationGeopoint", nearGeoPoint: self.currentPoint, withinMiles: 7.0)
                query.whereKey("start", greaterThanOrEqualTo: NSDate())
                query.whereKey("isDeleted", equalTo: false)
                self.eventCountNumber = query.countObjects()
               
            } */
            
        }
    }
 
    func refresh() {
        
        endSearch()
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
        sectionNames.removeAll(keepCapacity: true)
        self.localizedTime.removeAll(keepCapacity: true)
        self.localizedEndTime.removeAll(keepCapacity: true)
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
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var cell:dateCell = tableView.dequeueReusableCellWithIdentifier("dateCell") as! dateCell
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
            println("search is \(self.searchActive)")
            
        } else {
            if filteredSearchItems.count == 0 {
                println("No items selected")
            } else {
                var item = filteredSearchItems[indexPath.row]
                
                if item.type == "Event" {
                    endSearch()
                    self.performSegueWithIdentifier("searchEvent", sender: self)
                    println("search is \(self.searchActive)")
                    
                } else {
                    endSearch()
                    self.performSegueWithIdentifier("profile", sender: self)
                    println("search is \(self.searchActive)")
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
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        // Puts the data in a cell
        var cell:eventCell = tableView.dequeueReusableCellWithIdentifier("cell2") as! eventCell
        var poopled = ["no internet"]
        if appProblem == true {
            cell.onCampusIcon.image = nil
            cell.foodIcon.image = nil
            cell.freeIcon.image = nil
            cell.poop.hidden = true
            cell.foodText.text = ""
            cell.onCampusText.text = ""
            cell.costText.text = ""
            cell.eventName.text = "App problem"
            cell.people.text = ""
            cell.privateImage.image = nil
            cell.time.text = ""
        } else {
        if searchActive == true {
            println("search is active")
          
            if filteredSearchItems.count == 0 {
                cell.onCampusIcon.image = nil
                cell.foodIcon.image = nil
                cell.freeIcon.image = nil
                cell.poop.hidden = true
                cell.foodText.text = ""
                cell.onCampusText.text = ""
                cell.costText.text = ""
                cell.eventName.text = "No items found"
                cell.people.text = ""
                cell.privateImage.image = nil
                cell.time.text = ""
            } else {
                var items = filteredSearchItems[indexPath.row]
                cell.onCampusIcon.image = nil
                cell.foodIcon.image = nil
                cell.freeIcon.image = nil
                cell.poop.hidden = true
                cell.foodText.text = ""
                cell.onCampusText.text = ""
                cell.costText.text = ""
                cell.eventName.text = items.name
                cell.people.text = items.type
                cell.privateImage.image = nil
                cell.time.text = ""
                
            }
            
        
            
        } else {
            
    
        var event = getEventIndex(indexPath.section, row: indexPath.row)
        cell.poop.hidden = false
        var section = indexPath.section
        var row = indexPath.row
        
        //Puts image for three icons
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
        }
        }
        return cell
        
    }
    func followButton(sender: UIButton){
        // Adds the event to calendar
        
      var que = PFQuery(className: "UserCalendar")
        que.whereKey("user", equalTo: PFUser.currentUser().username)
        que.whereKey("author", equalTo: self.usernames[sender.tag])
        que.whereKey("eventID", equalTo:self.objectID[sender.tag])
        que.getFirstObjectInBackgroundWithBlock({
            (results:PFObject!, queerror: NSError!) -> Void in
            if queerror == nil {
                //Deletes the event
                results.delete()
              
                //Warns user if the this is the first event to be removed
                if PFUser.currentUser()["firstRemoveFromCalendar"] as!Bool == true{
                    PFUser.currentUser()["firstRemoveFromCalendar"] = false
                    PFUser.currentUser().save()
                    self.displayAlert("Remove", error: "Tapping the blue checkmark removes an event from your calendar.")
                }
              
                if results != nil {
                      sender.setImage(UIImage(named: "addToCalendar.png"), forState: UIControlState.Normal)
                    UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 3.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: ({
                        sender.frame.offset(dx: 0, dy: 5.0)
                    }), completion: nil)
                    var eventStore : EKEventStore = EKEventStore()
                    eventStore.requestAccessToEntityType(EKEntityTypeEvent, completion: {
                        
                        granted, error in
                        if (granted) && (error == nil) {
                            println("granted \(granted)")
                            println("error  \(error)")
                            var hosted = "Hosted by \(self.usernames[sender.tag]) address:\(self.eventAddress[sender.tag])"
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
                                println("removed")
                                var theMix = Mixpanel.sharedInstance()
                                theMix.track("Removed from Calendar (EF)")
                                eventStore.removeEvent(i, span: EKSpanThisEvent, error: nil)
                            }
                        }
                    }
                
                    
                }
            } else {
                sender.setImage(UIImage(named: "addedToCalendar.png"), forState: UIControlState.Normal)
                UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 3.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: ({
                    sender.frame.offset(dx: 0, dy: 5.0)
                }), completion: nil)
                var eventStore : EKEventStore = EKEventStore()
                eventStore.requestAccessToEntityType(EKEntityTypeEvent, completion: {
                    
                    granted, error in
                    if (granted) && (error == nil) {
                        println("granted \(granted)")
                        println("error  \(error)")
                        var hosted = "Hosted by \(self.usernames[sender.tag]) address:\(self.eventAddress[sender.tag])"
                        var event:EKEvent = EKEvent(eventStore: eventStore)
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
                        
                        var going = PFObject(className: "UserCalendar")
                        going["user"] = PFUser.currentUser().username
                        going["userID"] = PFUser.currentUser().objectId
                        going["event"] = self.eventTitle[sender.tag]
                        going["author"] = self.usernames[sender.tag]
                        going["eventID"] = self.objectID[sender.tag]
                        going.saveInBackgroundWithBlock{
                            (succeded:Bool, savError:NSError!) -> Void in
                            if savError == nil {
                                println("it worked")
                                
                                
                            }
                        }
                        var theMix = Mixpanel.sharedInstance()
                        theMix.track("Added to Calendar (EF)")
                        println("saved")
                    }
                })
                println("the object does not exist")
                var push = PFPush()
                var pfque = PFInstallation.query()
                pfque.whereKey("user", equalTo: self.usernames[sender.tag])
                push.setQuery(pfque)
                var pushCheck = PFUser.query() //Checks if users has push enabled
                var userCheck = pushCheck.getObjectWithId(self.userId[sender.tag])
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
                        (success:Bool, pushError: NSError!) -> Void  in
                        if pushError == nil {
                            println("Push was Sent")
                        }
                    })
                } else {
                    println("user does not have push enabled")
                }
            
                
                if self.usernames[sender.tag] != PFUser.currentUser().username {
                    var notify = PFObject(className: "Notification")
                    notify["sender"] = PFUser.currentUser().username
                    notify["receiver"] = self.usernames[sender.tag]
                    notify["senderID"] = PFUser.currentUser().objectId
                    notify["receiverID"] = self.userId[sender.tag]
                    notify["eventID"] = self.objectID[sender.tag]
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
                println("Saved Event")
                }
            })
        }
    override func prepareForSegue(segue:UIStoryboardSegue, sender: AnyObject?){
        println()
        println()
        println(segue.identifier)
        println()
        println()
        if segue.identifier == "event" {
            var secondViewController : postEvent = segue.destinationViewController as! postEvent
            var theMix = Mixpanel.sharedInstance()
            theMix.track("Opened Event View (EF)")
            var indexPath = theFeed.indexPathForSelectedRow() //get index of data for selected row
            var section = indexPath?.section
            var row = indexPath?.row
            var index = getEventIndex(section!, row: row!)
            
            secondViewController.storeStartDate = eventStart[index]
            secondViewController.endStoreDate =  eventEnd[index]
            secondViewController.userId = userId[index]
            secondViewController.address = eventAddress[index]
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
        if segue.identifier == "profile" {
            //Gets the indexpath for the filtered item
            var indexpath = theFeed.indexPathForSelectedRow()
            var row = indexpath?.row
            //selects the view controller
            var theotherprofile:userprofile = segue.destinationViewController as! userprofile
            var item = filteredSearchItems[row!]
            theotherprofile.theUser = item.name
            theotherprofile.userId = item.id
        }
        if segue.identifier == "searchEvent"{
            //Gets the indexpath for the filtered item
            var indexpath = theFeed.indexPathForSelectedRow()
            var row = indexpath?.row
            var item = filteredSearchItems[row!]
            var theotherprofile:postEvent = segue.destinationViewController as! postEvent
            theotherprofile.eventId = item.id
            theotherprofile.searchEvent = true
        }
       
        
    }
}
