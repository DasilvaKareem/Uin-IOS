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

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }
    
    
    
    func displayAlert(title:String, error:String) {
        
        let alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let theMix = Mixpanel.sharedInstance()
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
        
        
        if username.text!.rangeOfCharacterFromSet(characterSet) != nil {
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
            
        
    }
    
    @IBAction func CancelButton(sender: AnyObject) {
        if editing == true {
            
            let user = PFUser.currentUser()
            user.deleteInBackgroundWithBlock({
                
                (succes:Bool, error:NSError?) -> Void in
                if error == nil {
                    PFUser.logOut()
                    self.performSegueWithIdentifier("backToHome", sender: sender)
                }
                else {
                    print(error)
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
