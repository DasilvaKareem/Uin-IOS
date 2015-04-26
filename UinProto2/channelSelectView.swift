//
//  channelSelectView.swift
//  Uin
//
//  Created by Kareem Dasilva on 4/16/15.
//  Copyright (c) 2015 Kareem Dasilva. All rights reserved.
//

import UIKit

class channelSelectView: UITableViewController {
    
    
    var currentIndexPath:NSIndexPath = NSIndexPath()
    //Channel Sections
    var channels = [String]()
    var channelNames = [String]()
    var channelType = [String]()
    var channelStatus = [Bool]()
    var memBounded = Bool()
    //General Channels
    var genChannels = ["local events", "subscription events"]
    var gentype = ["localEvent","subbedEvents"]
    var genEvents = [String]()
    func setupGenCounters() {
        var localEventCount = PFQuery(className: "Event")
        localEventCount.whereKey("isPublic", equalTo: true)
        localEventCount.whereKey("createdAt", greaterThanOrEqualTo:PFUser.currentUser()["notificationsTimestamp"] as! NSDate)
        self.genEvents.append("\(localEventCount.countObjects()) new")
        
        //Gets Subscriptions Events
        var subscriptionQuery = PFQuery(className: "Subscription")
        subscriptionQuery.whereKey("subscriberID", equalTo: PFUser.currentUser().objectId)
        var subscriptionEventCount = PFQuery(className: "Event")
        subscriptionEventCount.whereKey("authorID", matchesKey: "publisherID", inQuery: subscriptionQuery)
        subscriptionEventCount.whereKey("isPublic", equalTo: true)
        subscriptionEventCount.whereKey("start", greaterThan:  NSDate())
        
        self.genEvents.append("\(subscriptionEventCount.countObjects()) new")
         self.tableView.reloadData()
        
        //Gets Trend
       
        
        
    }
    //Sections
   //User Section
    var userType = [String]()
    var usernameInfo = [String]()
    var usernameSectionTitle = [String]()
 
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        channels.removeAll(keepCapacity: true)
        channelNames.removeAll(keepCapacity: true)
        channelType.removeAll(keepCapacity: true)
        genEvents.removeAll(keepCapacity: true)
        userType.removeAll(keepCapacity: true)
        usernameInfo.removeAll(keepCapacity: true)
        usernameSectionTitle.removeAll(keepCapacity: true)
        getUserInfo()
        getChannels()
        setupGenCounters()
    }
    override func viewWillAppear(animated: Bool) {
    
    var memBoundChange = PFQuery(className: "ChannelUser")
        memBoundChange.whereKey("userID", equalTo: PFUser.currentUser().objectId)
        memBoundChange.whereKey("channelID", equalTo: "wEwRowC6io")
        memBoundChange.getFirstObjectInBackgroundWithBlock({
            (object:PFObject!, error:NSError!) -> Void in
            if error == nil {
                self.memBounded = object["authorized"] as! Bool
            }
        })
      
    }
    override func viewDidAppear(animated: Bool) {
 
    }
    override func viewDidDisappear(animated: Bool) {
      
        genEvents.removeAll(keepCapacity: true)
        userType.removeAll(keepCapacity: true)
        usernameInfo.removeAll(keepCapacity: true)
        usernameSectionTitle.removeAll(keepCapacity: true)
        getUserInfo()
        getChannels()
        setupGenCounters()
    }
    func getChannels(){
        channels.removeAll(keepCapacity: true)
        channelNames.removeAll(keepCapacity: true)
        channelType.removeAll(keepCapacity: true)
        channelStatus.removeAll(keepCapacity: true)
        var channelQuery = PFQuery(className: "ChannelUser")
        channelQuery.whereKey("userID", equalTo: PFUser.currentUser().objectId)
      // channelQuery.whereKey("expiration", greaterThan: NSDate())
        channelQuery.findObjectsInBackgroundWithBlock({
            (results: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                for object in results {
                    self.channels.append(object["channelID"] as! String)
                    self.channelNames.append(object["channelName"] as! String)
                    self.channelStatus.append(object["authorized"] as! Bool)
                    self.channelType.append("channelSelect")
                    println(object["channelID"] as! String)
                }
                self.tableView.reloadData()
            }
        })
    }
    func getUserInfo(){
     
        
        var subscriberInfo = PFQuery(className: "Subscription") //gets the subcsriber count
        subscriberInfo.whereKey("publisher", equalTo: PFUser.currentUser().username)
        usernameInfo.append(String(subscriberInfo.countObjects()))
        usernameSectionTitle.append("subscriptions")
        userType.append("Subscriptions")
        
        var subscriptionInfo = PFQuery(className: "Subscription") //gets the subscription count
        subscriptionInfo.whereKey("subscriber", equalTo: PFUser.currentUser().username)
        usernameInfo.append(String(subscriptionInfo.countObjects()))
        usernameSectionTitle.append("subscribers")
        userType.append("Subscribers")
        
    
        
   
        
        var notificationsCount = PFQuery(className: "Notification")
        notificationsCount.whereKey("receiver", equalTo: PFUser.currentUser().username)
        notificationsCount.whereKey("createdAt", greaterThan: PFUser.currentUser()["notificationsTimestamp"] as! NSDate)
        usernameInfo.append(String("\(notificationsCount.countObjects()) notifications"))
        usernameSectionTitle.append("notifications")
        userType.append("Notifications")
        var addToCalendarCount = PFQuery(className: "Event")
        addToCalendarCount.whereKey("authorID", equalTo: PFUser.currentUser().objectId)
        addToCalendarCount.whereKey("start", greaterThan: NSDate())
        
        usernameInfo.append("\(addToCalendarCount.countObjects()) upcoming")
        usernameSectionTitle.append("my events")
        userType.append("My Events")
         self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 37.0
    }
    
    
    override func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
        var cell:channelTableCell = tableView.dequeueReusableCellWithIdentifier("profile") as! channelTableCell
        
        
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        var totalSections = usernameSectionTitle +  genChannels + channelNames
        
        if section ==  0 {
            return usernameSectionTitle.count
        }
        if section ==  1 {
            return genChannels.count
        }
        if section ==  2 {
        
            return channelNames.count
        }
        return totalSections.count
    }
    
    


   
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var cell:channelSectionCell = tableView.dequeueReusableCellWithIdentifier("sectionHeader") as! channelSectionCell

        if section == 0 {
             var cell:channelHeaderCell = tableView.dequeueReusableCellWithIdentifier("header") as! channelHeaderCell
            cell.headerLabel.text = PFUser.currentUser().username

            return cell
        }
        if section == 1 {
            cell.sectionHeader.text = "GENERAL CALENDARS"
            cell.channelSeparator.image = UIImage(named: "sidebarLine.png")
            
        }
        if section == 2 {
            cell.sectionHeader.text = "MY CALENDARS"
            cell.channelSeparator.image = UIImage(named: "sidebarLine.png")
            
        }
        
        
        return cell
    }
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section != 0 {
            return 30.0
        }
        
        return 37.0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
       var totalSections = usernameSectionTitle +  genEvents + channelNames
        var cell:channelTableCell = tableView.dequeueReusableCellWithIdentifier("profile") as! channelTableCell
       cell.channelCount.text = usernameInfo[indexPath.row]
    
        if indexPath.row == 0 {
            cell.channelName.textColor = UIColor(red: 245.0/255.0, green: 166.0/255.0, blue: 35.0/255.0, alpha: 1)
            cell.channelCount.textColor = UIColor(red: 245.0/255.0, green: 166.0/255.0, blue: 35.0/255.0, alpha: 1)
        }
        if indexPath.row == 1 {
            cell.channelName.textColor = UIColor(red: 245.0/255.0, green: 166.0/255.0, blue: 35.0/255.0, alpha: 1)
            cell.channelCount.textColor = UIColor(red: 245.0/255.0, green: 166.0/255.0, blue: 35.0/255.0, alpha: 1)
        }
        
        cell.channelName.text = totalSections[indexPath.row]
        cell.channelName.tag = indexPath.row
        if self.currentIndexPath == indexPath {
            cell.contentView.backgroundColor = UIColor(red: 65.0/255.0, green: 145.0/255.0, blue: 198.0/255.0, alpha: 1)
            cell.channelName.textColor = UIColor.whiteColor()
            cell.channelCount.textColor = UIColor.whiteColor()
            
                cell.channelName.textColor = UIColor.whiteColor()
                cell.channelCount.textColor = UIColor.whiteColor()
                 cell.contentView.backgroundColor = UIColor(red: 245.0/255.0, green: 166.0/255.0, blue: 35.0/255.0, alpha: 1)
            
        } else {
            cell.contentView.backgroundColor = nil
                if indexPath.row == 0 || indexPath.row == 1 {
                    cell.channelName.textColor = UIColor(red: 245.0/255.0, green: 166.0/255.0, blue: 35.0/255.0, alpha: 1)
                    cell.channelCount.textColor = UIColor(red: 245.0/255.0, green: 166.0/255.0, blue: 35.0/255.0, alpha: 1)
                } else {
                    cell.channelName.textColor = UIColor(red: 211.0/255.0, green: 211.0/255.0, blue: 211.0/255.0, alpha: 1)
                    cell.channelCount.textColor = UIColor(red: 211.0/255.0, green: 211.0/255.0, blue: 211.0/255.0, alpha: 1)
            }

        }
        
        if indexPath.section == 1 {
         
             cell = tableView.dequeueReusableCellWithIdentifier("profilez") as! channelTableCell
            cell.channelName.text = genChannels[indexPath.row]
            cell.channelCount.text = genEvents[indexPath.row]
            if self.currentIndexPath == indexPath {
                cell.contentView.backgroundColor = UIColor(red: 65.0/255.0, green: 145.0/255.0, blue: 198.0/255.0, alpha: 1)
                cell.channelName.textColor = UIColor.whiteColor()
                cell.channelCount.textColor = UIColor.whiteColor()
            }
            else {
                cell.contentView.backgroundColor = nil
                cell.channelName.textColor = UIColor(red: 211.0/255.0, green: 211.0/255.0, blue: 211.0/255.0, alpha: 1)
                cell.channelCount.textColor = UIColor(red: 211.0/255.0, green: 211.0/255.0, blue: 211.0/255.0, alpha: 1)
            }
        }
        if indexPath.section == 2 {
            cell = tableView.dequeueReusableCellWithIdentifier("profiles") as! channelTableCell
            cell.channelName.text = channelNames[indexPath.row]
            //Affect the cell apperance
            if self.currentIndexPath == indexPath {
                cell.contentView.backgroundColor = UIColor(red: 65.0/255.0, green: 145.0/255.0, blue: 198.0/255.0, alpha: 1)
                cell.channelName.textColor = UIColor.whiteColor()
                cell.channelCount.textColor = UIColor.whiteColor()
            }
            else {
                cell.contentView.backgroundColor = nil
                cell.channelName.textColor = UIColor(red: 211.0/255.0, green: 211.0/255.0, blue: 211.0/255.0, alpha: 1)
                cell.channelCount.textColor = UIColor(red: 211.0/255.0, green: 211.0/255.0, blue: 211.0/255.0, alpha: 1)
            }
            //Locks the image
            if channelStatus[indexPath.row] == false {
                cell.channelCount.text = "Locked"
            } else {
                cell.channelCount.text = "Open"
            }
           
        }
      
        return cell
        
    }
    
    

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
         var allTypes = userType + gentype + channelType
        var cell:channelTableCell = tableView.cellForRowAtIndexPath(indexPath) as! channelTableCell
        cell.contentView.backgroundColor = UIColor(red: 65.0/255.0, green: 145.0/255.0, blue: 198.0/255.0, alpha: 1)
        cell.channelCount.textColor = UIColor.whiteColor()
        cell.channelName.textColor = UIColor.whiteColor()
        self.currentIndexPath = indexPath
    
        
               if indexPath.section == 0 {
                //changes background cell color to orange
                
                    cell.contentView.backgroundColor = UIColor(red: 245.0/255.0, green: 166.0/255.0, blue: 35.0/255.0, alpha: 1)
                    cell.channelName.textColor = UIColor.whiteColor()
                    cell.channelCount.textColor = UIColor.whiteColor()
              
                    switch userType[indexPath.row] {
                        
                    case "Subscriptions":
                        self.performSegueWithIdentifier("Subscribers", sender: self)
                        break
                    case "Subscribers":
                        self.performSegueWithIdentifier("Subscriptions", sender: self)
                        break
                    case "Notifications":
                        self.performSegueWithIdentifier("Notifications", sender: self)
                        break
                    case "My Events":
                        self.performSegueWithIdentifier("My Events", sender: self)
                    default:
                        break
                    }
                
     
        }
     
            if indexPath.section == 1 {
               
                if self.memBounded == true {
                    println("You are membounded")
                    var alert = UIAlertController(title: "You are blocked", message: "New World Order", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                 self.performSegueWithIdentifier("channelSelect", sender: self)
             
            }
        
      
        if indexPath.section == 2 {
            var text = String()
            var channelQuery = PFQuery(className: "ChannelUser")
            channelQuery.whereKey("userID", equalTo: PFUser.currentUser().objectId)
            channelQuery.whereKey("channelID", equalTo: channels[indexPath.row])
            var checkAuthorized = channelQuery.getFirstObject()
            if checkAuthorized["authorized"] as! Bool == false {
                let page1:OnboardingContentViewController = OnboardingContentViewController(title: "Poop", body: "Luffy", image: UIImage(named: "settings"), buttonText: "Gear 4", action: {
                    
                })
                let page2:OnboardingContentViewController = OnboardingContentViewController(title: "Poop", body: "Luffy", image: UIImage(named: "settings"), buttonText: "Gear 4", action: {
                    
                })
                let page3:OnboardingContentViewController = OnboardingContentViewController(title: "Poop", body: "Luffy", image: UIImage(named: "settings"), buttonText: "Gear 4", action: {
                    var alert = UIAlertController(title: "Locked Channel", message: "Enter cide", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
                    alert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
                        textField.placeholder = "Code"
                        textField.secureTextEntry = false
                        text = textField.text
                        println(textField.text)
                    })
                    alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler:{ (alertAction:UIAlertAction!) in
                        
                        let textf = alert.textFields?[0] as! UITextField
                        var pinCheck = PFQuery(className: "ChannelCodeInfo")
                        pinCheck.whereKey("channelID", equalTo: self.channels[indexPath.row])
                        pinCheck.whereKey("validationCode", equalTo:textf.text )
                        pinCheck.getFirstObjectInBackgroundWithBlock({
                            (object1:PFObject!, error:NSError!) -> Void in
                            if error == nil {
                                var expDate = object1["expiration"] as! NSDate
                                var changeBound = PFQuery(className: "ChannelUser")
                                changeBound.whereKey("userID", equalTo: PFUser.currentUser().objectId)
                                changeBound.whereKey("channelID", equalTo: self.channels[indexPath.row])
                                changeBound.getFirstObjectInBackgroundWithBlock({
                                    (object2:PFObject!, error:NSError!) -> Void in
                                    object2["authorized"] = true
                                    object2["expiration"] = expDate
                                    object2.save()
                                    
                                    self.getChannels()
                                    self.tableView.reloadData()
                                })
                            } else {
                                println("You did not enter the right code")
                            }
                        })
                       
                    }))
                    self.dismissViewControllerAnimated(true, completion: nil)
                    self.presentViewController(alert, animated: true, completion: nil)
                })
                
                let allPages:OnboardingViewController = OnboardingViewController(backgroundImage: UIImage(named: "settings"), contents: [page1,page2,page3])
                allPages.skipButton.enabled = true
                allPages.allowSkipping = true
                allPages.skipHandler = {
                    println("it was skipped")
                    var alert = UIAlertController(title: "Locked Channel", message: "Enter cide", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
                    alert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
                        textField.placeholder = "Code"
                        textField.secureTextEntry = false
                        text = textField.text
                        println(textField.text)
                    })
                    alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler:{ (alertAction:UIAlertAction!) in
                        
                        let textf = alert.textFields?[0] as! UITextField
                        var pinCheck = PFQuery(className: "ChannelCodeInfo")
                        pinCheck.whereKey("channelID", equalTo: self.channels[indexPath.row])
                        pinCheck.whereKey("validationCode", equalTo:textf.text )
                        pinCheck.getFirstObjectInBackgroundWithBlock({
                            (object1:PFObject!, error:NSError!) -> Void in
                            if error == nil {
                                var expDate = object1["expiration"] as! NSDate
                                var changeBound = PFQuery(className: "ChannelUser")
                                changeBound.whereKey("userID", equalTo: PFUser.currentUser().objectId)
                                changeBound.whereKey("channelID", equalTo: self.channels[indexPath.row])
                                changeBound.getFirstObjectInBackgroundWithBlock({
                                    (object2:PFObject!, error:NSError!) -> Void in
                                    object2["authorized"] = true
                                    object2["expiration"] = expDate
                                    object2.save()
                                    
                                    self.getChannels()
                                    self.tableView.reloadData()
                                })
                            } else {
                                println("You did not enter the right code")
                            }
                        })
                        
                    }))
                    self.dismissViewControllerAnimated(true, completion: nil)
                    self.presentViewController(alert, animated: true, completion: nil)

                }
                self.presentViewController(allPages, animated: true, completion: nil)
            }
           
             else {
                  self.performSegueWithIdentifier("channelSelect", sender: self)
            }
          
            
        }
        
      
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
   
        if segue.identifier == "channelSelect" {
              var allInfo = usernameInfo + gentype + channels
          
            var indexPath = tableView.indexPathForSelectedRow()
            let nav = segue.destinationViewController as! UINavigationController
            let eventFeed:eventFeedViewController = nav.topViewController as! eventFeedViewController
            var row = indexPath?.row
      
            if indexPath?.section == 1 {
                eventFeed.channelID = gentype[row!]
            }
            if indexPath?.section == 2 {
                eventFeed.channelID = channels[row!]
            }
            
            
            
        }
    }


}

