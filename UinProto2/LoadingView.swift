//
//  LoadingView.swift
//  Uin
//
//  Created by Kareem Dasilva on 3/16/15.
//  Copyright (c) 2015 Kareem Dasilva. All rights reserved.
//

import UIKit


class LoadingView: UIViewController {

    
 
    override func viewDidLoad() {
        super.viewDidLoad()
      //PFUser.logOut()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(animated: Bool) {
      
        
    
        if PFUser.currentUser() == nil {
           print("not logged in")
        } else {
            self.performSegueWithIdentifier("login", sender: self)
        }
        
       

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func register(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "EventFlowSB", bundle: nil)
        let register:UIViewController = storyboard.instantiateInitialViewController()!
        
        self.presentViewController(register, animated: true, completion: nil)
        
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
