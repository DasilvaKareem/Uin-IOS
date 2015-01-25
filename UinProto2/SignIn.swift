//
//  SignIn.swift
//  UinProto2
//
//  Created by Kareem Dasilva on 12/24/14.
//  Copyright (c) 2014 Kareem Dasilva. All rights reserved.
//

import UIKit

class SignIn: UIViewController {
    
    
    @IBOutlet weak var username: UITextField!
    
    
    @IBOutlet weak var password: UITextField!
    

    
    func displayAlert(title:String, error:String) {
        
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        username.attributedPlaceholder = NSAttributedString(string:"USERNAME",
            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        password.attributedPlaceholder = NSAttributedString(string:"PASSWORD",
            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func signin(sender: AnyObject) {
        
        var error = ""
        
        if username.text == "" || password.text == "" {
            
            error = "You did not enter a username or password"
            
        }
        if error != "" {
            
            displayAlert("Error in Form", error: error)
            
        }
        
            else {
            
        

            PFUser.logInWithUsernameInBackground(username.text, password:password.text) {
                (user: PFUser!, loginError: NSError!) -> Void in
                
                
                
                if loginError == nil {
                    
                    self.performSegueWithIdentifier("login", sender: "self")
                    
                }
                else{
                    
                    println(loginError)
                }
            }
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        if PFUser.currentUser() != nil {
            
            self.performSegueWithIdentifier("login", sender: self)
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
