//
//  LoadingView.swift
//  Uin
//
//  Created by Kareem Dasilva on 3/16/15.
//  Copyright (c) 2015 Kareem Dasilva. All rights reserved.
//

import UIKit

class LoadingView: UIViewController {

    @IBOutlet var spinner: UIActivityIndicatorView!
 
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(animated: Bool) {
        func randomStringWithLength (len : Int) -> NSString {
            
            let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            
            var randomString : NSMutableString = NSMutableString(capacity: len)
            
            for (var i=0; i < len; i++){
                var length = UInt32 (letters.length)
                var rand = arc4random_uniform(length)
                randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
            }
    
            return randomString
        }
        
        spinner.startAnimating()
        var user = PFUser.currentUser()
        //Logs you inside the app if you are signed im
        if PFUser.currentUser() != nil {
            var userTimeCheck = PFUser.currentUser()
            userTimeCheck["notificationsTimestamp"] = NSDate()
            userTimeCheck.saveInBackgroundWithBlock({
                (success:Bool, error:NSError!) -> Void in
                if error == nil {
                    println("The stamp was updated")
                } else {
                    println(error.debugDescription)
                }
            })
            self.performSegueWithIdentifier("login", sender: self)
        } else {
              self.performSegueWithIdentifier("createAccount", sender: self)
        }

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
