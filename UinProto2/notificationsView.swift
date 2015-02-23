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
                var eventQuery = PFQuery(className: "Notification")
                eventQuery.whereKey("type", equalTo: "event" )
                eventQuery.whereKey("sender", containedIn: folusernames)
                eventQuery.orderByDescending("createdAt")
                eventQuery.limit = 10
                eventQuery.findObjectsInBackgroundWithBlock({
                    (objects:[AnyObject]!,eventError:NSError!) -> Void in
                    println("it queryed")
                    if eventError == nil {
                       
                        for object in objects {
                            println(object.objectId)
                            var current = object["sender"] as String
                            var eventnote = "\(current) has made an event"
                            self.notes.append(eventnote as String)
                            self.tableView.reloadData()
                        }
                        
                    }
                    
                    
                    
                })
                
            }
            
        }



       
       
        var subQuery = PFQuery(className: "Notification")
        subQuery.whereKey("type", equalTo: "sub")
        subQuery.whereKey("receiver", equalTo: PFUser.currentUser().username)
        subQuery.orderByDescending("createdAt")
        subQuery.limit = 10
        subQuery.findObjectsInBackgroundWithBlock({
            
            (objects:[AnyObject]!,subError:NSError!) -> Void in
            println("it queryed")
            if subError == nil {
                
                for object in objects {
                   // println(object.objectId)
                    var current = object["sender"] as String
                    var subnote = "\(current) has subscribed to you"
                    self.notes.append(subnote as String)
                    self.tableView.reloadData()
                }
                
                
            }
            
            
        })
        
     
        var calendarQuery = PFQuery(className: "Notification")
        calendarQuery.whereKey("receiver", equalTo: PFUser.currentUser().username)
        calendarQuery.whereKey("type", equalTo: "calendar")
        calendarQuery.orderByDescending("createdAt")
        calendarQuery.limit = 10
        calendarQuery.findObjectsInBackgroundWithBlock({
            (objects:[AnyObject]!, calendarError:NSError!) -> Void in
            
            if calendarError == nil {
                
                for object in objects {
                    
                    var current = object["sender"] as String
                    var calendarNote = "\(current) has added your Event to their calendar"
                    self.notes.append(calendarNote as String)
                    self.tableView.reloadData()
                    
                }
                
            }
            
            
        })
        
        
        var memberQuery = PFQuery(className: "Notification")
        memberQuery.whereKey("receiver", equalTo: PFUser.currentUser().username)
        memberQuery.whereKey("type", equalTo: "member")
        memberQuery.findObjectsInBackgroundWithBlock({
            
            (objects:[AnyObject]!,subError:NSError!) -> Void in
            println("it queryed")
            if subError == nil {
                
                for object in objects {
                   // println(object.objectId)
                    var current = object["sender"] as String
                       var membernote = "\(current) changed your member status"
                    self.notes.append(membernote as String)
                   
                    self.tableView.reloadData()
                }
                
                
            }
            
        })
        //self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
     
        
        cell.notifyMessage.text = notes[indexPath.row]
        
        return cell
    }
    



}
