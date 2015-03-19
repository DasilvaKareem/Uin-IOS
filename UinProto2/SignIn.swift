//
//  SignIn.swift
//  UinProto2
//
//  Created by Kareem Dasilva on 12/24/14.
//  Copyright (c) 2014 Kareem Dasilva. All rights reserved.
//

import UIKit

class SignIn: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    var userFacebook = (String)()
    var emailFacebook = (String)()
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        textField.resignFirstResponder()
        return true
    }
 
    func displayAlert(title:String, error:String) {
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
        }))
        self.presentViewController(alert, animated: true, completion: nil)

        func preferredStatusBarStyle() -> UIStatusBarStyle {
            return UIStatusBarStyle.Default
        }
    }
    
    @IBAction func facebook(sender: AnyObject) {
        
        //Logins into Facebook
        var theMix = Mixpanel.sharedInstance()
        theMix.track("Tap Facebook Login")
        theMix.flush()
        var fbloginView:FBLoginView = FBLoginView(readPermissions: ["email", "public_profile"])
        var permissions = ["public_profile", "email"]
        PFFacebookUtils.logInWithPermissions(permissions, block: {
            (user: PFUser!, error: NSError!) -> Void in
            if user == nil {
                NSLog("Uh oh. The user cancelled the Facebook login.")
                println(error)
                //self.loginCancelledLabel.alpha = 1
                
            } else if user.isNew {
                NSLog("User signed up and logged in through Facebook!")
                
                FBRequestConnection.startForMeWithCompletionHandler({
                    connection, result, error in
                    println(result)
                    self.userFacebook =  result["name"] as String
                    self.emailFacebook = result["email"] as String
                    var theMix = Mixpanel.sharedInstance()
                    theMix.track("Created Profile Info with Facebook -signIn-")
                    self.performSegueWithIdentifier("register", sender: self)
                
                })
                
            } else {
                
                NSLog("User is already signed in with us")
                var currentInstallation = PFInstallation.currentInstallation()
                currentInstallation["user"] = PFUser.currentUser().username
                currentInstallation["userId"] = PFUser.currentUser().objectId
                currentInstallation.saveInBackgroundWithBlock({
                    
                    (success:Bool!, saveerror: NSError!) -> Void in
                    
                    if saveerror == nil {
                        
                        var theMix = Mixpanel.sharedInstance()
                        theMix.track("SignIns")
                        self.performSegueWithIdentifier("login", sender: self)
                        
                    }
                        
                    else {
                        
                        println("facebook installtions was not succesfull")
                    }
                    
                })
              
            }
        })
    }
 
    override func viewDidLoad() {

        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
 
        username.attributedPlaceholder = NSAttributedString(string:"USERNAME",
            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        password.attributedPlaceholder = NSAttributedString(string:"PASSWORD",
            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])

    }
    
    func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y = -85
    }
    func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0.0
    }
    
    @IBAction func signin(sender: AnyObject) {
        var theMix = Mixpanel.sharedInstance()
        theMix.track("Tap UIn login")
        theMix.flush()
        var error = ""
        if username.text == "" || password.text == "" {
            error = "Please enter a proper Username and Password"
        }
        if error != "" {
            displayAlert("Oops!", error: error)
        }
        else {
            var subscriptionUsernames = [String]()
            PFUser.logInWithUsernameInBackground(username.text, password:password.text) {
                (user: PFUser!, loginError: NSError!) -> Void in

                if loginError == nil {
                  
                    var query = PFQuery(className: "Subscription")
                    query.whereKey("subscriber", equalTo: PFUser.currentUser().username)
                    query.findObjectsInBackgroundWithBlock({
                        
                        (objects:[AnyObject]!, queError:NSError!) -> Void in
                        
                        if queError == nil {
                            println(subscriptionUsernames)
                            for object in objects {
                                
                                subscriptionUsernames.append(object["userId"] as String)
                                
                            }
                            var user = PFUser.currentUser()
                            var currentInstallation = PFInstallation.currentInstallation()
                            currentInstallation["user"] = PFUser.currentUser().username
                            currentInstallation["userId"] = PFUser.currentUser().objectId
                            currentInstallation.setValue(subscriptionUsernames, forKey: "channels")
                            currentInstallation.saveInBackgroundWithBlock({
                                
                                (success:Bool!, saveerror: NSError!) -> Void in
                                
                                if saveerror == nil {
                                    println("it worked")
                                }
                                    
                                else {
                                    println("It didnt work")
                                }
                            })
                         }   else {
                            println(queError)
                        }
                 
                    })
                    self.performSegueWithIdentifier("login", sender: "self")
                    
                }
                else{
                    println(loginError.code)
                    switch loginError.code {
                        
                    case 125:
                        self.displayAlert("Oops!", error: "wrong Email")
                    case 100:
                        self.displayAlert("Oops!", error: "No internet")
                    case 203:
                        self.displayAlert("Oops", error: "Email Taken")
                    case 202:
                        self.displayAlert("Oops!", error: "Username taken")
                    default:
                        self.displayAlert("Oops!", error: "Wrong username and password")
                    }
                }
            }
        }
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
    }

   override func viewDidAppear(animated: Bool) {
  
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "register" {
            var create : register = segue.destinationViewController as register
            if self.emailFacebook != "" {
                create.emailPlace = self.emailFacebook
                create.userPlace = self.userFacebook
                create.editing = true
                
            }
        }
    }
}
