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
                eventQuery.findObjectsInBackgroundWithBlock({
                    (objects:[AnyObject]!,eventError:NSError!) -> Void in
                    println("it queryed")
                    if eventError == nil {
                        
                        for object in objects {
                            println(object.objectId)
                            var current = object["sender"]
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
        subQuery.findObjectsInBackgroundWithBlock({
            
            (objects:[AnyObject]!,subError:NSError!) -> Void in
            println("it queryed")
            if subError == nil {
                
                for object in objects {
                   // println(object.objectId)
                    var current = object["sender"]
                    var subnote = "\(current) has subscribed to you"
                    self.notes.append(subnote as String)
                    self.tableView.reloadData()
                }
                
                
            }
            
            
        })
        
     
        var calendarQuery = PFQuery(className: "Notification")
        calendarQuery.whereKey("receiver", equalTo: PFUser.currentUser().username)
        calendarQuery.whereKey("type", equalTo: "calendar")
        calendarQuery.findObjectsInBackgroundWithBlock({
            (objects:[AnyObject]!, calendarError:NSError!) -> Void in
            
            if calendarError == nil {
                
                for object in objects {
                    
                    var current = object["sender"]
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
                    var current = object["sender"]
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
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
     
        
        cell.textLabel?.text = notes[indexPath.row]
        
        return cell
    }
    



}
