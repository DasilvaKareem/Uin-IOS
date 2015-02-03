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
    
    var memberStatus = [Bool]()
    
    
    @IBOutlet weak var subbutton: UIButton!
    
    @IBAction func subscribe(sender: AnyObject) {
        
        var que = PFQuery(className: "subs")
        
        que.whereKey("follower", equalTo:PFUser.currentUser().username)
        que.whereKey("following", equalTo: theUser)
        que.getFirstObjectInBackgroundWithBlock{

        
            (object:PFObject!, error: NSError!) -> Void in
            
            if object == nil {
            
            var subscribe = PFObject(className: "subs")
            subscribe["member"] = false
            subscribe["follower"] = PFUser.currentUser().username
            subscribe["following"] = self.theUser
            subscribe.saveInBackgroundWithBlock{
                
                
                (success:Bool!,subError:NSError!) -> Void in
                
                
                if (subError == nil){
                    
                    
                    self.subbutton.setTitle("Unsubscribe", forState: UIControlState.Normal)
                    
                    
                    
                }
                
                
                
                }
                
                }
            
            else {
                
                
                
                var unsub = PFQuery(className: "subs")
                
                unsub.whereKey("follower", equalTo:PFUser.currentUser().username)
                unsub.whereKey("following", equalTo: self.theUser)
                unsub.getFirstObjectInBackgroundWithBlock{
                    
                    (object:PFObject!, error: NSError!) -> Void in
                    
                    
                    if object != nil{
                        
                        object["member"] = false
                        
                        println(object["member"])
                        
                         self.subbutton.setTitle("Subscribe", forState: UIControlState.Normal)
                        
                    }
                    
                    else {
                        
                        println("fail")
                        
                    }
                    
                        
              
                
                
                
            }
        }
        
        }
    }
    
        
    
    
    func ChangeSub(){
        
        var que = PFQuery(className: "subs")
        
        que.whereKey("follower", equalTo:PFUser.currentUser().username)
        que.whereKey("following", equalTo: theUser)
        que.getFirstObjectInBackgroundWithBlock{
            
            (object:PFObject!, error: NSError!) -> Void in
            
            
            if object == nil{
                
               
                
            }
            
            else {
                
               self.subbutton.setTitle("Unsubscribe", forState: UIControlState.Normal)
                
            }
            
            
        }


    }



    
    override func viewDidLoad() {
        super.viewDidLoad()
        ChangeSub()
        username.text = theUser
        if PFUser.currentUser().username ==  theUser  {
            
            username.text = "You"
            subbutton.hidden = true
            
            
            
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
