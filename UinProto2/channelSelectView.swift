//
//  channelSelectView.swift
//  Uin
//
//  Created by Kareem Dasilva on 4/16/15.
//  Copyright (c) 2015 Kareem Dasilva. All rights reserved.
//

import UIKit

class channelSelectView: UITableViewController {
    
    //Channel Sections
    var channels = [String]()
    var channelNames = [String]()
    var channelType = [String]()
    //General Channels
    var genChannels = ["Local Event", "Subscriptions", "Trending Events"]
    var gentype = ["localEvent","subbedEvents","trending"]
    var genEvents = [String]()
    func setupGenCounters() {
        var localEventCount = PFQuery(className: "Event")
        localEventCount.whereKey("isPublic", equalTo: true)
        localEventCount.whereKey("createdAt", greaterThanOrEqualTo:PFUser.currentUser()["notificationsTimestamp"] as! NSDate)
        self.genEvents.append(String(localEventCount.countObjects()))
        
        //Gets Subscriptions Events
        var subscriptionQuery = PFQuery(className: "Subscription")
        subscriptionQuery.whereKey("subscriberID", equalTo: PFUser.currentUser().objectId)
        var subscriptionEventCount = PFQuery(className: "Event")
        subscriptionEventCount.whereKey("authorID", matchesKey: "publisherID", inQuery: subscriptionQuery)
        subscriptionEventCount.whereKey("isPublic", equalTo: true)
        subscriptionEventCount.whereKey("start", greaterThan:  NSDate())
        self.genEvents.append(String(subscriptionEventCount.countObjects()))
        
        
        //Gets Trend
       
        self.genEvents.append("Poop")
        
    }
    //Sections
   //User Section
    var userType = [String]()
    var usernameInfo = [String]()
    var usernameSectionTitle = [String]()
 
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
    }
    override func viewWillAppear(animated: Bool) {
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
    func getChannels(){
        var channelQuery = PFQuery(className: "ChannelUser")
        channelQuery.whereKey("userID", equalTo: PFUser.currentUser().objectId)
        channelQuery.findObjectsInBackgroundWithBlock({
            (results: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                for object in results {
                    self.channels.append(object["channelID"] as! String)
                    self.channelNames.append(object["channelName"] as! String)
                    self.channelType.append("channelSelect")
                    println(object["channelID"] as! String)
                }
                self.tableView.reloadData()
            }
        })
    }
    func getUserInfo(){
        usernameInfo.append("") //Gets the Username
        usernameSectionTitle.append(PFUser.currentUser().username)
        userType.append("profile")
        
        var subscriberInfo = PFQuery(className: "Subscription") //gets the subcsriber count
        subscriberInfo.whereKey("publisher", equalTo: PFUser.currentUser().username)
        usernameInfo.append(String(subscriberInfo.countObjects()))
        usernameSectionTitle.append("Subscriptions")
        userType.append("Subscriptions")
        
        var subscriptionInfo = PFQuery(className: "Subscription") //gets the subscription count
        subscriptionInfo.whereKey("subscriber", equalTo: PFUser.currentUser().username)
        usernameInfo.append(String(subscriptionInfo.countObjects()))
        usernameSectionTitle.append("Subscribers")
        userType.append("Subscribers")
        
    
        
   
        
        var notificationsCount = PFQuery(className: "Notification")
        notificationsCount.whereKey("receiver", equalTo: PFUser.currentUser().username)
        notificationsCount.whereKey("createdAt", greaterThan: PFUser.currentUser()["notificationsTimestamp"] as! NSDate)
        usernameInfo.append(String(notificationsCount.countObjects()))
        usernameSectionTitle.append("Notifications")
        userType.append("Notifications")
        var addToCalendarCount = PFQuery(className: "Event")
        addToCalendarCount.whereKey("authorID", equalTo: PFUser.currentUser().objectId)
        addToCalendarCount.whereKey("start", greaterThan: NSDate())
        usernameInfo.append(String(addToCalendarCount.countObjects()))
        usernameSectionTitle.append("My Events")
        userType.append("My Events")
    }
    func getLocalChannel(){
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
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
        var cell:channelHeaderCell = tableView.dequeueReusableCellWithIdentifier("header") as! channelHeaderCell
        if section == 0 {
            cell.headerLabel.text = PFUser.currentUser().username
        }
        if section == 1 {
            cell.headerLabel.text = "Chicken"
            cell.accView.image = nil
        }
        if section == 2 {
            cell.accView.image = nil
            cell.headerLabel.text = "Poop"
            
        }
        
        
        return cell
    }
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
       var totalSections = usernameSectionTitle +  genEvents + channelNames
        var cell:channelTableCell = tableView.dequeueReusableCellWithIdentifier("profile") as! channelTableCell
       cell.channelCount.text = usernameInfo[indexPath.row]
    
        cell.channelName.text = totalSections[indexPath.row]
        cell.channelName.tag = indexPath.row
        
       
        if indexPath.section == 1 {
             cell = tableView.dequeueReusableCellWithIdentifier("profilez") as! channelTableCell
            cell.channelName.text = genChannels[indexPath.row]
            cell.channelCount.text = genEvents[indexPath.row]
        }
        if indexPath.section == 2 {
            cell = tableView.dequeueReusableCellWithIdentifier("profiles") as! channelTableCell
            cell.channelName.text = channelNames[indexPath.row]
            
        }
      
        return cell
        
    }
    


    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
         var allTypes = userType + gentype + channelType
         var cell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        cell.contentView.backgroundColor = UIColor.redColor()
        if indexPath.section == 0 {
            switch userType[indexPath.row] {
            case "profile":
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            break
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
            
            self.performSegueWithIdentifier("channelSelect", sender: self)
         
           

        }
        if indexPath.section == 2 {
            self.performSegueWithIdentifier("channelSelect", sender: self)
           
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
            println()
            println()
            println(allInfo[row!])
              println(allInfo)
            println()
            println()
            if indexPath?.section == 1 {
                eventFeed.channelID = gentype[row!]
            }
            if indexPath?.section == 2 {
                eventFeed.channelID = channels[row!]
            }
            
            
            
        }
    }


}

