//
//  searchView.swift
//  Uin
//
//  Created by Kareem Dasilva on 3/26/15.
//  Copyright (c) 2015 Kareem Dasilva. All rights reserved.
//

import UIKit

class searchView: UITableViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet var searchTableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    var searchActive:Bool = false
    var type:[String] = []
    var data:[String] = []
    var objectIDs:[String] = []
    var filteredData:[String] = []
    var filteredType:[String] = []
    var filteredObjectIDs:[String] = []
    var userLocation = (PFGeoPoint)()
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        getSearchItems()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }
    
    func getSearchItems() {
        
       
        var eventQuery = PFQuery(className: "Event")
        
        PFGeoPoint.geoPointForCurrentLocationInBackground({
        (geoPoint: PFGeoPoint!, error: NSError!) -> Void in
            self.userLocation = geoPoint
        })
        eventQuery.whereKey("end", greaterThanOrEqualTo: NSDate())
        eventQuery.whereKey("locationGeopoint", nearGeoPoint: userLocation, withinMiles: 3.0)
        eventQuery.findObjectsInBackgroundWithBlock({
            (results: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                for object in results{
                    
                    var note = object["title"] as String
                    
                    self.data.append("\(note) (Event)")
                
                    
                    
                }
                var userQuery = PFUser.query()
                userQuery.whereKey("tempAccounts", equalTo: false)
                userQuery.findObjectsInBackgroundWithBlock({
                    (results: [AnyObject]!, error: NSError!) -> Void in
                    if error == nil {
                        for object in results{
                            
                            var note2 = object["username"] as String
                            self.data.append("\(note2) (Username)")
                            
                            
                        }
                    }
                })
            }
        
        })
    
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Mark: Search functions
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        
        filteredData = data.filter({ (text) -> Bool in
            let tmp: NSString = text
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            println()
            return range.location != NSNotFound
        })
       
        if(filteredData.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.searchTableView.reloadData()

    }


    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if(searchActive) {
            return filteredData.count
        }
        return 0;

    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "searchitems")

       
        if(searchActive){
            cell.textLabel?.text = filteredData[indexPath.row]
        } else {
            cell.textLabel?.text = data[indexPath.row];
        }
        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
