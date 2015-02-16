//
//  subscriberlist.swift
//  UinProto2
//
//  Created by Kareem Dasilva on 2/1/15.
//  Copyright (c) 2015 Kareem Dasilva. All rights reserved.
//

import UIKit

class subscriberlist: UITableViewController {
    var objectId = [String]()
    var folusernames = [String]()
    var folmembers = [Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var followque = PFQuery(className: "subs")
        followque.whereKey("following", equalTo: PFUser.currentUser().username)
        followque.orderByAscending("createdAt")
        followque.findObjectsInBackgroundWithBlock{
            
            (objects:[AnyObject]!, folError:NSError!) -> Void in
            
            
            if folError == nil {
                
                
                for object in objects{
                    self.objectId.append(object.objectId as String)
                    self.folmembers.append(object["member"] as Bool)
                    self.folusernames.append(object["follower"] as String)
                    //change "following" to "subscribers" and "follower" to "Subscribed to"
                    
                    self.tableView.reloadData()
                    
                    
                }
                
            }
            
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
      
         return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        return folusernames.count

    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:FollowCell = self.tableView.dequeueReusableCellWithIdentifier("cell3") as FollowCell
        
        
        
        cell.member.tag = indexPath.row
        
        cell.username.text = folusernames[indexPath.row]
        
        cell.member.addTarget(self, action: "switchmember:", forControlEvents: UIControlEvents.ValueChanged)
        
        return cell
        
    }
    var member = Bool()
    
    func switchmember(sender: UISegmentedControl) {
        
    
        
        switch sender.selectedSegmentIndex {
        case 0:
            member = true
        case 1:
            member = false
    
        default:
            member = false
            break;
        }  //Switch
        
        var membersave = PFQuery(className:"subs")
        membersave.getObjectInBackgroundWithId(objectId[sender.tag]) {
            (result: PFObject!, error: NSError!) -> Void in
            if error == nil {
                
                 result["member"] = self.member
                result.saveInBackgroundWithBlock{
                    
                    (succeeded: Bool!, registerError: NSError!) -> Void in
                    
                    if registerError == nil {
                        
                        println("Worked!")
                        
                    }
                    
                }

                    
                    
                    
    
            } else {
               
                NSLog("%@", error)
            
            }
        }
    
    
        println(member)
        println(objectId[sender.tag])
 

    }
}
