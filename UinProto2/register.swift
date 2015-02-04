//
//  register.swift
//  UinProto2
//
//  Created by Kareem Dasilva on 12/24/14.
//  Copyright (c) 2014 Kareem Dasilva. All rights reserved.
//

import UIKit

class register: UIViewController, UITextFieldDelegate{
    @IBOutlet var username: UITextField!
    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var cpassword: UITextField!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent){
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    func displayAlert(title:String, error:String){
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
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
    
    @IBAction func register(sender: AnyObject){
        var error = ""
        
        if (username.text == "" || password.text == ""){
            error = "You did not enter a username or password"
        }
        if (password.text != cpassword.text){
            error = "Passwords do not match"
        }
        
        if (error != ""){
            displayAlert("Oops!", error: error)
        }
        else{
            var user = PFUser()
            user.username = username.text
            user.password = password.text
            user.email = email.text
            
            user.signUpInBackgroundWithBlock{
                (succeeded: Bool!, registerError: NSError!) -> Void in
                    if registerError == nil{
                        self.performSegueWithIdentifier("registerS", sender: self)
                    }
                
            }
        }
    }
    
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool){
        
    }
}
