//
//  settingsView.swift
//  UinProto2
//
//  Created by Kareem Dasilva on 2/15/15.
//  Copyright (c) 2015 Kareem Dasilva. All rights reserved.
//

import UIKit

class settingsView: UIViewController {

    @IBOutlet var menuTrigger: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        var theMix = Mixpanel.sharedInstance()
        theMix.track("Settings Opened")
        theMix.flush()
        
        var user = PFUser.currentUser()
        if user["pushEnabled"] as!Bool == true {
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
        if self.revealViewController() != nil {
            menuTrigger.target = self.revealViewController()
            menuTrigger.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    @IBOutlet var notifySlider: UISwitch!
    @IBAction func notifySwitch(sender: AnyObject) {
        var theMix = Mixpanel.sharedInstance()
        theMix.track("Notifications Off/On (S)")
        theMix.flush()
        
        var user = PFUser.currentUser()
        if notifySlider.on == true {
            var subscriptionUsernames = [String]()
            var user = PFUser.currentUser()
            user["pushEnabled"] = true
            user.save()
            var query = PFQuery(className: "Subscription")
            query.whereKey("subscriberID", equalTo: PFUser.currentUser().objectId)
            query.findObjectsInBackgroundWithBlock({
        
                (objects:[AnyObject]!, queError:NSError!) -> Void in

                if queError == nil {
                    println(subscriptionUsernames)
                    for object in objects {
                        subscriptionUsernames.append(object["publisherID"] as!String)
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
            if channels != nil {
                install.removeObjectsInArray(channels, forKey: "channels")
                install.save()

            }
            var user = PFUser.currentUser()
            user["pushEnabled"] = false
            user.save()
        }
        
    }
    
    @IBAction func logout(sender: AnyObject) {
        var theMix = Mixpanel.sharedInstance()
        theMix.track("Logout (S)")
        theMix.flush()
        
       println("you pressed it")
        var install = PFInstallation.currentInstallation()
        var channels = install.channels
        if channels == nil {
            PFUser.logOut()
            self.performSegueWithIdentifier("logout", sender: self)
        } else {
            install.removeObjectsInArray(channels, forKey: "channels")
            install.save()
            PFUser.logOut()
            self.performSegueWithIdentifier("logout", sender: self)
        }
 

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


