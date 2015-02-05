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
    var eventNamed = [String]()
    var eventStartTime = [String]()
    var eventEndTime = [String]()
    var eventDate = [String]()
    var usernames = [String]()
    
    
    
    @IBAction func logout(sender: AnyObject) {
        
        PFUser.logOut()
        self.performSegueWithIdentifier("logout", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        updateFeed()
        //Changes the navbar color
        var nav = self.navigationController?.navigationBar
        nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController?.navigationBar.barTintColor = UIColor(red:60.0/255.0, green:144.0/255.0,blue:201.0/250.0,alpha:1.0)
        
        //Addes pull to refresh
         refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pul to refresh")
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.theFeed.addSubview(refresher)
    
       
       
     }
     func updateFeed(){
        self.usernames.removeAll(keepCapacity: true)
        self.eventTitle.removeAll(keepCapacity: true)
        self.eventNamed.removeAll(keepCapacity: true)
        self.eventEndTime.removeAll(keepCapacity: true)
        self.eventStartTime.removeAll(keepCapacity: true)
        self.eventDate.removeAll(keepCapacity: true)
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
                    
                    println(object.objectId)
                    self.usernames.append(object["user"] as String)
                    self.eventTitle.append(object["sum"] as String)
                    self.eventDate.append(object["date"] as String)
                    self.eventStartTime.append(object["time"] as String)
                   // self.eventEndTime.append(object["endTimeFormat"] as String)
                   self.food.append(object["food"] as Bool)
                    self.paid.append(object["paid"] as Bool)
                   self.onsite.append(object["location"] as Bool)
                    self.eventNamed.append(object["title"] as String)
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
                    self.eventDate.append(object["date"] as String)
                    self.eventStartTime.append(object["time"] as String)
                    self.food.append(object["food"] as Bool)
                    self.paid.append(object["paid"] as Bool)
                    self.onsite.append(object["location"] as Bool)
                    self.eventNamed.append(object["title"] as String)
                    self.theFeed.reloadData()
                    
                }
                
             }
             self.refresher.endRefreshing()
        }
     }
     
     func refresh() {
     
     updateFeed()
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
        
    }
  
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        return eventNamed.count
        
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        // Puts the data in a cell
        var cell:eventCell = tableView.dequeueReusableCellWithIdentifier("cell2") as eventCell
        
        if onsite[indexPath.row] == true {
        
            cell.location.image = UIImage(named: "oncampusicon@3x")
            cell.onCampusText.text = "On-Campus"
            cell.onCampusText.textColor = UIColor.darkGrayColor()
            println("yo")
            
        }
        else{
            
            cell.location.image = UIImage(named: "offCampus@3x")
            cell.onCampusText.text = "Off-Campus"
            cell.onCampusText.textColor = UIColor.lightGrayColor()
            
        }
        
        if food[indexPath.row] == true {
            
            cell.food.image = UIImage(named: "foodicon@3x")
            cell.foodText.text = "Food"
            cell.foodText.textColor = UIColor.darkGrayColor()
            println("yo")
            
        }
        else{
            
            cell.food.image = UIImage(named: "noFood@3x")
            cell.foodText.text = "No Food"
            cell.foodText.textColor = UIColor.lightGrayColor()

        }
        if paid[indexPath.row] == false {
        
            cell.paid.image = UIImage(named: "freeicon@3x")
            cell.costText.text = "Free"
            cell.costText.textColor = UIColor.darkGrayColor()
            println("yo")
            
        }
        else{
            
            cell.paid.image = UIImage(named: "noFree@3x")
            cell.costText.text = "Not Free"
            cell.costText.textColor = UIColor.lightGrayColor()
            
        }
        
        cell.people.text = eventTitle[indexPath.row]
        cell.time.text = eventStartTime[indexPath.row]
        cell.eventName.text = eventNamed[indexPath.row]
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
               event.title = self.eventNamed[sender.tag]
                
             
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
            
            println("hey")
            //secondViewController.storeTitle = eventTitle[sender?.tag!]
            
            secondViewController.storeTitle = "jhey"
            
            var indexPath = theFeed.indexPathForSelectedRow() //get index of data for selected row
            var thenum = indexPath?.row
            secondViewController.storeLocation = eventTitle[thenum!]
            secondViewController.storeTitle = eventNamed[thenum!]
            secondViewController.storeStartTime = eventStartTime[thenum!]
            //secondViewController.storeEndTime = eventEndTime[thenum!]
            secondViewController.storeDate = eventDate[thenum!]
            secondViewController.onsite = onsite[thenum!]
            secondViewController.cost = food[thenum!]
            secondViewController.food = food[thenum!]
            secondViewController.users = usernames[thenum!]
            
            
        }
    }
}
