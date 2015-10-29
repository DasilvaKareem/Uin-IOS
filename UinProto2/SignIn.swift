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
    @IBOutlet weak var forgotPwd: UIButton!
    
    var userFacebook = (String)()
    var emailFacebook = (String)()
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
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

        func preferredStatusBarStyle() -> UIStatusBarStyle {
            return UIStatusBarStyle.Default
        }
    }
    
  
 
    override func viewDidLoad() {

        super.viewDidLoad()
  
        let theMix = Mixpanel.sharedInstance()
        theMix.track("Sign In Opened")
        theMix.flush()
        
     
 
        username.attributedPlaceholder = NSAttributedString(string:"USERNAME",
            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        password.attributedPlaceholder = NSAttributedString(string:"PASSWORD",
            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])

    }
    
   
    
    //User singing in with Uin
    @IBAction func signin(sender: AnyObject) {
        let theMix = Mixpanel.sharedInstance()
        theMix.track("Create Account with Uin (SI)")
        theMix.flush()
        var error = ""
        if username.text == "" || password.text == "" {
            error = "Please enter a proper Email and Password"
        }
        if error != "" {
            displayAlert("Oops!", error: error)
        }
        else {
            var subscriptionUsernames = [String]()
            PFUser.logInWithUsernameInBackground(username.text!, password:password.text!) {
                (user: PFUser?, loginError: NSError?) -> Void in

                if loginError == nil {
                  
                    let query = PFQuery(className: "Subscription")
                    query.whereKey("subscriber", equalTo: PFUser.currentUser()!.username!)
                    query.findObjectsInBackgroundWithBlock({
                        
                        (objects:[PFObject]?,queError:NSError?) -> Void in
                        
                        if queError == nil {
                            print(subscriptionUsernames)
                            for object in objects! {
                                
                                subscriptionUsernames.append(object["publisherID"] as!String)
                                
                            }
                            var user = PFUser.currentUser()
                            let currentInstallation = PFInstallation.currentInstallation()
                            currentInstallation["user"] = PFUser.currentUser()!.username
                            currentInstallation["userId"] = PFUser.currentUser()!.objectId!
                            currentInstallation.setValue(subscriptionUsernames, forKey: "channels")
                            currentInstallation.saveInBackgroundWithBlock({
                                
                                (success:Bool, saveerror: NSError?) -> Void in
                                
                                if saveerror == nil {
                                print("success")
                                }
                                    
                                else {
                                    print("It didnt work")
                                }
                            })
                         }   else {
                            print(queError)
                        }
                 
                    })
                    self.performSegueWithIdentifier("login", sender: "self")
                    
                }
                else{
                    print(loginError!.code)
                    switch loginError!.code {
                        
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
            let create : register = segue.destinationViewController as! register
            if self.emailFacebook != "" {
                create.emailPlace = self.emailFacebook
                create.userPlace = self.userFacebook
                create.editing = true
                
            }
        }
    }
}
class ForgotPasswordView: UIViewController {
    
    @IBOutlet weak var resultTest: UILabel!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var passwordResetField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidDisappear(animated: Bool) {
    
    }
    //Sends password reset fourm
    @IBAction func sendReset(sender: AnyObject) {
        PFUser.requestPasswordResetForEmailInBackground(passwordResetField.text!, block: {
            (success:Bool, error:NSError?) -> Void in
            if error == nil {
                self.confirmBtn.setTitle("Resend", forState: UIControlState.Normal)
                self.resultTest.text = "Sent Email"
            } else {
                 self.resultTest.text = "No user found with email address \(self.passwordResetField.text)"
            }
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
