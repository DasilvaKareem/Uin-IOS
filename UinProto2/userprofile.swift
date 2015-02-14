//
//  userprofile.swift
//  UinProto2
//
//  Created by Kareem Dasilva on 2/1/15.
//  Copyright (c) 2015 Kareem Dasilva. All rights reserved.
//

import UIKit

class userprofile: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var username: UILabel!
    
    @IBOutlet var theFeed: UITableView!
    var theUser = String()
    var memberStatus = [Bool]()
    var onsite = [Bool]()
    var paid = [Bool]()
    var food = [Bool]()
    var eventTitle = [String]()
    var eventNamed = [String]()
    var eventTime = [String]()
    var eventDate = [String]()
    var eventNS = [NSDate]()
    var usernames = [String]()
    
    
    @IBOutlet weak var subbutton: UIButton!
    
    @IBAction func subscribe(sender: AnyObject) {
        
        var que = PFQuery(className: "Subs")
        
        que.whereKey("follower", equalTo:PFUser.currentUser().username)
        que.whereKey("following", equalTo: theUser)
        que.getFirstObjectInBackgroundWithBlock{

        
            (object:PFObject!, error: NSError!) -> Void in
            
            if object == nil {
            
            var subscribe = PFObject(className: "Subs")
            subscribe["member"] = false
            subscribe["follower"] = PFUser.currentUser().username
            subscribe["following"] = self.theUser
            subscribe.saveInBackgroundWithBlock{
                
                
                (success:Bool!,subError:NSError!) -> Void in
                
                /* var currentInstallation = PFInstallation.currentInstallation()
                currentInstallation["user"] = PFUser.currentUser().username
                currentInstallation["userId"] = PFUser.currentUser().objectId
                currentInstallation.addUniqueObject(self.theUser, forKey: "channels")
                currentInstallation.saveInBackgroundWithBlock({
                    
                    (success:Bool!, saveerror: NSError!) -> Void in
                    
                    if saveerror == nil {
                        
                        println("it worked")
                        
                    }
                        
                    else {
                        
                        println("It didnt work")
                        
                    }
                    
                    
                })
                */
                
                
                if (subError == nil){
                
                    var notify = PFObject(className: "Notification")
                    notify["sender"] = PFUser.currentUser().username
                    notify["receiver"] = self.theUser
                    notify["type"] =  "sub"
                    notify.saveInBackgroundWithBlock({
                        
                        (success:Bool!, notifyError: NSError!) -> Void in
                        
                        if notifyError == nil {
                            
                            println("notifcation has been saved")
                            
                        }
                        
                        
                    })
                    
                    self.subbutton.setTitle("Unsubscribe", forState: UIControlState.Normal)
                    
                }
                
                
                
                }
                
                }
            
            else {
                
                
                
                var unsub = PFQuery(className: "Subs")
                
                unsub.whereKey("follower", equalTo:PFUser.currentUser().username)
                unsub.whereKey("following", equalTo: self.theUser)
                unsub.getFirstObjectInBackgroundWithBlock{
                    
                    (object:PFObject!, error: NSError!) -> Void in
                    
                    
                    if object != nil{
                        
                        object.delete()
                        
            
                        
                        println(object["member"])
                        
                         self.subbutton.setTitle("Subscribe", forState: UIControlState.Normal)
                        
                    }
                    
                    else {
                        
                        println("fail")
                        
                    }
                    
                        
              
                
                
                
            }
        }
        
        }
    }
    
    func eventList(){
      
        
        var que = PFQuery(className: "event")
        
        que.orderByAscending("dateTime")
        
        que.whereKey("user", equalTo: theUser)
     
        
        que.findObjectsInBackgroundWithBlock{
            
            (objects:[AnyObject]!,eventError:NSError!) -> Void in
            
            if eventError == nil {
                
                
                for object in objects{
                    
                    
                     self.usernames.append(object["user"] as String)
                    
                //    self.eventNS.append(object["startEvent"] as NSDate)
                    
                    self.eventTitle.append(object["sum"] as String)
                    
                    self.eventDate.append(object["startdate"] as String)
                    
                    self.eventTime.append(object["starttime"] as String)
                    
                    self.food.append(object["food"] as Bool)
                    
                    self.paid.append(object["paid"] as Bool)
                    
                    self.onsite.append(object["location"] as Bool)
                    
                    self.eventNamed.append(object["title"] as String)
                    
                    self.theFeed.reloadData()
                    
                    
                }
            }
        }
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

    
    func ChangeSub(){
        
        var que = PFQuery(className: "Subs")
        
        que.whereKey("follower", equalTo:PFUser.currentUser().username)
        que.whereKey("following", equalTo: theUser)
        que.getFirstObjectInBackgroundWithBlock{
            
            (object:PFObject!, error: NSError!) -> Void in
            
            
            if object == nil{
                
               
                
            }
            
            else {
                
               self.subbutton.setTitle("Unsubscribe", forState: UIControlState.Normal)
                
            }
            
            
        }


    }



    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventList()
        ChangeSub()
        username.text = theUser
        if PFUser.currentUser().username ==  theUser  {
            
            username.text = "You"
            subbutton.hidden = true
            
            
            
        }
        
     

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

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
        
        cell.people.text = usernames[indexPath.row]
        cell.time.text = eventTime[indexPath.row]
        cell.eventName.text = eventNamed[indexPath.row]
        cell.poop.tag = indexPath.row
        cell.poop.addTarget(self, action: "followButton:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        
        
        return cell
        
        
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



