//
//  registrationProcess.swift
//  Uin
//
//  Created by Kareem Dasilva on 7/14/15.
//  Copyright (c) 2015 Kareem Dasilva. All rights reserved.
//

import UIKit
class procress {


}
class registrationProcess: UIViewController {
   
    @IBOutlet weak var emailSignUp: UITextField!
    @IBOutlet weak var emailVerify: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       PFUser.logOut()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func verifyEmail(sender: AnyObject) {
        if ( emailSignUp.text.rangeOfCharacterFromSet(characterSet) != nil) {
           var user = PFUser()
            user.username = emailSignUp.text
            user.password = "123Test"
            user.email = emailSignUp.text
            
            user.signUpInBackgroundWithBlock({
                (success:Bool, error:NSError?) -> Void in
                if error == nil {
                    println("Made temp account")
                }
            })
        }
    }
        
   
    var characterSet:NSCharacterSet = NSCharacterSet(charactersInString: "@memphis.edu")
    @IBAction func nextView(sender: AnyObject) {
         var user = PFUser.currentUser()
        
        
        if ( user?.email!.rangeOfCharacterFromSet(characterSet) != nil) {
           
        } else {
            println("you do not have a memphis.edu")
        }
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
class basicSignUp: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
class extraSignUp: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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