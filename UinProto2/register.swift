//
//  register.swift
//  UinProto2
//
//  Created by Kareem Dasilva on 12/24/14.
//  Copyright (c) 2014 Kareem Dasilva. All rights reserved.
//

import UIKit

class register: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    var userPlace = ""
    var emailPlace = ""
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }
    
    
    
    func displayAlert(title:String, error:String) {
        
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var theMix = Mixpanel.sharedInstance()
        theMix.track("Register Opened")
        theMix.flush()
        
        if userPlace != "" {
            username.attributedText = NSAttributedString(string:userPlace,
                attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        }
        else {
            username.attributedPlaceholder = NSAttributedString(string:"USERNAME",
                attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
            
        }
        
        if emailPlace != "" {
           email.attributedText = NSAttributedString(string:emailPlace,
                attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
            
        }
        else {
            
            email.attributedPlaceholder = NSAttributedString(string:"EMAIL",
                attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);

        password.attributedPlaceholder = NSAttributedString(string:"PASSWORD",
            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        
     
        
        cpassword.attributedPlaceholder = NSAttributedString(string:"CONFIRM PASSWORD",
            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])


        // Do any additional setup after loading the view.
    }
    
    func keyboardWillShow(sender: NSNotification) {
        
        self.view.frame.origin.y = -150
    }
    func keyboardWillHide(sender: NSNotification) {
        
        
        self.view.frame.origin.y = 0.0
    }
    

    

    @IBOutlet weak var cpassword: UITextField!
    @IBAction func register(sender: AnyObject) {
        var theMix = Mixpanel.sharedInstance()
        theMix.track("Tap Create Account (R)")
        theMix.flush()
        
        var characterSet:NSCharacterSet = NSCharacterSet(charactersInString: "!@#$%^&*()+")
        
        var error = ""
        
        
        if username.text.rangeOfCharacterFromSet(characterSet) != nil {
            error = "You either entered an illegal charcter"
        }


        
        if username.text == "" || password.text == "" {
            
            error = "You did not enter a username or password"
            
        }
        
        if password.text != cpassword.text {
            
            error = "Passwords do not match"
            
        }
        
        if error != ""{
            
            displayAlert("Oops!", error: error)
        }
            
        else {
    
            if PFUser.currentUser() == nil {
             
                var user = PFUser()
               
                user.username = username.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                user["display"] = username.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                user.password = password.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                user.email = email.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                user["pushEnabled"] = true
                user["firstRemoveFromCalendar"] = true
                user["tempAccounts"] = false
                user["notificationsTimestamp"] = NSDate()
                user["subscriptionsTimestamp"] = NSDate()
                user["localEventsTimestamp"] = NSDate()
                user.signUpInBackgroundWithBlock {
                    (succeeded: Bool, registerError: NSError!) -> Void in
                    
                    if registerError == nil {
                        var defaultChannel = PFObject(className: "ChannelUser")
                        defaultChannel["expiration"] = NSDate().dateByAddingTimeInterval(250000)
                        defaultChannel["admin"] = false
                        defaultChannel["canPost"] = false
                        defaultChannel["validationCode"] = "nil"
                        defaultChannel["channelID"] = "wEwRowC6io"
                        defaultChannel["channelName"] = "MEMbound Parent"
                        defaultChannel["authorized"] = false
                        defaultChannel["userID"] = PFUser.currentUser().objectId
                        defaultChannel.saveInBackgroundWithBlock({
                            (success:Bool, error:NSError!) -> Void in
                            if error == nil {
                                println("User has been entered into the channel")
                            } else {
                                println("User has not been entered into the channel")
                            }
                        })
                        var defaultChannel2 = PFObject(className: "ChannelUser")
                        defaultChannel2["expiration"] = NSDate().dateByAddingTimeInterval(25000)
                        defaultChannel2["admin"] = false
                        defaultChannel2["canPost"] = false
                        defaultChannel2["validationCode"] = "nil"
                        defaultChannel2["channelID"] = "LAUfZJ3KKc"
                        defaultChannel2["channelName"] = "MEMbound Student"
                        defaultChannel2["authorized"] = false
                        defaultChannel2["userID"] = PFUser.currentUser().objectId
                        defaultChannel2.saveInBackgroundWithBlock({
                            (success:Bool, error:NSError!) -> Void in
                            if error == nil {
                                println("User has been entered into the channel")
                            } else {
                                println("User has not been entered into the channel")
                            }
                        })
                        var theMix = Mixpanel.sharedInstance()
                        theMix.track("Registered with Uin -register-")
                        var currentInstallation = PFInstallation.currentInstallation()
                        currentInstallation["user"] = PFUser.currentUser().username
                        currentInstallation["userId"] = PFUser.currentUser().objectId
                        currentInstallation.saveInBackgroundWithBlock({
                            
                            (success:Bool, saveerror: NSError!) -> Void in
                            
                            if saveerror == nil {
                                println("it worked")
                            }
                                
                            else {
                                println("It didnt work")
                            }
                        })
                        self.performSegueWithIdentifier("registerS", sender: self)
                    }
                    else {
                        println(registerError.code)
                        switch registerError.code {
                            
                        case 125:
                            self.displayAlert("Oops!", error: "wrong Email")
                            
                        case 100:
                            self.displayAlert("Oops!", error: "No internet")
                            
                        case 203:
                            self.displayAlert("Oops", error: "Email Taken")
                            
                        case 202:
                            self.displayAlert("Oops!", error: "Username taken")
                            
                        default:
                            self.displayAlert("Oops!", error: "Error (")
                        }
                    }
                }
                
            }
            else {
                
                var user = PFUser.currentUser()
                user.username = username.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                user["display"] = username.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                user.password = password.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                user.email = email.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                user["pushEnabled"] = true
                user["firstRemoveFromCalendar"] = true
                user["tempAccounts"] = false
                user["notificationsTimestamp"] = NSDate()
                user["subscriptionsTimestamp"] = NSDate()
                user["localEventsTimestamp"] = NSDate()
                var theMix = Mixpanel.sharedInstance()
                theMix.track("Registered with Facebook -register-")
                
                user.saveInBackgroundWithBlock {
                    (succeeded: Bool, registerError: NSError!) -> Void in
                    
                    if registerError == nil {
                        var currentInstallation = PFInstallation.currentInstallation()
                        currentInstallation["user"] = PFUser.currentUser().username
                        currentInstallation["userId"] = PFUser.currentUser().objectId
                        currentInstallation.saveInBackgroundWithBlock({
                            
                            (success:Bool, saveerror: NSError!) -> Void in
                            
                            if saveerror == nil {
                                var defaultChannel = PFObject(className: "ChannelUser")
                                defaultChannel["expiration"] = NSDate().dateByAddingTimeInterval(25000)
                                defaultChannel["admin"] = false
                                defaultChannel["canPost"] = false
                                defaultChannel["validationCode"] = "nil"
                                defaultChannel["channelID"] = "wEwRowC6io"
                                defaultChannel["channelName"] = "MEMbound Parent"
                                defaultChannel["authorized"] = false
                                defaultChannel["userID"] = PFUser.currentUser().objectId
                                defaultChannel.saveInBackgroundWithBlock({
                                    (success:Bool, error:NSError!) -> Void in
                                    if error == nil {
                                        println("User has been entered into the channel")
                                    } else {
                                        println("User has not been entered into the channel")
                                    }
                                })
                                var defaultChannel2 = PFObject(className: "ChannelUser")
                                defaultChannel2["expiration"] = NSDate().dateByAddingTimeInterval(25000)
                                defaultChannel2["admin"] = false
                                defaultChannel2["canPost"] = false
                                defaultChannel2["validationCode"] = "nil"
                                defaultChannel2["channelID"] = "LAUfZJ3KKc"
                                defaultChannel2["channelName"] = "MEMbound Student"
                                defaultChannel2["authorized"] = false
                                defaultChannel2["userID"] = PFUser.currentUser().objectId
                                defaultChannel2.saveInBackgroundWithBlock({
                                    (success:Bool, error:NSError!) -> Void in
                                    if error == nil {
                                        println("User has been entered into the channel")
                                    } else {
                                        println("User has not been entered into the channel")
                                    }
                                })
                                println("it worked")
                                
                            }
                                
                            else {

                                println("It didnt work")
                            }
                            
                        })
                        self.performSegueWithIdentifier("registerS", sender: self)
                        
                    }
                    else {
                        println(registerError.code)
                        switch registerError.code {
                            
                        case 125:
                            self.displayAlert("Oops!", error: "Please enter a valid email address.")
                            
                        case 100:
                            self.displayAlert("Oops!", error: "Please activate your wifi or cellular network.")
                            
                        case 203:
                            self.displayAlert("Oops", error: "This email is already taken.")
                            
                        case 202:
                            self.displayAlert("Oops!", error: "This username is already taken.")
                            
                        default:
                            self.displayAlert("Oops!", error: "Something went wrong.")
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func CancelButton(sender: AnyObject) {
        if editing == true {
            
            var user = PFUser.currentUser()
            user.deleteInBackgroundWithBlock({
                
                (succes:Bool, error:NSError!) -> Void in
                if error == nil {
                    PFUser.logOut()
                    self.performSegueWithIdentifier("backToHome", sender: sender)
                }
                else {
                    println(error)
                }
            })
        }
        else {
          self.performSegueWithIdentifier("backToHome", sender: sender)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
    }
}
