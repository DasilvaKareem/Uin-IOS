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
    
   
    var numSections = 0
    var rowsInSection = [Int]()
    var sectionNames = [String]()
    


    override func viewDidLoad() {
        super.viewDidLoad()
        

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
     func updateFeed(){
        //Removes all leftover content in the array
        
        println("Before query")
        
        //adds content to the array
      var que = PFQuery(className: "Event")
        que.orderByDescending("startEvent")
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
    
        var pubQue = PFQuery(className: "subs")
        pubQue.whereKey("follower", equalTo: PFUser.currentUser().username)
        pubQue.whereKey("member", equalTo: true)
        var superQue = PFQuery(className: "Event")
        superQue.whereKey("user", matchesKey: "following", inQuery:pubQue)
        superQue.findObjectsInBackgroundWithBlock{
            
            (objects:[AnyObject]!,eventError:NSError!) -> Void in
            
            if eventError == nil {
                
                for object in objects{
                    
                    println(object.objectId)
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
                    self.eventlocation.append(object["eventTitle"] as String)
                    
                }
                
            }
            self.populateSectionInfo()
            self.theFeed.reloadData()
            self.refresher.endRefreshing()
        }
        
     }

     
    func refresh() {
        updateFeed()
    }
    
    func populateSectionInfo(){
        var currentDate = ""
        var i = 0
        
        //Initialisation
        numSections = 0
        rowsInSection.removeAll(keepCapacity: true)
        sectionNames.removeAll(keepCapacity: true)
        
        //For each date
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
    
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
       
        return sectionNames[section]
            
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
        
        //println(onsite.count)
        //println(event)
        
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
        if paid[event] == false {
        
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
               /* var going = PFObject(className: "GoingEvent")
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
                */
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
    }
    
   override func prepareForSegue(segue:UIStoryboardSegue, sender: AnyObject?){

        if segue.identifier == "example" {
            var secondViewController : postEvent = segue.destinationViewController as postEvent
            
            
           
            
            var indexPath = theFeed.indexPathForSelectedRow() //get index of data for selected row
            var section = indexPath?.section
            var row = indexPath?.row
            
            var index = getEventIndex(section!, row: row!)
          
            secondViewController.storeLocation = eventTitle[index]
            secondViewController.storeTitle = eventlocation[index]
            secondViewController.storeStartTime = eventStartTime[index]
            secondViewController.storeEndTime = eventEndTime[index]
            secondViewController.storeDate = eventStartDate[index]
            secondViewController.storeEndDate = eventEndDate[index]
            secondViewController.onsite = onsite[index]
            secondViewController.cost = food[index]
            secondViewController.food = food[index]
            secondViewController.users = usernames[index]
            
            
        }
    }
}
