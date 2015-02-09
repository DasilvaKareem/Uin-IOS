//
//  eventFeedViewController.swift
//  UinProto2
//
//  Created by Kareem Dasilva on 1/9/15.
//  Copyright (c) 2015 Kareem Dasilva. All rights reserved.
//  This is the main feed for the appilcation

import UIKit
import EventKit

class eventFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet var theFeed: UITableView!
    
    var refresher: UIRefreshControl!
    var events = [Event]()
    
    
    @IBAction func logout(sender: AnyObject){
        PFUser.logOut()
        self.performSegueWithIdentifier("logout", sender: self)
    }

    override func viewDidLoad(){
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
        events.removeAll(keepCapacity: true);
        
        var que = PFQuery(className: "event")
        que.orderByAscending("dateTime")
        que.whereKey("public", equalTo: true)
        
        que.findObjectsInBackgroundWithBlock{
            (objects:[AnyObject]!,eventError:NSError!) -> Void in
            
            if (eventError == nil){
                for object in objects{
                    self.events.append(Event(object: object as PFObject))
                    
                    println(object.objectId)
                    
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
                    self.events.append(Event(object: object as PFObject))
                    
                    println(object.objectId)
                    
                    self.theFeed.reloadData()
                    
                }
                
             }
             self.refresher.endRefreshing()
        }
     }
     
    func refresh(){
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
        
        return events.count
        
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        // Puts the data in a cell
        var cell:eventCell = tableView.dequeueReusableCellWithIdentifier("cell2") as eventCell
        
        var event = events[indexPath.row]
        
        if (event.isOnCampus()){
            cell.onCampusIcon.image = UIImage(named: "onCampus.png")
            cell.onCampusText.text = "On-Campus"
            cell.onCampusText.textColor = UIColor.darkGrayColor()
        }
        else{
            cell.onCampusIcon.image = UIImage(named: "offCampus.png")
            cell.onCampusText.text = "Off-Campus"
            cell.onCampusText.textColor = UIColor.lightGrayColor()
        }
        
        if (event.hasFood()){
            cell.foodIcon.image = UIImage(named: "yesFood.png")
            cell.foodText.text = "Food"
            cell.foodText.textColor = UIColor.darkGrayColor()
        }
        else{
            cell.foodIcon.image = UIImage(named: "noFood.png")
            cell.foodText.text = "No Food"
            cell.foodText.textColor = UIColor.lightGrayColor()
        }
        
        if (!event.isPaid()){
            cell.freeIcon.image = UIImage(named: "yesFree.png")
            cell.costText.text = "Free"
            cell.costText.textColor = UIColor.darkGrayColor()
        }
        else{
            cell.freeIcon.image = UIImage(named: "noFree.png")
            cell.costText.text = "Not Free"
            cell.costText.textColor = UIColor.lightGrayColor()
        }
        
        cell.people.text = event.getAuthor()
        cell.time.text = event.getStartTime()
        cell.eventName.text = event.getTitle()
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
                event.title = self.events[sender.tag].getTitle()
                
             
                //event.notes = self.eventTitle[sender.tag]
                event.location = self.events[sender.tag].getTitle()
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
            var event = self.events[indexPath!.row]
            
            secondViewController.storeLocation = event.getTitle()
            secondViewController.storeTitle = event.getLocation()
            secondViewController.storeStartTime = event.getStartTime()
            secondViewController.storeEndTime = event.getEndTime()
            secondViewController.storeDate = event.getStartDate()
            secondViewController.storeEndDate = event.getEndDate()
            secondViewController.onsite = event.isOnCampus()
            secondViewController.cost = event.isPaid()
            secondViewController.food = event.hasFood()
            secondViewController.users = event.getAuthor()
            
            
        }
    }
}
