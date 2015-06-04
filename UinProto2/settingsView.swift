//
//  settingsView.swift
//  UinProto2
//
//  Created by Kareem Dasilva on 2/15/15.
//  Copyright (c) 2015 Kareem Dasilva. All rights reserved.
//

import UIKit

class settingsView: UIViewController {
    
    @IBOutlet weak var emailBtn: UIButton!
    @IBOutlet var menuTrigger: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        var theMix = Mixpanel.sharedInstance()
        theMix.track("Settings Opened")
        theMix.flush()
        
        var user = PFUser.currentUser()
        //Checks if the user has verified the email
        if user["emailVerified"] != nil {
            if user["emailVerified"] as! Bool == true {
                 self.emailBtn.removeFromSuperview() //disables if user alreadies has email verifications
            } else {
                emailBtn.enabled = true
            }
        } else {
            //enable if the user has a "nil" value for emailverifed
            emailBtn.enabled = true
        }

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
                self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
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
    //Forces an email verification
    @IBAction func resendEmail(sender: AnyObject) {
        let email = PFUser.currentUser().email
        PFUser.currentUser().setObject("test13@areuin.co", forKey: "email")
        PFUser.currentUser().saveInBackgroundWithBlock({
            (success:Bool, error:NSError!) -> Void in
            
            if error == nil {
                println("The email was saved")
                
                PFUser.currentUser().setObject(email, forKey: "email")
                PFUser.currentUser().saveInBackgroundWithBlock({
                    (success:Bool, error:NSError!) -> Void in
                    
                    if error == nil {
                        println("The email was saved")
                    } else {
                        println("the email was not saved")
                    }
                })

            } else {
               
            }
        })
    }
    //LAUNCHES THE TUTORIAL
   
    @IBAction func tutorialLauncher(sender: AnyObject) {
        let page1:OnboardingContentViewController = OnboardingContentViewController(title: "Welcome to Uin!", body: "Uin lets you explore the world by helping you distribute, discover, or schedule any kind of event.", image: UIImage(named: "uinColorMed"), buttonText: "", action: {
            
        })
        let page2:OnboardingContentViewController = OnboardingContentViewController(title: "The local events calendar shows everything happening in your community.", body: "If you want to add an event to your calendar and let the organizer know you're going, tap the orange '+' button.", image: UIImage(named: "uinColorMed"), buttonText: "", action: {
            
        })
        let page3:OnboardingContentViewController = OnboardingContentViewController(title: "Uin can be used for any kind of event!", body: "Imagine everyone always being on the same page for social parties, business meetings, intramural sports, or anything that you do with people.", image: UIImage(named: "uinColorMed"), buttonText: "", action: {
            
        })
        //THIS ONE HAS BUTTON ON IT
        //CHANGE TEXT BY BUTTON TEXT
        let page4:OnboardingContentViewController = OnboardingContentViewController(title: "With Uin, no one can ever say 'I didn't know' again.", body: "Go ahead: create an event, invite some friends, keep everyone up-to-date, and have an incredible time. Life is better with each other, so let us help you get them all together.", image: UIImage(named: "uinColorMed"), buttonText: "So are Uin?", action: {
        
            self.dismissViewControllerAnimated(true, completion: nil)
         
        })
        let allPages:OnboardingViewController = OnboardingViewController(backgroundImage: UIImage(named: "memboundBackground"), contents: [page1,page2,page3,page4])
        
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
          
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        self.presentViewController(allPages, animated: true, completion: nil)
    }

    //Changes the type
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "email" {
            var accountInfoChangeView:ChangeAccountInfo = segue.destinationViewController as! ChangeAccountInfo
            accountInfoChangeView.accountChangeType = "email"
        }
        if segue.identifier == "password" {
            var accountInfoChangeView:ChangeAccountInfo = segue.destinationViewController as! ChangeAccountInfo
            accountInfoChangeView.accountChangeType = "password"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
class ChangeAccountInfo: UIViewController {
    
    @IBOutlet weak var newTokenField: UITextField!
    @IBOutlet weak var newToken: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmTextField: UITextField!
    @IBOutlet weak var changeToken: UILabel!
    @IBOutlet weak var confirmToken: UILabel!
    @IBOutlet weak var sendTokenBtn: UIButton!
    @IBOutlet weak var resultToken: UILabel!
    
    
    var accountChangeType = (String)() //What type of account changing it is
    
    @IBAction func sendToken(sender: AnyObject) {
        //Sends an password reset fourm if email are both correct
        if accountChangeType == "password" {
 
                //Saves newTokenField to the current users password
                PFUser.requestPasswordResetForEmailInBackground(PFUser.currentUser().email, block: {
                    (success:Bool, error:NSError!) -> Void in
                    if error == nil {
                        self.resultToken.text = "Password Reset Sent"
                        self.sendTokenBtn.setTitle("Resend", forState: UIControlState.Normal)
                    } else {
                        self.resultToken.text = "Invalid Email address"
                        println(error.debugDescription)
                    }
                })
         

        }
        //Changes email and also resends the email verification if the user is not verified
        if accountChangeType == "email" {
            if confirmTextField.text == PFUser.currentUser().email && passwordTextField.text == PFUser.currentUser().email {
                //Saves newTokenField to the current users password
                PFUser.currentUser().email = newTokenField.text
                PFUser.currentUser().saveInBackgroundWithBlock({
                    (sucess:Bool, error:NSError!) -> Void in
                    if error == nil {
                        self.resultToken.text = "Email Changed"
                        self.resultToken.textColor = UIColor.greenColor()
                    } else {
                        self.resultToken.text = "Oops! Please try again."
                        self.resultToken.textColor = UIColor.redColor()
                    }
                })
            }    else {
                self.resultToken.text = "Invalid Email"
                self.resultToken.textColor = UIColor.redColor()
            }
            
           
        }
    }
    //Changes text, placeholder, and UI depending on what type of change the view provides
    func setupChangeInfo(){
        if accountChangeType == "email" {
            self.navigationItem.title = "Change Email"
            newTokenField.placeholder = "enter new email address"
            changeToken.text = "Enter Current Email"
            passwordTextField.placeholder = "enter current email address"
            confirmTextField.placeholder = "confirm your email address"
            resultToken.text = ""
            confirmToken.text = "Confirm Email"
            sendTokenBtn.setTitle("Change Email", forState: UIControlState.Normal)
            newToken.text = "New Email Address"
        }
        if accountChangeType == "password" {
            self.resultToken.text = ""
            self.confirmToken.text = "email support@areuin.co for help"
            self.resultToken.text = ""
            changeToken.text = "Reset password via email."
            newToken.text = ""
            newTokenField.removeFromSuperview()
            passwordTextField.removeFromSuperview()
            confirmTextField.removeFromSuperview()
             self.navigationItem.title = "Password Reset"
            resultToken.text = ""
            sendTokenBtn.setTitle("Request Password Reset", forState: UIControlState.Normal)
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        
    }
    
    
    func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y = -55
    }
    func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0.0
    }
    
    override func viewWillAppear(animated: Bool) {
        setupChangeInfo()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


