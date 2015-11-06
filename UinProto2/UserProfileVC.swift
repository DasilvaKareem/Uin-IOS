//
//  UserProfileVC.swift
//  Uin
//
//  Created by Kareem Dasilva on 11/5/15.
//  Copyright © 2015 Kareem Dasilva. All rights reserved.
//

import UIKit

class UserProfileVC: UIViewController {
    
    

    @IBOutlet weak var follow: UIButton!
    let publisherID = (String)()
    var userFollowing = (PFObject)()
    var publisherName = (String)()
    var followAction = (Bool)()
    func getUserProfile(){
        
        
    }
    func checkFollowingStatus(){
        let query = PFQuery(className: "Subscription")
        query.whereKey("publisherID", equalTo: publisherID)
        query.whereKey("SubscriberID", equalTo: PFUser.currentUser()!.objectId!)
        query.getFirstObjectInBackgroundWithBlock({
            (object:PFObject?, error:NSError?) -> Void in
            if error == nil {
                print("user is following")
                self.userFollowing =  object!
                self.followAction = true
                self.follow.setTitle("Followed", forState: UIControlState.Normal)
                
            } else {
                print("user is not subscribed")
                self.followAction = false
                self.follow.setTitle("Follow", forState: UIControlState.Normal)
            }
        })
        
    }
    func followUser(action:Bool){
        let save = PFObject(className: "Subscription")
        if action == true {
            save["publisher"] = publisherName
            save["subscriber"] = PFUser.currentUser()?.username
            save["publisherID"] = publisherID
            save["subscriberID"] = PFUser.currentUser()!.objectId!
            save.saveInBackground()
            self.follow.setTitle("Followed", forState: UIControlState.Normal)
        } else {
            userFollowing.deleteInBackground()
            self.follow.setTitle("Following", forState: UIControlState.Normal)

        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        checkFollowingStatus()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
