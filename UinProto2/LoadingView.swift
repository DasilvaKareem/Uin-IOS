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
      PFUser.logOut()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(animated: Bool) {
        func randomStringWithLength (len : Int) -> NSString {
            
            let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            
            let randomString : NSMutableString = NSMutableString(capacity: len)
            
            for (var i=0; i < len; i++){
                let length = UInt32 (letters.length)
                let rand = arc4random_uniform(length)
                randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
            }
    
            return randomString
        }
        
        spinner.startAnimating()
       
            let storyboard = UIStoryboard(name: "EventFlowSB", bundle: nil)
            let poop:UIViewController = storyboard.instantiateInitialViewController()
            
            self.presentViewController(poop, animated: true, completion: nil)
       

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
