//
//  AttendanceVC.swift
//  Uin
//
//  Created by Kareem Dasilva on 11/17/15.
//  Copyright © 2015 Kareem Dasilva. All rights reserved.
//

import UIKit

class AttendanceVC: UITableViewController {

    var eventID = (String)()
    struct attende {
        var name = (String)()
        var id = (String)()
        var status = (Bool)()
    }
    var attendanceInfo = [attende]()
    func getEventDetails(){
        let query = PFQuery(className: "UserLocation")
        query.whereKey("eventID", equalTo: eventID)
        query.findObjectsInBackgroundWithBlock({
            (objects:[PFObject]?, error:NSError?) -> Void in
            if error == nil {
                
                //gets all objects 
                for object in objects! {
                    var attend = (attende)()
                    //attend.id = object["userID"] as! String
                    attend.name = object["user"] as! String
                   // attend.status = object["status"] as! Bool
                    self.attendanceInfo.append(attend)
                    
                }
                self.tableView.reloadData()
            } else {
                print(error)
            }
        })
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getEventDetails()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return attendanceInfo.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCellWithIdentifier("poop", forIndexPath: indexPath) as! UITableViewCell
     

        // Configure the cell...
        cell.textLabel!.text = attendanceInfo[indexPath.row].name

        return cell
    }

}
class attendanceCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
}
