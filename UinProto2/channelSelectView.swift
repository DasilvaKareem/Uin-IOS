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
    var genChannels = [String]()
    var gentype = [String]()
    var genEvents = [String]()
    
    //Sections
    //User Section
    var userType = [String]()
    var usernameInfo = [String]()
    var usernameSectionTitle = [String]()
    func getUserInfo(){
        
        
        
        
        //Removes all the previous information
        self.userType.removeAll(keepCapacity: true)
        self.usernameInfo.removeAll(keepCapacity: true)
        self.usernameSectionTitle.removeAll(keepCapacity: true)
        
        //Setups first item in username section title
        self.usernameInfo.append("0")
        self.usernameSectionTitle.append("following")
        self.userType.append("following")
        
        //Setups second items in username section title
        self.usernameInfo.append("0")
        self.usernameSectionTitle.append("subscriptions")
        self.userType.append("Subscriptions")
        
        
        //Setups thrid item in username section
        self.usernameInfo.append("0")
        self.usernameSectionTitle.append("notifications")
        self.userType.append("Notifications")
        
    }
    
    
    func setupGenCounters() {
        //Finds out information and count number of your general calendars and sends things through blocks
        
        self.genEvents.removeAll(keepCapacity: true)
        self.gentype.removeAll(keepCapacity: true)
        self.genChannels.removeAll(keepCapacity: true)
        
        //Setups first part of gen counters
        self.genEvents.append("0")
        self.gentype.append("local")
        self.genChannels.append("local")
        //Ends setup
        
        //Setups 2nd part og gencounters
        self.genEvents.append("0 new")
        self.gentype.append("subbedEvents")
        self.genChannels.append("following")
        //Ends setup
        
        //third part of gen counters
        self.genEvents.append(" 0 upcoming")
        self.gentype.append("schedule")
        self.genChannels.append("i'm in")
        
        //fourth part of gen counters
        self.genEvents.append("0")
        self.gentype.append("myevents")
        self.genChannels.append("My Events")
        //End setup
        self.getChannels()
    }
    
    
    
    
    func setupAllChannels() {
        
        
        
        self.getUserInfo()
        self.setupGenCounters()
        self.getChannels()
        
        self.tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(animated: Bool) {
        
        
    }
    override func viewDidAppear(animated: Bool) {
        self.setupAllChannels()
        
    }
    override func viewWillDisappear(animated: Bool) {
        
    }
    override func viewDidDisappear(animated: Bool) {
        
        
    }
    
    func getChannels(){
        //This is where you setup all your channels for the user :its blank becasue idk the directions
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
        return 4
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        var totalSections = usernameSectionTitle +  genChannels + channelNames
        if section == 0 {
            return 0
        }
        if section ==  1 {
            return usernameSectionTitle.count
        }
        if section ==  2 {
            return genChannels.count
        }
        if section ==  3 {
            
            return channelNames.count
        }
        return totalSections.count
    }
    
    
    
    
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell:channelSectionCell = tableView.dequeueReusableCellWithIdentifier("sectionHeader") as! channelSectionCell
        
        if section == 0 {
            let cell:channelHeaderCell = tableView.dequeueReusableCellWithIdentifier("header") as! channelHeaderCell
            cell.headerLabel.text = PFUser.currentUser()!.username
            
            return cell
        }
        if section == 1 {
            
            cell.sectionHeader.text = "Profile"
            cell.channelSeparator.image = UIImage(named: "sidebarLine.png")
            
            
        }
        if section == 2 {
            cell.sectionHeader.text = "Calendars"
            cell.channelSeparator.image = UIImage(named: "sidebarLine.png")
            
        }
        if section == 3 {
            cell.sectionHeader.text = ""
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
        //Section 1
        
        if indexPath.section == 1 {
            if usernameInfo[indexPath.row].rangeOfString("0") != nil {
                cell.channelCount.text = ""
            } else {
                cell.channelCount.text = usernameInfo[indexPath.row]
            }
            
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
        }
        
        //Sections 2
        if indexPath.section == 2 {
            
            cell = tableView.dequeueReusableCellWithIdentifier("profilez") as! channelTableCell
            
            
            if self.memBounded == true {
                cell.channelCount.text = "Locked"
                cell.channelName.text = genChannels[indexPath.row]
            } else {
                if genEvents[indexPath.row].rangeOfString("0") != nil {
                    cell.channelCount.text = ""
                    cell.channelName.text = genChannels[indexPath.row]
                } else {
                    cell.channelName.text = genChannels[indexPath.row]
                    cell.channelCount.text = genEvents[indexPath.row]
                }
                
            }
            
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
            if self.currentIndexPath.length == 0  {
              
                if indexPath.row == 0 {
                    cell.contentView.backgroundColor = UIColor(red: 65.0/255.0, green: 145.0/255.0, blue: 198.0/255.0, alpha: 1)
                    cell.channelName.textColor = UIColor.whiteColor()
                    cell.channelCount.textColor = UIColor.whiteColor()
                }
            }
        }
        
        //Section 3
        if indexPath.section == 3 {
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
        let cell:channelTableCell = tableView.cellForRowAtIndexPath(indexPath) as! channelTableCell
        cell.contentView.backgroundColor = UIColor(red: 65.0/255.0, green: 145.0/255.0, blue: 198.0/255.0, alpha: 1)
        cell.channelCount.textColor = UIColor.whiteColor()
        cell.channelName.textColor = UIColor.whiteColor()
        self.currentIndexPath = indexPath
    
        
               if indexPath.section == 1 {
                //changes background cell color to orange
                
                    cell.contentView.backgroundColor = UIColor(red: 245.0/255.0, green: 166.0/255.0, blue: 35.0/255.0, alpha: 1)
                    cell.channelName.textColor = UIColor.whiteColor()
                    cell.channelCount.textColor = UIColor.whiteColor()
              
                    switch userType[indexPath.row] {
                        
                    case "Subscriptions":
                        self.performSegueWithIdentifier("Subscriptions", sender: self)
                        break
                    case "Subscribers":
                        self.performSegueWithIdentifier("Subscribers", sender: self)
                        break
                    case "Notifications":
                        self.performSegueWithIdentifier("Notifications", sender: self)
                        break
                    
                    case "My Events":
                        self.performSegueWithIdentifier("channelSelect", sender: self)
                    default:
                        break
                    }
                
     
        }
     
            if indexPath.section == 2 {
               
                if self.memBounded == true {
                    print("You are membounded", terminator: "")
                        //Re checks if your authorization is still on
                   
                    if self.memBounded == true {
                        var alert = UIAlertController(title: "You're still in MEMbound", message: "Check back when your session is over. We'll be waiting on you!", preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                
                } else {
                    self.performSegueWithIdentifier("channelSelect", sender: self)
                }
            }
        
      
        if indexPath.section == 3 {
  
                  self.performSegueWithIdentifier("channelSelect", sender: self)
          
          
            
        }
        
      
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
   
        if segue.identifier == "channelSelect" {
            
            let indexPath = tableView.indexPathForSelectedRow
            let nav = segue.destinationViewController as! UINavigationController
            let eventFeed:eventFeedViewController = nav.topViewController as! eventFeedViewController
            let row = indexPath?.row
      
            if indexPath?.section == 2 {
                print(row!)
                eventFeed.channelID = gentype[row!]
            }
            if indexPath?.section == 3 {
                    print(row!)
                eventFeed.channelID = channels[row!]
            }
            
            
            
        }
    }


}

