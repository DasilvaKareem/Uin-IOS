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
                let page1:OnboardingContentViewController = OnboardingContentViewController(title: "Welcome Tiger!", body: "Uin has partnered with MEMbound to give you the best experience possible during your time at New Student Orientation. Enjoy your stay, and don't forget to check the schedule!", image: UIImage(named: "tiger"), buttonText: "", action: {
                    
                })
                let page2:OnboardingContentViewController = OnboardingContentViewController(title: "This is Memphis", body: "Once your session is over, hold on to Uin! When the Fall semester starts there will be all kinds of events here for you and your friends to check out!", image: UIImage(named: "whiteUin"), buttonText: "", action: {
                    
                })
                let page3:OnboardingContentViewController = OnboardingContentViewController(title: "This is Memphis", body: "Once your session is over, hold on to Uin! When the Fall semester starts there will be all kinds of events here for you and your friends to check out!", image: UIImage(named: "whiteUin"), buttonText: "", action: {
                    
                })
                //THIS ONE HAS BUTTON ON IT
                //CHANGE TEXT BY BUTTON TEXT
                let page4:OnboardingContentViewController = OnboardingContentViewController(title: "This is Memphis", body: "Once your session is over, hold on to Uin! When the Fall semester starts there will be all kinds of events here for you and your friends to check out!", image: UIImage(named: "whiteUin"), buttonText: "vcb", action: {
                     self.performSegueWithIdentifier("createAccount", sender: self)
                })
                let allPages:OnboardingViewController = OnboardingViewController(backgroundImage: UIImage(named: "memboundBackground"), contents: [page1,page2, page3,page4])
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
