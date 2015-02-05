//
//  NewProfile.swift
//  UinProto2
//
//  Created by Kareem Dasilva on 1/24/15.
//  Copyright (c) 2015 Kareem Dasilva. All rights reserved.
//

import UIKit

import EventKit

class NewProfile: UIViewController, UITableViewDelegate, UITableViewDataSource {

    

    @IBOutlet weak var orgName: UILabel!
    
    
    @IBOutlet var subscribers: UIButton!
    

    @IBOutlet var subscription: UIButton!
    
    @IBOutlet weak var theFeed: UITableView!
    
    //Decalres all the arrays that hold the data
    
    var onsite = [Bool]()
    var paid = [Bool]()
    var food = [Bool]()
    var eventTitle = [String]()
    var eventNamed = [String]()
    var eventTime = [String]()
    var eventDate = [String]()
    var eventNS = [NSDate]()
    
 
    override func viewDidAppear(animated: Bool) {
        subticker()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("loaded")
        subticker()
        eventList()
        //Queries all the events and puts into the arrays above
        
                navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navBarBackground.png"), forBarMetrics: UIBarMetrics.Default)
        
        var nav = self.navigationController?.navigationBar
        nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()];

    }
    
    func subticker(){
        var amountofsubs = [String]()
        var getNumberList = PFQuery(className:"subs")
        getNumberList.whereKey("following", equalTo: PFUser.currentUser().username)
        getNumberList.findObjectsInBackgroundWithBlock{
            
            (objects:[AnyObject]!, folError:NSError!) -> Void in
            
            
            if folError == nil {
                
                
                for object in objects{
                    
                    amountofsubs.append(object["follower"] as String)
                    
                    
                    
                }
              
             
                self.subscribers.setTitle("Subscriber \(amountofsubs.count)", forState: UIControlState.Normal)
            }
            
            
        }
        
        var amountofScript = [String]()
        var getNumberList2 = PFQuery(className: "subs")
        getNumberList2.whereKey("follower", equalTo: PFUser.currentUser().username)
        getNumberList2.findObjectsInBackgroundWithBlock{
            
            (objects:[AnyObject]!, folError:NSError!) -> Void in
            
            
            if folError == nil {
                
                
                for object in objects{
                    
                    amountofScript.append(object["following"] as String)
                    
                    
                    
                }
                
                
                self.subscription.setTitle("Subscriptions \(amountofScript.count)", forState: UIControlState.Normal)
            }
            
            
        }
        
       
        
        
    }
    

    
    func eventList(){
    orgName.text = PFUser.currentUser().username
    
    var que = PFQuery(className: "event")
    
    que.orderByAscending("dateTime")
    
    que.whereKey("user", equalTo: PFUser.currentUser().username)
    
    que.findObjectsInBackgroundWithBlock{
    
    (objects:[AnyObject]!,eventError:NSError!) -> Void in
    
    if eventError == nil {
    
    
    for object in objects{
    
   
    self.eventNS.append(object["dateTime"] as NSDate)
    
    self.eventTitle.append(object["sum"] as String)
    
    self.eventDate.append(object["date"] as String)
    
    self.eventTime.append(object["time"] as String)
    
    self.food.append(object["food"] as Bool)
    
    self.paid.append(object["paid"] as Bool)
    
    self.onsite.append(object["location"] as Bool)
    
    self.eventNamed.append(object["title"] as String)
    
    self.theFeed.reloadData()
    
    
                    }
                }
            }
        }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    
    @IBAction func logout(sender: AnyObject) {
        
        PFUser.logOut()
        self.performSegueWithIdentifier("logout", sender: self)
    
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
    
    
    
    
    
    
    
    
    var number = [Int]()
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        // Puts the all the data in the cell using indexpath
        var cell:eventCell = tableView.dequeueReusableCellWithIdentifier("cell2") as eventCell
        
        if onsite[indexPath.row] == true {
            
            
            cell.onCampusIcon.image = UIImage(named: "onCampus.png")
            
            
            
        }
        else{
            
            cell.onCampusIcon.image = UIImage(named: "offCampus.png")
            
            cell.onCampusText.text = "Off-Campus"
            cell.onCampusText.textColor = UIColor.lightGrayColor()
            
        }
        
        if food[indexPath.row] == true {
            
            
            cell.foodIcon.image = UIImage(named: "yesFood.png")
            
            
        }
        else{
            
            cell.foodIcon.image = UIImage(named: "noFood.png")
            
            cell.foodText.text = "No Food"
            cell.foodText.textColor = UIColor.lightGrayColor()
            
            
        }
        if paid[indexPath.row] == true {
            
            
            cell.freeIcon.image = UIImage(named: "yesFree.png")
            
            
            
        }
        else{
            
            cell.freeIcon.image = UIImage(named: "noFree.png")
            
            cell.costText.text = "Not Free"
            cell.costText.textColor = UIColor.lightGrayColor()
            
            
        }
        
        cell.people.text = eventTitle[indexPath.row]
        cell.time.text = eventTime[indexPath.row]
        cell.eventName.text = eventNamed[indexPath.row]
        cell.poop.tag = indexPath.row
        cell.poop.addTarget(self, action: "followButton:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        
        
        return cell
        
        
    }
    
    
    
    func followButton(sender: AnyObject){
        //ADDS THE Event to the calendar
        
        
        var eventStore : EKEventStore = EKEventStore()
        
        eventStore.requestAccessToEntityType(EKEntityTypeEvent, completion: {
            granted, error in
            if (granted) && (error == nil) {
                println("granted \(granted)")
                println("error  \(error)")
                
                var event:EKEvent = EKEvent(eventStore: eventStore)
                event.title = self.eventNamed[sender.tag]
                event.startDate = self.eventNS[sender.tag]
                event.endDate = self.eventNS[sender.tag]
                //event.notes = self.eventTitle[sender.tag]
                event.location = self.eventTitle[sender.tag]
                event.calendar = eventStore.defaultCalendarForNewEvents
                eventStore.saveEvent(event, span: EKSpanThisEvent, error: nil)
                println("Saved Event")
            }
        })
        
    }
    
    override func prepareForSegue(segue:UIStoryboardSegue, sender: AnyObject?){
        
        
        //Creates the variables for the post Event cell
        if segue.identifier == "example" {
            var secondViewController : postEvent = segue.destinationViewController as postEvent
            
            println("hey")
           
            
        
            //Get the index path
            var indexPath = theFeed.indexPathForSelectedRow()
            
            var thenum = indexPath?.row
            
            secondViewController.storeLocation = eventTitle[thenum!]
            
            secondViewController.storeTitle = eventNamed[thenum!]
            
            secondViewController.storeStartTime = eventTime[thenum!]
            
            secondViewController.storeDate = eventDate[thenum!]
            
            secondViewController.onsite = onsite[thenum!]
            
            secondViewController.cost = food[thenum!]
            
            secondViewController.food = food[thenum!]
            
           // secondViewController.users = usernames[thenum!]
            
            
        }
        
        
        
    }

    
    
}
