//
//  LoadingView.swift
//  Uin
//
//  Created by Kareem Dasilva on 3/16/15.
//  Copyright (c) 2015 Kareem Dasilva. All rights reserved.
//

import UIKit

class LoadingView: UIViewController {

    @IBOutlet var spinner: UIActivityIndicatorView!
    var tried = false
    override func viewDidLoad() {
        super.viewDidLoad()
      
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(animated: Bool) {
   
        
        spinner.startAnimating()
        if PFUser.currentUser() != nil {
               PFUser.logOut()
            var userTimeCheck = PFUser.currentUser()
            if userTimeCheck["tempAccounts"] as! Bool == true {
                PFUser.logOut()
                self.performSegueWithIdentifier("createAccount", sender: self)
            }
            userTimeCheck["notificationsTimestamp"] = NSDate()
            userTimeCheck["subscriptionsTimestamp"] = NSDate()
            userTimeCheck["localEventsTimestamp"] = NSDate()
            userTimeCheck.saveInBackgroundWithBlock({
                (success:Bool, error:NSError!) -> Void in
                if error == nil {
                    println("The stamp was updated")
                } else {
                    println(error.debugDescription)
                }
            })
            
            self.performSegueWithIdentifier("login", sender: self)
        } else {
            if self.tried == false {
                let page1:OnboardingContentViewController = OnboardingContentViewController(title: "Welcome to Uin!", body: "Uin lets you explore the world by helping you distribute, discover, or schedule any kind of event.", image: UIImage(named: "uinColorMed"), buttonText: "", action: {
                    
                })
                let page2:OnboardingContentViewController = OnboardingContentViewController(title: "The local events calendar shows everything happening in your community.", body: "If you want to add an event to your calendar and let the organizer know you're going, tap the orange '+' button.", image: UIImage(named: "uinColorMed"), buttonText: "", action: {
                    
                })
                let page3:OnboardingContentViewController = OnboardingContentViewController(title: "Uin can be used for any kind of event!", body: "Imagine everyone always being on the same page for social parties, business meetings, intramural sports, or anything that you do with people.", image: UIImage(named: "uinColorMed"), buttonText: "", action: {
                    
                })
                //THIS ONE HAS BUTTON ON IT
                //CHANGE TEXT BY BUTTON TEXT
                let page4:OnboardingContentViewController = OnboardingContentViewController(title: "With Uin, no one can ever say 'I didn't know' again.", body: "Go ahead: create an event, invite some friends, keep everyone up-to-date, and have an incredible time. Life is better with each other, so let us help you get them all together.", image: UIImage(named: "uinColorMed"), buttonText: "So are Uin?", action: {
                    self.tried = true
                    self.dismissViewControllerAnimated(true, completion: nil)
                     self.performSegueWithIdentifier("createAccount", sender: self)
                })
                let allPages:OnboardingViewController = OnboardingViewController(backgroundImage: UIImage(named: "memboundBackground"), contents: [page1])
                
                allPages.underIconPadding = 40
                allPages.underTitlePadding = 20
                allPages.bottomPadding = 35
                allPages.titleFontSize = 24
                allPages.bodyFontSize = 18
                allPages.buttonFontSize = 20
                
                // skip button
                allPages.skipButton.enabled = true
                allPages.allowSkipping = true
                allPages.skipHandler = {
                    self.tried = true
                   self.dismissViewControllerAnimated(true, completion: nil)
                }
                self.presentViewController(allPages, animated: true, completion: nil)
                

            } else {
                self.performSegueWithIdentifier("createAccount", sender: self)
            }
        }

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
