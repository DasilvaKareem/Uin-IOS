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
       /* var eventQuery = PFQuery(className: "Notifications")
        var eventQuerysub = PFQuery(className: "Subs")
        eventQuerysub.whereKey("follower", equalTo: PFUser.currentUser().username)
        eventQuery.whereKey("type", equalTo: "event")
       */
       
       
        var subQuery = PFQuery(className: "Notification")
        subQuery.whereKey("type", equalTo: "sub")
        subQuery.whereKey("receiver", equalTo: PFUser.currentUser().username)
        subQuery.findObjectsInBackgroundWithBlock({
            
            (objects:[AnyObject]!,subError:NSError!) -> Void in
            println("it queryed")
            if subError == nil {
                
                for object in objects {
                    println(object.objectId)
                    var current = object["sender"]
                    var subnote = "\(current) has subscribed to you"
                    self.notes.append(subnote as String)
              
                    self.tableView.reloadData()
                }
                
                
            }
            
            
        })
        
     
        //var calendarQuery = PFQuery(className: "Notifications")
        
        var memberQuery = PFQuery(className: "Notification")
        memberQuery.whereKey("receiver", equalTo: PFUser.currentUser().username)
        memberQuery.whereKey("type", equalTo: "member")
        memberQuery.findObjectsInBackgroundWithBlock({
            
            (objects:[AnyObject]!,subError:NSError!) -> Void in
            println("it queryed")
            if subError == nil {
                
                for object in objects {
                    println(object.objectId)
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
