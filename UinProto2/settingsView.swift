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
        
        if notifySlider.on == true {
              var subscriptionUsernames = [String]()
            var user = PFUser.currentUser()
            user["push"] = true
            user.save()
            var query = PFQuery(className: "Subs")
            query.whereKey("follower", equalTo: PFUser.currentUser().username)
            query.findObjectsInBackgroundWithBlock({
                
                (objects:[AnyObject]!, queError:NSError!) -> Void in
                
                if queError == nil {
                    println(subscriptionUsernames)
                    for object in objects {
                        
                        subscriptionUsernames.append(object["userId"] as String)
                        
                    }
                    var user = PFUser.currentUser()

                        var currentInstallation = PFInstallation.currentInstallation()
                        currentInstallation.setValue(subscriptionUsernames, forKey: "channels")
                        currentInstallation.save()
                    
                    
                }
                
            })
        }
        else {
            
            var install = PFInstallation.currentInstallation()
            var channels = install.channels
            install.removeObjectsInArray(channels, forKey: "channels")
            install.save()
            var user = PFUser.currentUser()
            user["push"] = false
            user.save()

        }
        
    }
    
    
    @IBAction func sudoObject(sender: AnyObject) {
        
        var i = 20
        
        for i ; i<70000 ; i++ {
            
            var user = PFUser()
            
            user.username = "test\(i)"
            
            user.password = "test"
            
            user["push"] = true
            
            user["first"] = true
            
            user.email = "test@ttest\(i).com"
            
            user.signUpInBackgroundWithBlock{
                (succeeded: Bool!, registerError: NSError!) -> Void in
                
                if registerError == nil {
                
            
                    
                }
                else {
                    println(registerError)
                
            }
            
            
        
            
            
        }
            
            println("made account")
            var subscribe = PFObject(className: "Subs")
            subscribe["member"] = false
            subscribe["follower"] = "test\(i)"
            subscribe["following"] = "coletherobot"
            subscribe.save()
        
        
    }
    
    
    
    
    }

    


    @IBAction func logout(sender: AnyObject) {
        
       println("you pressed it")
        var install = PFInstallation.currentInstallation()
        var channels = install.channels
        install.removeObjectsInArray(channels, forKey: "channels")
        install.save()
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


