//
//  CreateEventTblVC.swift
//  Uin
//
//  Created by Kareem Dasilva on 11/23/15.
//  Copyright © 2015 Kareem Dasilva. All rights reserved.
//

import UIKit

class CreateEventTblVC: UITableViewController {
    var selectedIndexPath : NSIndexPath?
    
    struct Event {
        var title = (String)()
        var description = (String)()
        var isPublic = (Bool)()
        var user = (String)()
        var tag1 = ""
        var tag2 = ""
        var tag3 = ""
        var location = (PFGeoPoint)()
        var address = (String)()
        var start = (NSDate)()
        var end = (NSDate)()
    }
    var event = (Event)()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func createEvent(sender: AnyObject) {
        print(event)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 5
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 1 || section == 0 {
            return 2

        } else {
            return 1
        }
    }
    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
     
        if indexPath.section == 0 {
            if indexPath.row == 1 {
                //Description cell
                let cell2:CreateEventCellDescription = tableView.dequeueReusableCellWithIdentifier("description", forIndexPath: indexPath) as! CreateEventCellDescription
                return cell2
            }
            let cell:CreateEventCellTitle = tableView.dequeueReusableCellWithIdentifier("title", forIndexPath: indexPath) as! CreateEventCellTitle
            return cell
        } else if (indexPath.section == 1) {

            let cell2:CreateEventCellStart = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CreateEventCellStart
            return cell2
        }else if (indexPath.section == 2) {
            let cell:CreateEventLocation = tableView.dequeueReusableCellWithIdentifier("location", forIndexPath: indexPath) as! CreateEventLocation
            return cell
        }else if (indexPath.section == 3) {
            let cell:CreateEventCellIcon = tableView.dequeueReusableCellWithIdentifier("icon", forIndexPath: indexPath) as! CreateEventCellIcon
            return cell
        } else {
            let cell:CreateEventPrivacy = tableView.dequeueReusableCellWithIdentifier("public", forIndexPath: indexPath) as! CreateEventPrivacy
            return cell
        }


     
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let previousIndexPath = selectedIndexPath
        print("hey")
        if indexPath == selectedIndexPath {
            selectedIndexPath = nil
        } else {
            selectedIndexPath = indexPath
        }
        
        var indexPaths : Array<NSIndexPath> = []
        if let previous = previousIndexPath {
            indexPaths += [previous]
        }
        if let current = selectedIndexPath {
            indexPaths += [current]
        }
        if indexPaths.count > 0 {
            tableView.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        /*if indexPath.row == 1 || indexPath.row == 2 {
            (cell as! CreateEventCellStart).watchFrameChanges()
        }*/
        
    }
   
    
    
    override func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1  {
            (cell as! CreateEventCellStart).ignoreFrameChanges()
            
        }
    }

    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
       /*for cell in tableView.visibleCells as! [CreateEventCellStart] {
           cell.ignoreFrameChanges()
       }*/
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 1 {
            if indexPath == selectedIndexPath  {
                print("hey")
                return 200
            } else {
                print("efde")
                return 44
            }
        }
        if indexPath.section == 0 {
            if indexPath.row == 1 {
                return 100
            }
        }
      return 50
    }
    
}

