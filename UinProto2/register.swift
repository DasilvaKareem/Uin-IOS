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
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    func displayAlert(title:String, error:String) {
        
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
            
                      
            
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);

        
        username.attributedPlaceholder = NSAttributedString(string:"USERNAME",
            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        password.attributedPlaceholder = NSAttributedString(string:"PASSWORD",
            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        email.attributedPlaceholder = NSAttributedString(string:"EMAIL",
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
        
        
        var error = ""
        
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
            


            
            var user = PFUser()
            
            user.username = username.text
            
            user.password = password.text
            
            user.email = email.text
            
        
            
          
            
            user.signUpInBackgroundWithBlock {
                (succeeded: Bool!, registerError: NSError!) -> Void in
                
                if registerError == nil {
                    
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
                        self.displayAlert("Oops!", error: "Failure")
                    }
                    
                    
                    
                }
                
            }
            
        }
        
    }
    

    
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(animated: Bool) {
        
        
    }

  

}
