//
//  register.swift
//  UinProto2
//
//  Created by Kareem Dasilva on 12/24/14.
//  Copyright (c) 2014 Kareem Dasilva. All rights reserved.
//

import UIKit

class register: UIViewController {

    
    @IBOutlet weak var username: UITextField!
    
    
    @IBOutlet weak var password: UITextField!
    
    
    @IBOutlet weak var email: UITextField!
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    @IBAction func register(sender: AnyObject) {
        
        var error = ""
        
        if username.text == "" || password.text == "" {
            
            error = "You did not enter a username or password"
            
        }
        if error == "" {
            
            var user = PFUser()
            
            user.username = username.text
            
            user.password = password.text
            
            user.email = email.text
            
            user.signUpInBackgroundWithBlock {
                (succeeded: Bool!, registerError: NSError!) -> Void in
                
                if registerError == nil {
                    
                    self.performSegueWithIdentifier("jump", sender: self)
                    
                }
                
            }
            
        }
        
    }
    
    @IBAction func login(sender: AnyObject) {
        
        self.performSegueWithIdentifier("login", sender: self)
    }
    
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(animated: Bool) {
        if PFUser.currentUser() != nil {
            
            self.performSegueWithIdentifier("jump", sender: self)
            
        }
        
    }

  

}
