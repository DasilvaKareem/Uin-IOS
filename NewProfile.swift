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
    
    
    
    @IBOutlet weak var theFeed: UITableView!
    
    var onsite = [Bool]()
    var paid = [Bool]()
    var food = [Bool]()
    var eventTitle = [String]()
    var eventNamed = [String]()
    var eventTime = [String]()
    var eventDate = [String]()
    var eventNS = [NSDate]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        orgName.text = PFUser.currentUser().username
        var que = PFQuery(className: "event")
        que.orderByAscending("dateTime")
        que.whereKey("user", equalTo: PFUser.currentUser().username)
        que.findObjectsInBackgroundWithBlock{
        
            (objects:[AnyObject]!,eventError:NSError!) -> Void in
            
            if eventError == nil {
                
                
                for object in objects{
                    
                    println(object.objectId)
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
        }              // Do any additional setup after loading the view.
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
    
    
    
    
    
    
    
    
    var number = [Int]()
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        // Puts the data in a cell
        var cell:eventCell = tableView.dequeueReusableCellWithIdentifier("cell2") as eventCell
        
        if onsite[indexPath.row] == true {
            
            
            cell.location.image = UIImage(named: "oncampusicon@3x.png")
            
            
            
        }
        else{
            
            cell.location.image = UIImage(named: "offCampus@3x.png")
            
            cell.onCampusText.text = "Off-Campus"
            cell.onCampusText.textColor = UIColor.lightGrayColor()
            
        }
        
        if food[indexPath.row] == true {
            
            
            cell.food.image = UIImage(named: "foodicon@3x.png")
            
            
            
            
        }
        else{
            
            cell.food.image = UIImage(named: "noFood@3x.png")
            
            cell.foodText.text = "No Food"
            cell.foodText.textColor = UIColor.lightGrayColor()
            
            
        }
        if paid[indexPath.row] == false {
            
            
            cell.paid.image = UIImage(named: "freeicon@3x.png")
            
            
            
        }
        else{
            
            cell.paid.image = UIImage(named: "noFree@3x.png")
            
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
        // Puts the data in a cell
        
        
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
    
    
}
