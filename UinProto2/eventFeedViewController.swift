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
    
   
    
    @IBAction func logout(sender: AnyObject) {
        
        PFUser.logOut()
        self.performSegueWithIdentifier("logout", sender: self)
    }

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
        self.usernames.removeAll(keepCapacity: true)
        self.eventTitle.removeAll(keepCapacity: true)
        self.eventlocation.removeAll(keepCapacity: true)
        self.eventEndTime.removeAll(keepCapacity: true)
        self.eventStartTime.removeAll(keepCapacity: true)
        self.eventStartDate.removeAll(keepCapacity: true)
        self.eventEndDate.removeAll(keepCapacity: true)
        self.usernames.removeAll(keepCapacity: true)
        self.paid.removeAll(keepCapacity: true)
        self.food.removeAll(keepCapacity: true)
        self.onsite.removeAll(keepCapacity: true)
        
      var que = PFQuery(className: "event")
        que.orderByAscending("dateTime")
        que.whereKey("public", equalTo: true)
        
     
        
        que.findObjectsInBackgroundWithBlock{
            (objects:[AnyObject]!,eventError:NSError!) -> Void in
            
            if eventError == nil {
                
                
                for object in objects{
                    
                    println("Type: \(_stdlib_getTypeName(object))")
                    
                    println(object.objectId)
                    self.usernames.append(object["user"] as String)
                    self.eventTitle.append(object["sum"] as String)
                    self.eventStartDate.append(object["startdate"] as String)
                    self.eventEndDate.append(object["endDate"] as String)
                    self.eventStartTime.append(object["starttime"] as String)
                    self.eventEndTime.append(object["endTime"] as String)
                   self.food.append(object["food"] as Bool)
                    self.paid.append(object["paid"] as Bool)
                   self.onsite.append(object["location"] as Bool)
                    self.eventlocation.append(object["title"] as String)
                    self.theFeed.reloadData()
                    
                    
                }
               
            }
             self.refresher.endRefreshing()
        }
    
        var pubQue = PFQuery(className: "subs")
        pubQue.whereKey("follower", equalTo: PFUser.currentUser().username)
        pubQue.whereKey("member", equalTo: true)
        var superQue = PFQuery(className: "event")
        superQue.whereKey("user", matchesKey: "following", inQuery:pubQue)
        superQue.findObjectsInBackgroundWithBlock{
            
            (objects:[AnyObject]!,eventError:NSError!) -> Void in
            
            if eventError == nil {
                
                for object in objects{
                    
                    println(object.objectId)
                    self.usernames.append(object["user"] as String)
               
                    self.eventTitle.append(object["sum"] as String)
                    self.eventEndDate.append(object["enddate"] as String)
                    self.eventStartTime.append(object["time"] as String)
                    self.food.append(object["food"] as Bool)
                    self.paid.append(object["paid"] as Bool)
                    self.onsite.append(object["location"] as Bool)
                    self.eventlocation.append(object["title"] as String)
                    self.theFeed.reloadData()
                    
                }
                
             }
             self.refresher.endRefreshing()
        }
     }
     
     func refresh() {
     
     updateFeed()
    
    }
    var sectionsInTable = [String]()
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var mo = "karee"
        return mo
        
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
    let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        
       cell.textLabel?.text = "heyy"
        
    return cell
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
        
    }
  
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        return eventlocation.count
        
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        // Puts the data in a cell
        var cell:eventCell = tableView.dequeueReusableCellWithIdentifier("cell2") as eventCell
        
        if onsite[indexPath.row] == true {
        
            cell.onCampusIcon.image = UIImage(named: "onCampus.png")
            cell.onCampusText.text = "On-Campus"
            cell.onCampusText.textColor = UIColor.darkGrayColor()
            println("yo")
            
        }
        else{
            
            cell.onCampusIcon.image = UIImage(named: "offCampus.png")
            cell.onCampusText.text = "Off-Campus"
            cell.onCampusText.textColor = UIColor.lightGrayColor()
            
        }
        
        if food[indexPath.row] == true {
            
            cell.foodIcon.image = UIImage(named: "yesFood.png")
            cell.foodText.text = "Food"
            cell.foodText.textColor = UIColor.darkGrayColor()
            println("yo")
            
        }
        else{
            
            cell.foodIcon.image = UIImage(named: "noFood.png")
            cell.foodText.text = "No Food"
            cell.foodText.textColor = UIColor.lightGrayColor()

        }
        if paid[indexPath.row] == false {
        
            cell.freeIcon.image = UIImage(named: "yesFree.png")
            cell.costText.text = "Free"
            cell.costText.textColor = UIColor.darkGrayColor()
            println("yo")
            
        }
        else{
            
            cell.freeIcon.image = UIImage(named: "noFree.png")
            cell.costText.text = "Not Free"
            cell.costText.textColor = UIColor.lightGrayColor()
            
        }
        
        cell.people.text = usernames[indexPath.row]
        cell.time.text = eventStartTime[indexPath.row]
        cell.eventName.text = eventlocation[indexPath.row]
        cell.poop.tag = indexPath.row
       cell.poop.addTarget(self, action: "followButton:", forControlEvents: UIControlEvents.TouchUpInside)
  
        return cell
    }
    
    func followButton(sender: AnyObject){
        // Puts the data in a cell
        var que = PFQuery(className: "events")
        var eventStore : EKEventStore = EKEventStore()
        eventStore.requestAccessToEntityType(EKEntityTypeEvent, completion: {
            granted, error in
            if (granted) && (error == nil) {
                println("granted \(granted)")
                println("error  \(error)")
                
                var event:EKEvent = EKEvent(eventStore: eventStore)
                event.title = self.eventlocation[sender.tag]
                
             
                //event.notes = self.eventTitle[sender.tag]
                event.location = self.eventTitle[sender.tag]
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
            var thenum = indexPath?.row
            secondViewController.storeLocation = eventTitle[thenum!]
            secondViewController.storeTitle = eventlocation[thenum!]
            secondViewController.storeStartTime = eventStartTime[thenum!]
            secondViewController.storeEndTime = eventEndTime[thenum!]
            secondViewController.storeDate = eventStartDate[thenum!]
            secondViewController.storeEndDate = eventEndDate[thenum!]
            secondViewController.onsite = onsite[thenum!]
            secondViewController.cost = food[thenum!]
            secondViewController.food = food[thenum!]
            secondViewController.users = usernames[thenum!]
            
            
        }
    }
}
