//
//  OrginzationViewC.swift
//  Uin
//
//  Created by Kareem Dasilva on 8/3/15.
//  Copyright (c) 2015 Kareem Dasilva. All rights reserved.
//

import UIKit

class OrginzationViewC: UIViewController {

    @IBOutlet weak var orgName: UILabel!
    @IBOutlet weak var orgDescription: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func CreateOrg(sender: AnyObject) {
        if PFUser.currentUser() == nil {
            println("You are not singed in")
        }
        //Sets details for the orginzation
        var adminArray:NSArray = [PFUser.currentUser()] // array of admins
        var Organization = PFObject(className: "Organization")
        if orgDescription.text.isEmpty == false && orgName.text?.isEmpty == false {
            Organization["name"] = orgName.text?.capitalizedString
            Organization["description"] = orgDescription.text
            Organization["owner"] = PFUser.currentUser() as PFObject
           Organization["admins"] = adminArray
            Organization.saveInBackgroundWithBlock({
                (success:Bool, error:NSError!) -> Void in
                if error == nil {
                    //If it was successful
                    println("Good job you created uin")
                    //Saves the organization to the User
                    PFUser.currentUser()["organization"] = Organization
                    PFUser.currentUser().saveInBackgroundWithBlock({
                        (succ:Bool, error:NSError!) -> Void in
                        if error == nil {
                            self.performSegueWithIdentifier("orgPass", sender: self)
                        } else {
                            println("It failed")
                        }
                        
                    })
                }
            })
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
