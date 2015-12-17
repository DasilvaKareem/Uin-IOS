//
//  CreateEventTblVC.swift
//  Uin
//
//  Created by Kareem Dasilva on 11/23/15.
//  Copyright © 2015 Kareem Dasilva. All rights reserved.
//

import UIKit

class CreateEventTblVC: UITableViewController {
var poop = ["example"]
    var selectedIndexPath : NSIndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }
    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
     
   
        if indexPath.section == 1 {
            let cell2:CreateEventCellStart = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CreateEventCellStart
            
            return cell2
        } else {
               let cell:CreateEventCellTitle = tableView.dequeueReusableCellWithIdentifier("title", forIndexPath: indexPath) as! CreateEventCellTitle
               return cell
        }


     
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let previousIndexPath = selectedIndexPath
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
      return 50
    }
    
}

