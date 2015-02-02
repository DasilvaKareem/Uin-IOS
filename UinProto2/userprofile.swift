//
//  userprofile.swift
//  UinProto2
//
//  Created by Kareem Dasilva on 2/1/15.
//  Copyright (c) 2015 Kareem Dasilva. All rights reserved.
//

import UIKit

class userprofile: UIViewController {

    
    @IBOutlet weak var username: UILabel!
    
    var theUser = String()
    
    
    @IBOutlet weak var subbutton: UIButton!
    
    @IBAction func subscribe(sender: AnyObject) {
        
        
        var subscribe = PFObject(className: "subs")
        subscribe["member"] = false
        subscribe["follower"] = PFUser.currentUser().username
        subscribe["following"] = theUser
        subscribe.saveInBackgroundWithBlock{
            
            
            (success:Bool!,subError:NSError!) -> Void in
            
            
            if (subError == nil){
                
                
                println("Saved")
                
                
                
            }
            
            
            
            
            
        }
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        username.text = theUser
        if PFUser.currentUser().username == theUser {
            
            
            
            
            
        }
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
