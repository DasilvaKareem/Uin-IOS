//
//  subscriptions.swift
//  UinProto2
//
//  Created by Kareem Dasilva on 2/1/15.
//  Copyright (c) 2015 Kareem Dasilva. All rights reserved.
//

import UIKit

class subscriptions: UITableViewController {
    
    var folusernames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navBarBackground.png"), forBarMetrics: UIBarMetrics.Default)

  self.navigationController?.navigationBar.backIndicatorImage = nil
        // Changes text color on navbar
        var nav = self.navigationController?.navigationBar
        nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()];
        var followque = PFQuery(className: "Subcription")
        followque.whereKey("subcriber", equalTo: PFUser.currentUser().objectId)
        followque.orderByAscending("createdAt")
        followque.findObjectsInBackgroundWithBlock{
            
            (objects:[AnyObject]!, folError:NSError!) -> Void in
            
            
            if folError == nil {
                
                
                for object in objects{
                    
                    self.folusernames.append(object["publisher"] as String)
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
        
         let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell4")
        
        cell.textLabel?.text = folusernames[indexPath.row]
        
        return cell
        
    }
    
    
    
}
