//
//  postEvent.swift
//  UinProto2
//
//  Created by Kareem Dasilva on 1/26/15.
//  Copyright (c) 2015 Kareem Dasilva. All rights reserved.
//

import UIKit

class postEvent: UIViewController {
    
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet var startTime: UILabel!
    @IBOutlet var endTime: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var isFood: UIImageView!
    @IBOutlet weak var username: UIButton!
    @IBOutlet weak var isSite: UIImageView!
    @IBOutlet weak var isPaid: UIImageView!
    @IBAction func gotoProfile(sender: AnyObject) {
        
        self.performSegueWithIdentifier("gotoprofile", sender: self)
        
    }
    
    var users = String()
    var storeTitle = String()
    var storeLocation = String()
    var storeStartTime = String()
    var storeEndTime = String()
    var storeDate = String()
    var storeSum = String()
    var data = Int()
    var onsite = Bool()
    var food = Bool()
    var cost = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       username.setTitle(users, forState: UIControlState.Normal)
        
       location.text = storeLocation
        eventTitle.text = storeTitle
        startTime.text = storeStartTime
        endTime.text = storeEndTime
        date.text = storeDate
        putIcons()
  
    }
    
    func putIcons(){
        
        
        if  onsite == true {
            isSite.image = UIImage(named: "onCampus.png")
        }
        else{
            isSite.image = UIImage(named: "offCampus.png")
        }
     
        if food == true {
            isFood.image = UIImage(named: "yesFood.png")
        }
        else{
            isFood.image = UIImage(named: "noFood.png")
        }
        if cost == false {
            isPaid.image = UIImage(named: "yesFree.png")
        }
        else{
            isPaid.image = UIImage(named: "noFree.png")
       }
    }
    override func prepareForSegue(segue:UIStoryboardSegue, sender: AnyObject?){
 
        if segue.identifier == "gotoprofile" {
            var theotherprofile:userprofile = segue.destinationViewController as userprofile
            theotherprofile.theUser = users
      }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
   }
}
