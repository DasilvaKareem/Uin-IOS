//
//  evetCalendar.swift
//  Uin
//
//  Created by Sir Lancelot on 6/23/15.
//  Copyright (c) 2015 Kareem Dasilva. All rights reserved.
//

import UIKit

class eventCalendar: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var calendarFeed: UITableView!
    var Cname = [String]() //Calendar names
    
    
    @IBAction func submitData(sender: AnyObject) {
    }
    
    func getCalendars(){
        //get calendars from parse and display them
        var query = PFQuery(className: "ChannelUser")
        query.whereKey("userID", equalTo: PFUser.currentUser().objectId)
        //query.whereKey("canPost", equalTo: true)
        query.findObjectsInBackgroundWithBlock({
            (objects:[AnyObject]!, error:NSError!) -> Void in
            if error == nil {
                for object in objects {
                    
                    self.Cname.append(object["channelName"] as! String)
                }
                self.calendarFeed.reloadData()
            } else {
                println("No calendars for you bud")
            }
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        getCalendars()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //DATA SOURCES FOR TABLE VIEW
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:calendarCell = tableView.dequeueReusableCellWithIdentifier("calendar") as! calendarCell
        cell.name.text = Cname[indexPath.row]
        
        return cell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Cname.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

class calendarCell: UITableViewCell {
    
    
    @IBOutlet weak var name: UILabel!
}
