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
    var subscriberID = [String]()
    var foluserID = [String]()
    
    @IBOutlet var sideBar: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Subscriber"
        let theMix = Mixpanel.sharedInstance()
        theMix.track("Subscribers Opened")
        theMix.flush()
        
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navBarBackground.png"), forBarMetrics: UIBarMetrics.Default)
    
          self.navigationController?.navigationBar.backIndicatorImage = nil
     
        // Changes text color on navbar
        let nav = self.navigationController?.navigationBar
        nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()];
        
        //Queries for all the people who are subscribed to you
        let followque = PFQuery(className: "Subscription")
        followque.whereKey("publisher", equalTo: PFUser.currentUser()!.username!)
        followque.orderByAscending("createdAt")
        followque.findObjectsInBackgroundWithBlock{
            
            (objects:[PFObject]?,folError:NSError?) -> Void in
            
            
            if folError == nil {
                self.objectId.removeAll(keepCapacity: true)
                self.folusernames.removeAll(keepCapacity: true)
                self.folmembers.removeAll(keepCapacity: true)
                for object in objects!{
                    self.objectId.append(object.objectId!)
                    self.folmembers.append(object["isMember"] as!Bool)
                    self.folusernames.append(object["subscriber"] as!String)
                    self.foluserID.append(object["publisherID"] as!String)
                    //change "following" to "subscribers" and "follower" to "Subscribed to"
                    self.tableView.reloadData()
                }
                
            }
            
            
        }
        
    }
    override func viewWillAppear(animated: Bool) {
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navBarBackground.png"), forBarMetrics: UIBarMetrics.Default)
        if self.revealViewController() != nil {
            sideBar.target = self.revealViewController()
            sideBar.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
                self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("userprofile", sender: self)
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
      
         return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        return folusernames.count

    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell:FollowCell = self.tableView.dequeueReusableCellWithIdentifier("cell3") as! FollowCell
        cell.member.tag = indexPath.row
        cell.username.text = folusernames[indexPath.row]
        let membersave = PFQuery(className:"Subscription")
        membersave.getObjectInBackgroundWithId(objectId[indexPath.row]) {
            (result: PFObject?, error: NSError?) -> Void in
            if error == nil {
            if result!["isMember"] as!Bool == true{
                cell.member.selectedSegmentIndex = 0
            }
            else {
                cell.member.selectedSegmentIndex = 1
                }
            }
        }
        
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
        
        let membersave = PFQuery(className:"Subscription")
        membersave.getObjectInBackgroundWithId(objectId[sender.tag]) {
            (result: PFObject?, error: NSError?) -> Void in
            if error == nil {
                 result!["isMember"] = self.member
                result!.saveInBackgroundWithBlock{
                    (succeeded: Bool, registerError: NSError?) -> Void in
                    if registerError == nil {
                        
                        let push = PFPush()
                        let pfque = PFInstallation.query()
                        pfque!.whereKey("user", equalTo:self.folusernames[sender.tag] )
                        push.setQuery(pfque)
                       
                        push.setMessage("\(PFUser.currentUser()!.username) has changed your membership status")
                
                        push.sendPushInBackgroundWithBlock({
                            (success:Bool, pushError: NSError?) -> Void in
                            if pushError == nil {
                                print("Push was Sent")
                            } else {
                                print("Push was not sent")
                            }
                        })
                        
                        //Creates an in app notfication
                        let notify = PFObject(className: "Notification")
                        notify["senderID"] = PFUser.currentUser()!.objectId
                        notify["sender"] = PFUser.currentUser()!.username
                        notify["receiver"] = self.folusernames[sender.tag]
                        notify["receiverID"] = self.foluserID[sender.tag]
                        notify["type"] =  "member"
                        notify.saveInBackgroundWithBlock({
                            
                            (success:Bool, notifyError: NSError?) -> Void in
                            
                            if notifyError == nil {
                                
                                print("notifcation has been saved")
                                
                            }
                            
                            
                        })

                        print("Worked!")
                        
                    }
                    
                }

            } else {
               
                NSLog("%@", error!)
            
            }
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            }
}
