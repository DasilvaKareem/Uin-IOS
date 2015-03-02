//
//  settingsView.swift
//  UinProto2
//
//  Created by Kareem Dasilva on 2/15/15.
//  Copyright (c) 2015 Kareem Dasilva. All rights reserved.
//

import UIKit

class settingsView: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        var user = PFUser.currentUser()
        if user["push"] as Bool == true {
            
            notifySlider.setOn(true, animated: true)
            
        }   else {
            
             notifySlider.setOn(false, animated: true)
            
        }

        
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navBarBackground.png"), forBarMetrics: UIBarMetrics.Default)
        
        // Changes text color on navbar
        var nav = self.navigationController?.navigationBar
        nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()];
self.tabBarController?.tabBar.hidden = true
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet var notifySlider: UISwitch!
    
    
    @IBAction func notifySwitch(sender: AnyObject) {
        
        var user = PFUser.currentUser()
        
        if user["push"] as Bool == true {
            
            user["push"] = false
            
        }   else {
            
            user["push"] = true
            
        }
        
        
    }
    
    func notifyQuery() {
        
        var query = PFUser.query()
        
        query.getObjectInBackgroundWithId(PFUser.currentUser().objectId, block: {
            
            (objects: PFObject!, error: NSError!) -> Void in
            
            if error == nil {
                
                if objects["push"] as Bool == false {
                    
                    
                  
                }
                    
                else {
                    
              
                    
                }
                
            }
            
            
        })
        
    }

    
    func notifyChange() {
        
        var query = PFUser.query()
 
        query.getObjectInBackgroundWithId(PFUser.currentUser().objectId, block: {
            
            (objects: PFObject!, error: NSError!) -> Void in
            
            if error == nil {
                
                if objects["push"] as Bool == false {
                    
                    objects["push"] = true
                    objects.save()
                }
                
                else {
                    
                    objects["push"] = false
                    objects.save()
                    
                }
                
            }
            
            
        })
        
    }

    @IBAction func logout(sender: AnyObject) {
        
       println("you pressed it")
   
        PFUser.logOut()
         self.performSegueWithIdentifier("logout", sender: self)

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


