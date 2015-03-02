//
//  notificationsView.swift
//  UinProto2
//
//  Created by Kareem Dasilva on 2/14/15.
//  Copyright (c) 2015 Kareem Dasilva. All rights reserved.
//

import UIKit

class notificationsView: UITableViewController {
   
    var notes = [String]()
  
    var times = [NSDate]()
    var localTime = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.hidden = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navBarBackground.png"), forBarMetrics: UIBarMetrics.Default)
        
        // Changes text color on navbar
        var nav = self.navigationController?.navigationBar
        nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()];
        notify()
               }
        
    override func viewDidDisappear(animated: Bool) {
    self.notes.removeAll(keepCapacity: true)
    notify()
}
    func notify(){
        var eventQuery = PFQuery(className: "Notification")
        var folusernames = [String]()
        var followque = PFQuery(className: "Subs")
        followque.whereKey("follower", equalTo: PFUser.currentUser().username)
        followque.findObjectsInBackgroundWithBlock{
            
            (objects:[AnyObject]!, folError:NSError!) -> Void in
            
            
            if folError == nil {
                
                
                for object in objects{
                    println("it worked")
                    folusernames.append(object["following"] as String)
                    
                    
                }
                println(folusernames)
                
                eventQuery.whereKey("type", equalTo: "event" )
                eventQuery.whereKey("sender", containedIn: folusernames)
                
                
            }
            
        }
        
        
        
        
        var subQuery = PFQuery(className: "Notification")
        subQuery.whereKey("type", equalTo: "sub")
        subQuery.whereKey("receiver", equalTo: PFUser.currentUser().username)
        
        
        
        
        var calendarQuery = PFQuery(className: "Notification")
        calendarQuery.whereKey("receiver", equalTo: PFUser.currentUser().username)
        calendarQuery.whereKey("type", equalTo: "calendar")
        
        
        
        
        var memberQuery = PFQuery(className: "Notification")
        memberQuery.whereKey("receiver", equalTo: PFUser.currentUser().username)
        memberQuery.whereKey("type", equalTo: "member")
        
        
        var query = PFQuery.orQueryWithSubqueries([memberQuery, subQuery, calendarQuery, eventQuery ])
        query.limit = 20
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock({
            (objects:[AnyObject]!,subError:NSError!) -> Void in
            println("it queryed")
            if subError == nil {
                
                for object in objects {
                    println(object.objectId)
                    
                    self.times.append(object.createdAt)
                    
                    switch object["type"] as String {
                    case "event":
                        var current = object["sender"] as String
                        var eventnote = "\(current) has made an event"
                        self.notes.append(eventnote as String)
                        
                        break
                    case "calendar":
                        var current = object["sender"] as String
                        var eventnote = "\(current) has added your event to their calendar"
                        self.notes.append(eventnote as String)
                        
                        break
                        
                    case "sub":
                        var current = object["sender"] as String
                        var eventnote = "\(current) has subscribed to you"
                        self.notes.append(eventnote as String)
                        
                        break
                        
                    case "member":
                        var current = object["sender"] as String
                        var eventnote = "\(current) has change your member status"
                        self.notes.append(eventnote as String)
                        
                        break
                    default:
                        println("unknown has happen please refer back to parse database")
                        break
                        
                        
                    }
                    
                    
                }
                for i in self.times {
                    var dateFormatter = NSDateFormatter()
                    dateFormatter.locale = NSLocale.currentLocale()
                    dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
                    var realDate = dateFormatter.stringFromDate(i)
                    var dateFormatter2 = NSDateFormatter()
                    dateFormatter2.timeStyle = NSDateFormatterStyle.ShortStyle
                    var localTime = dateFormatter2.stringFromDate(i)
                    var date = "\(realDate)  \(localTime)"
                    self.localTime.append(date)
                    
                    
                }
                self.tableView.reloadData()
                
            }
            
            
            
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return notes.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:subCell = tableView.dequeueReusableCellWithIdentifier("Cell") as subCell
     
        cell.timeStamp.text = localTime[indexPath.row]
        
        cell.notifyMessage.text = notes[indexPath.row]
        
        return cell
    }
    



}
