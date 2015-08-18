//
//  eventFeedViewController.swift
//  UinProto2
//
//  Created by Kareem Dasilva on 1/9/15.
//  Copyright (c) 2015 Kareem Dasilva. All rights reserved.
//  This is the main feed for the appilcation

import UIKit
import EventKit

class eventFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UITextFieldDelegate, UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    @IBOutlet weak var theFeed: UITableView!
    
    @IBOutlet var eventCreate: UIBarButtonItem!
    @IBOutlet var menuTrigger: UIBarButtonItem!
    var refresher: UIRefreshControl!
    
    @IBOutlet weak var wigoCollectionView: UICollectionView!
    var eventObject = [PFObject]()
    //Icons variables
    var tag1 = [String]()
    var tag2 = [String]()
    var tag3 = [String]()
    var shouldKeep = true
    //Text that is display on cell
    var eventTitle = [String]()
    var eventAddress = [String]()
    var eventlocation = [String]()
    var eventStartTime = [String]()
    var eventEndTime = [String]()
    var eventStartDate = [String]()
    var eventEndDate = [String]()
    var usernames = [String]()
    var eventDescription = [String]()
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
        //getWhosGoing()
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
      
        
        //Adds pull to refresh
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.theFeed.addSubview(refresher)

    
    }
    
    override func viewWillDisappear(animated: Bool) {
        println("View disappear")
        endSearch()
        
    }
    override func viewWillAppear(animated: Bool) {
      
        println()
        setupCalendar()
        updateFeed(false)
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
        var user = PFUser.currentUser()
        //Checks if the account is a temporary account
        if user["organization"] !== nil {
            self.performSegueWithIdentifier("eventPush", sender: self)
            var theMix = Mixpanel.sharedInstance()
            theMix.track("Tap Create Event (EF)")
            theMix.flush()
        } else {
            displayAlert("You need to signed in as Organization", error: "Please sign or create Organization")
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
    
    func setupCalendar(){
        if channelID != "localEvent" || channelID != "subbedEvents" {
            var calendarQue = PFQuery(className: "Channel")
            calendarQue.getObjectInBackgroundWithId(channelID, block: {
                (object:PFObject!, error:NSError!) -> Void in
                if error == nil {
                    self.navigationItem.title = object["name"] as? String
                    self.alertTime = object["alertTime"] as! NSTimeInterval
                } else {
                    println(error.debugDescription)
                }
                
            })
        }
    }
    
    func updateFeed(shouldKeepList:Bool){
        //Removes all leftover content in the array
        var geoEnabled = true
        PFGeoPoint.geoPointForCurrentLocationInBackground {
            (geoPoint: PFGeoPoint!, error: NSError!) -> Void in
            if error != nil {
                println(error.code)
                self.displayAlert("No GPS Enabled", error: "Turn on your location")
            }
            
                    self.currentPoint = geoPoint //sets the user gps to a global point
                    //adds content to the array
                    //Queries all public Events
                    var eventQuery = PFQuery(className: "Event")
                    switch self.channelID {
                        case "localEvent":
                            self.navigationItem.title = "Local Events"
                            eventQuery.whereKey("inLocalFeed", equalTo: true)
                            eventQuery.whereKey("isPublic", equalTo: true)
                            
                            
                            //Queries all Private events
                           
                            
                        break
                        case "uinEvents":
                            self.navigationItem.title = "Subscription Events"
                            eventQuery.whereKey("inLocalFeed", equalTo: true)
                            eventQuery.whereKey("isPublic", equalTo: true)
                      
                        
                        break
                        case "schedule":
                             self.navigationItem.title = "Schedule"
                            geoEnabled = false
                             eventQuery.whereKey("inLocalFeed", equalTo: true)
                             eventQuery.whereKey("isPublic", equalTo: true)
                        break
                    default:
                        eventQuery.whereKey("inLocalFeed", equalTo: true)
                        eventQuery.whereKey("isPublic", equalTo: true)
            
                      
            
                        break
                    }
           
                    
                    eventQuery.orderByAscending("start")
                    eventQuery.includeKey("author")
                   /* if geoEnabled == true  {
                 query.whereKey("locationGeopoint", nearGeoPoint: self.currentPoint, withinMiles: 7.0)
                 println(self.currentPoint)
                    }*/
                 //query.whereKey("start", greaterThanOrEqualTo: NSDate())
                    eventQuery.whereKey("isDeleted", equalTo: false)
                    eventQuery.limit = 20
                    eventQuery.whereKey("objectId", notContainedIn: self.objectID)
                    eventQuery.findObjectsInBackgroundWithBlock {
                        (results: [AnyObject]!, error: NSError!) -> Void in
                        if error == nil {
                            if shouldKeepList == true {
                                self.eventAddress.removeAll(keepCapacity: true)
                                self.tag1.removeAll(keepCapacity: true)
                                self.tag2.removeAll(keepCapacity: true)
                                self.tag3.removeAll(keepCapacity: true)
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
                            }
                            println()
                           // println(results)
                            println()
                            
                            for object in results{
                                self.eventObject.append(object as! PFObject)
                                let author:PFObject = object["author"] as! PFObject //Makes pointer in PFobject
                                self.publicPost.append(object["isPublic"] as!Bool)
                                self.objectID.append(object.objectId as String)
                                self.usernames.append(author["name"] as! String)
                                self.eventTitle.append(object["title"] as! String)
                                //Checks if the tag1 is nil then enters a blank icon
                                if (object["tag1"]  === nil)  {
                                    self.tag1.append("")
                                } else {
                                    
                                    self.tag1.append(object["tag1"] as! String)
                                }
                                
                                //Checks if the tag2 is nil then enters a blank icon
                                if (object["tag2"]  === nil)  {
                                    self.tag2.append("")
                                } else {
                                    
                                    self.tag2.append(object["tag2"] as! String)
                                }
                                //Checks if the tag3 is nil then enters a blank icon
                                if (object["tag3"]  === nil)  {
                                   self.tag3.append("")
                                } else {
                                     self.tag3.append(object["tag3"] as! String)
                                }

                                self.eventEnd.append(object["end"] as!NSDate)
                                self.eventStart.append(object["start"] as!NSDate)
                                self.eventlocation.append(object["location"] as!String)
                                self.userId.append(author.objectId)
                                self.eventAddress.append(object["address"] as!String)
                                self.eventDescription.append(object["description"] as! String)
                                
                            }
                            if self.userId.isEmpty {
                                self.appProblem = true
                                self.theFeed.reloadData()
                            }
                            self.populateSectionInfo()
                            if results.count != 0 {
                                self.theFeed.reloadData()
                            } else {
                                self.shouldKeep = false
                            }
                           
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
           
        }
    }
    
    func refresh() {
       
        endSearch()
        updateFeed(true)
        
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
            dateFormatter.dateFormat = "EEEE, MMM dd" // Formart for date I.E Monday, 03 1996
            var headerDate = dateFormatter.stringFromDate(i) // Creates date
            convertedDates.append(headerDate)
            dateFormatter.dateFormat = "MMM dd, yyyy"
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
            dateFormatter.dateFormat = "MMM dd, yyyy"
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
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
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
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25.0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 130.0
    }
    
 
  
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        // Puts the data in a cell
        var cell:eventCell = tableView.dequeueReusableCellWithIdentifier("cell2") as! eventCell
       
        
        if appProblem == true {
            cell.eventName.numberOfLines = 3
            //cell.onCampusIcon.image = nil
            //cell.foodIcon.image = nil
            //cell.freeIcon.image = nil
            cell.poop.hidden = true
            cell.foodText.text = ""
            cell.onCampusText.text = ""
            cell.costText.text = ""
            cell.eventName.text = "There are no events in this calendar. Why don't you be the first to create one?"
            cell.people.text = ""
            cell.privateImage.image = nil
            cell.time.text = ""
        } else {
        if searchActive == true {
            println("search is active")
          
            if filteredSearchItems.count == 0 {
             
                cell.poop.hidden = true
                cell.costText.text = ""
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
                cell.costText.text = ""
                cell.onCampusText.text = ""
                cell.costText.text = ""
                cell.eventName.text = items.name
                cell.people.text = items.type
                cell.privateImage.image = nil
                cell.time.text = ""
                
            }
            
        
            
        } else {
        var event = getEventIndex(indexPath.section, row: indexPath.row)
            if self.searchActive == false {
                if indexPath.section == numSections - 3{
                    if self.shouldKeep == true {
                        updateFeed(false)
                    }
                }
            }
        cell.poop.hidden = false
        var section = indexPath.section
        var row = indexPath.row
        //Puts image for three icons
            switch tag1[event] {
            case "PvApxif2rw": //Popcorn
                cell.icon1.image = UIImage(named: "popcorn.png")
                cell.onCampusText.text = "popcorn"
                break
                
            case "LP5fLvLurL": //recuitment
                cell.icon1.image = UIImage(named: "recruitment.png")
                cell.onCampusText.text = "recruitment"
                
                break
                
            case "8HvnDADGY2": // run
                cell.icon1.image = UIImage(named: "run.png")
                cell.onCampusText.text = "run"
                break
                
            case "BX9RsT3EpW": //tour
                cell.icon1.image = UIImage(named: "tour.png")
                cell.onCampusText.text = "tour"
                break
            case "u2EAfQk9Lf": //intramural
                cell.icon1.image = UIImage(named: "intramural.png")
                cell.onCampusText.text = "intramural"
                break
                
            case "ayCBAVwQ93": //sales event
                cell.icon1.image = UIImage(named: "sales.png")
                cell.onCampusText.text = "sales event"
                break
                
            case "D1nxE6j63a": //dance
                cell.icon1.image = UIImage(named: "dance.png")
                cell.onCampusText.text = "dance"
                break
                
            case "XiWPxYMwEO": //games
                cell.icon1.image = UIImage(named: "games.png")
                cell.onCampusText.text = "games"
                break
                
            case "6IkmbdKMnn": //meetup
                cell.icon1.image = UIImage(named: "meet.png")
                cell.onCampusText.text = "meeting"
                break
                
            case "wLt1TPYiyV": //religous
                cell.icon1.image = UIImage(named: "religous.png")
                cell.onCampusText.text = "religous"
                break
                
            case "f8ZpiOF9cg": //conference
                cell.icon1.image = UIImage(named: "conference.png")
                cell.onCampusText.text = "conference"
                break
                
            case "leITfmSo7E": //party
                cell.icon1.image = UIImage(named: "party.png")
                cell.onCampusText.text = "party"
                break
            case "s5XU11BTs3": // drinking
                cell.icon1.image = UIImage(named: "drinking.png")
                cell.onCampusText.text = "drinking"
                break
                
            case "a3pMl70t39": //Outdoors
                cell.icon1.image = UIImage(named: "outdoors.png")
                cell.onCampusText.text = "outdoors"
                break
                
            case "V6fIqmoG05": //philanthropy
                cell.icon1.image = UIImage(named: "phil.png")
                cell.onCampusText.text = "philanthropy"
                break
            case "mch3EIhozC": //music
                cell.icon1.image = UIImage(named: "music.png")
                cell.onCampusText.text = "music"
                break
                
            case "AjosKs2UWi": //byob
                cell.icon1.image = UIImage(named: "byob.png")
                cell.onCampusText.text = "byob"
                break
                
            case "Ymclya9lwu": //performance
                cell.icon1.image = UIImage(named: "performance.png")
                cell.onCampusText.text = "performance"
                break
            case "XYV5giSlCO": // food
                cell.icon1.image = UIImage(named: "food.png")
                cell.onCampusText.text = "food"
                break
                
            case "GawBDHRtfo": //free
                cell.icon1.image = UIImage(named: "free.png")
                cell.onCampusText.text = "free"
                break
            case "8OXtrEEL7c"://On campus
                cell.icon1.image = UIImage(named: "onCampus.png")
                break
                
            default:
                cell.icon1.image = nil
                cell.onCampusText.text = ""
                
            }
            switch tag2[event] {
            case "PvApxif2rw": //Popcorn
                cell.icon2.image = UIImage(named: "popcorn.png")
                cell.costText.text = "Popcorn"
                break
                
            case "LP5fLvLurL": //recuitment
                cell.icon1.image = UIImage(named: "recruitment.png")
                cell.costText.text = "recruitment"
                
                break
                
            case "8HvnDADGY2": // run
                cell.icon2.image = UIImage(named: "run.png")
                cell.costText.text = "run"
                break
                
            case "BX9RsT3EpW": //tour
                cell.icon2.image = UIImage(named: "tour.png")
                cell.costText.text = "tour"
                break
            case "u2EAfQk9Lf": //intramural
                cell.icon2.image = UIImage(named: "intramural.png")
                cell.costText.text = "Intramural"
                break
                
            case "ayCBAVwQ93": //sales event
                cell.icon2.image = UIImage(named: "sales.png")
                cell.costText.text = "Sales"
                break
                
            case "D1nxE6j63a": //dance
                cell.icon2.image = UIImage(named: "dance.png")
                cell.costText.text = "Dance"
                break
                
            case "XiWPxYMwEO": //games
                cell.icon2.image = UIImage(named: "games.png")
                cell.costText.text = "Games"
                break
                
            case "6IkmbdKMnn": //meetup
                cell.icon2.image = UIImage(named: "meet.png")
                cell.costText.text = "meet"
                break
                
            case "wLt1TPYiyV": //religous
                cell.icon2.image = UIImage(named: "religous.png")
                cell.costText.text = "Religous"
                break
                
            case "f8ZpiOF9cg": //conference
                cell.icon2.image = UIImage(named: "conference.png")
                cell.costText.text = "conference"
                break
                
            case "leITfmSo7E": //party
                cell.icon2.image = UIImage(named: "party.png")
                cell.costText.text = "Party"
                break
            case "s5XU11BTs3": // drinking
                cell.icon2.image = UIImage(named: "drinking.png")
                cell.costText.text = "drinking"
                break
                
            case "a3pMl70t39": //Outdoors
                cell.icon2.image = UIImage(named: "outdoors.png")
                cell.costText.text = "outdoors"
                break
                
            case "V6fIqmoG05": //philanthropy
                cell.icon2.image = UIImage(named: "phil.png")
                cell.costText.text = "Philanthropy"
                break
            case "mch3EIhozC": //music
                cell.icon2.image = UIImage(named: "music.png")
                cell.costText.text = "Music"
                break
                
            case "AjosKs2UWi": //byob
                cell.icon2.image = UIImage(named: "byob.png")
                cell.costText.text = "Byob"
                break
                
            case "Ymclya9lwu": //performance
                cell.icon2.image = UIImage(named: "performance.png")
                cell.costText.text = "Performance"
                break
            case "XYV5giSlCO": // food
                cell.icon2.image = UIImage(named: "food.png")
                cell.costText.text = "Food"
                break
                
            case "GawBDHRtfo": //free
                cell.icon2.image = UIImage(named: "free.png")
                cell.costText.text = "Free"
                break
            case "8OXtrEEL7c"://On campus
                cell.icon2.image = UIImage(named: "onCampus.png")
                cell.costText.text = "On Campus"
                break
                
            default:
                cell.icon2.image = nil
                cell.costText.text = ""
                
            }
            switch tag3[event] {
            case "PvApxif2rw": //Popcorn
                cell.icon3.image = UIImage(named: "popcorn.png")
                cell.foodText.text = "Popcorn"
                break
                
            case "LP5fLvLurL": //recuitment
                cell.icon3.image = UIImage(named: "recruitment.png")
                cell.foodText.text = "recruitment"
                
                break
                
            case "8HvnDADGY2": // run
                cell.icon3.image = UIImage(named: "run.png")
                cell.foodText.text = "run"
                break
                
            case "BX9RsT3EpW": //tour
                cell.icon3.image = UIImage(named: "tour.png")
                cell.foodText.text = "tour"
                break
            case "u2EAfQk9Lf": //intramural
                cell.icon3.image = UIImage(named: "intramural.png")
                cell.foodText.text = "Intramural"
                break
                
            case "ayCBAVwQ93": //sales event
                cell.icon3.image = UIImage(named: "sales.png")
                cell.foodText.text = "Sales"
                break
                
            case "D1nxE6j63a": //dance
                cell.icon3.image = UIImage(named: "dance.png")
                cell.foodText.text = "Dance"
                break
                
            case "XiWPxYMwEO": //games
                cell.icon3.image = UIImage(named: "games.png")
                cell.foodText.text = "Games"
                break
                
            case "6IkmbdKMnn": //meetup
                cell.icon3.image = UIImage(named: "meet.png")
                cell.foodText.text = "meet"
                break
                
            case "wLt1TPYiyV": //religous
                cell.icon3.image = UIImage(named: "religous.png")
                cell.foodText.text = "Religous"
                break
                
            case "f8ZpiOF9cg": //conference
                cell.icon3.image = UIImage(named: "conference.png")
                cell.foodText.text = "conference"
                break
                
            case "leITfmSo7E": //party
                cell.icon3.image = UIImage(named: "party.png")
                cell.foodText.text = "Party"
                break
            case "s5XU11BTs3": // drinking
                cell.icon3.image = UIImage(named: "drinking.png")
                cell.foodText.text = "drinking"
                break
                
            case "a3pMl70t39": //Outdoors
                cell.icon3.image = UIImage(named: "outdoors.png")
                cell.foodText.text = "outdoors"
                break
                
            case "V6fIqmoG05": //philanthropy
                cell.icon3.image = UIImage(named: "phil.png")
                cell.foodText.text = "Philanthropy"
                break
            case "mch3EIhozC": //music
                cell.icon3.image = UIImage(named: "music.png")
                cell.foodText.text = "Music"
                break
                
            case "AjosKs2UWi": //byob
                cell.icon3.image = UIImage(named: "byob.png")
                cell.foodText.text = "Byob"
                break
                
            case "Ymclya9lwu": //performance
                cell.icon3.image = UIImage(named: "performance.png")
                cell.foodText.text = "Performance"
                break
            case "XYV5giSlCO": // food
                cell.icon3.image = UIImage(named: "food.png")
                cell.foodText.text = "Food"
                break
                
            case "GawBDHRtfo": //free
                cell.icon3.image = UIImage(named: "free.png")
                cell.foodText.text = "Free"
                break
            case "8OXtrEEL7c"://On campus
                cell.icon3.image = UIImage(named: "oncampus.png")
                break
                
            default:
                cell.icon3.image = nil
                cell.foodText.text = ""
            }
        
        cell.people.text = usernames[event]
        cell.time.text = localizedTime[event]
        cell.eventName.text = eventTitle[event]
        cell.poop.tag = event
       /* var minique = PFQuery(className: "UserCalendar")
        minique.whereKey("userID", equalTo: PFUser.currentUser().objectId)
        minique.whereKey("eventID", equalTo: objectID[event])
            minique.getFirstObjectInBackgroundWithBlock{
            
                (results:PFObject!, error: NSError!) -> Void in
            
                if error == nil {
                
                    cell.poop.setImage(UIImage(named: "addedToCalendar.png"), forState: UIControlState.Normal)
                
                }   else {
                
                    cell.poop.setImage(UIImage(named: "addToCalendar.png"), forState: UIControlState.Normal)
                }
            }*/
      
         cell.poop.addTarget(self, action: "followButton:", forControlEvents: UIControlEvents.TouchUpInside)
            
            
            var file = (PFFile)()
            var query = PFQuery(className:"WigoFeature")
            query.whereKey("event", equalTo: eventObject[event])
            query.includeKey("user")
            query.includeKey("event")
            query.findObjectsInBackgroundWithBlock({
                (objects:[AnyObject]!, error:NSError!) -> Void in
                if error == nil {
                    for object in objects {
                        // self.theFeed.reloadData()
                        var wigoUser = object["user"] as! PFObject
                        println(wigoUser["profilePicture"] as! PFFile)
                        file = wigoUser["profilePicture"] as! PFFile
                        var data = file.getData()
                        
                        self.images.append(UIImage(data: data)!)
                       
                        
                    }
                     cell.wigoCollectionView.reloadData()

                }
            })
            

            }
        
        }
        return cell
        
    }
    var images = [UIImage]()
    //Collection view fofr wigo
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      
        return images.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }
  
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("icon", forIndexPath: indexPath) as! WigoCell
        cell.profilePic.layer.cornerRadius = cell.profilePic.frame.size.width / 2
        cell.profilePic.clipsToBounds = true
        var event = getEventIndex(indexPath.section, row: indexPath.row)
        if images.count == 0 {
            cell.profilePic.image = nil
        } else {
            cell.profilePic.image = images[event]
        }
        
        self.images.removeAll(keepCapacity: true)
        
        
        
        
        
        
        println(images)
        
        return cell
    }
    
    var wigoImage = [UIImage]()
    
    
    
    
    
    
    
    private func getWhosGoing(){
        wigoImage.removeAll(keepCapacity: true)
       // var indexPath = theFeed.indexPathForSelectedRow() //get index of data for selected row
        //var section = indexPath?.section
        //var row = indexPath?.row
       //var index = getEventIndex(section!, row: row!)
        var userImage = (PFFile)()
        var wigoQuery = PFQuery(className: "WigoFeature")
        //wigoQuery.whereKey("event", equalTo: PFObject(withoutDataWithClassName: "Event", objectId: objectID[index]))
        //wigoQuery.limit = 5
        wigoQuery.includeKey("user")
        wigoQuery.includeKey("event")
        wigoQuery.findObjectsInBackgroundWithBlock({
            (objects:[AnyObject]!, error:NSError!) -> Void in
            if error == nil {
                // println(objects)
                for object in objects {
                    var wigoUser = object["user"] as! PFObject
                    println(wigoUser["profilePicture"] as! PFFile)
                    userImage = wigoUser["profilePicture"] as! PFFile
                    userImage.getDataInBackgroundWithBlock({
                        (data:NSData!, error:NSError!) -> Void in
                        if error == nil {
                            // println(data)
                            self.wigoImage.append(UIImage(data: data)!)
                            
                            println(self.wigoImage)
                        } else {
                            println("No data found")
                        }
                    })
                    
                    
                }
                self.theFeed.reloadData()
                
                
            } else {
                println("Error was found")
            }
        })
        
        
    }

    
    func followButton(sender: UIButton){
        //Checks if user has Wigo'd already
        var query = PFQuery(className: "WigoFeature")
        query.whereKey("event", equalTo: eventObject[sender.tag])
        query.whereKey("user", equalTo: PFUser.currentUser())
        query.getFirstObjectInBackgroundWithBlock({
            (object:PFObject!, error:NSError!) -> Void in
            if error == nil {
                //Deletes the object
                object.deleteInBackgroundWithBlock({
                    (success:Bool, error:NSError!) -> Void in
                    if error == nil {
                        self.theFeed.reloadData()
                        println("object deleted")
                    }
                })
               
            } else {
                //Saves object
                if error.code == 101 {
                    var uined = PFObject(className: "WigoFeature")
                    uined["user"] = PFUser.currentUser()
                    uined["event"] = self.eventObject[sender.tag]
                    uined.saveInBackgroundWithBlock({
                        (success:Bool, error:NSError!) -> Void in
                        if error == nil {
                             println("user has been wigoed")
                            self.theFeed.reloadData()
                        }
                    })
                    
                }
                
            }
        })
       
  
        
        }
    override func prepareForSegue(segue:UIStoryboardSegue, sender: AnyObject?){
        if segue.identifier == "event" {
            var secondViewController : postEvent = segue.destinationViewController as! postEvent
            var theMix = Mixpanel.sharedInstance()
            theMix.track("Opened Event View (EF)")
            var indexPath = theFeed.indexPathForSelectedRow() //get index of data for selected row
            var section = indexPath?.section
            var row = indexPath?.row
            var index = getEventIndex(section!, row: row!)
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
