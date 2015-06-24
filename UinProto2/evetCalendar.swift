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
    
    
    @IBAction func submitData(sender: AnyObject) {
    }
    
    func getCalendars(){
        //get calendars from parse and display them
        
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
        
        
        return cell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
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
    
    
}
