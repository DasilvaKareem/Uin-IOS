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
    
    @IBOutlet weak var menuTrigger: UIBarButtonItem!
    var id = (String)() // contains creation org object id
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navBarBackground.png"), forBarMetrics: UIBarMetrics.Default)
        // Changes text color on navbar
        var nav = self.navigationController?.navigationBar
        nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()];
        self.tabBarController?.tabBar.hidden = true
        
        // Do any additional setup after loading the view.
        if self.revealViewController() != nil {
            menuTrigger.target = self.revealViewController()
            menuTrigger.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
        // Do any additional setup after loading the view.
        
        if editing == true {
            let user = PFUser.currentUser()["organization"] as! PFObject
            orgName.text = user["name"] as! String
            orgDescription.text = user["description"] as! String
            
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func CreateOrg(sender: AnyObject) {

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
                     self.id = Organization.objectId
                    //If it was successful
                    println("Good job you created uin")
                    //Saves the organization to the User
                    PFUser.currentUser()["organization"] = Organization
                    PFUser.currentUser().saveInBackgroundWithBlock({
                        (succ:Bool, error:NSError!) -> Void in
                        if error == nil {
                            println(self.id)
                            self.performSegueWithIdentifier("OrgPush", sender: self)
                        } else {
                            println("It failed")
                        }
                        
                    })
                }
            })
        }
       
        
    }
   

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var orgPage:OrginazationPage = segue.destinationViewController as! OrginazationPage
        orgPage.orgID = id
        
    }


}
class OrginazationPage: UIViewController {
    
    @IBOutlet weak var menuTrigger: UIBarButtonItem!
    @IBOutlet weak var orgName: UILabel!
    
    @IBOutlet weak var orgDesciption: UILabel!
    
    var orgID = (String)()
    func setupNav(){
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navBarBackground.png"), forBarMetrics: UIBarMetrics.Default)
        // Changes text color on navbar
        var nav = self.navigationController?.navigationBar
        nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()];
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navBarBackground.png"), forBarMetrics: UIBarMetrics.Default)
        if self.revealViewController() != nil {
            menuTrigger.target = self.revealViewController()
            menuTrigger.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
      setupNav()
        //Querys for data about the ORganization
        var query = PFQuery(className: "Organization")
        query.getObjectInBackgroundWithId(orgID, block: {
            (object:PFObject!, error:NSError!) -> Void in
            if error == nil {
                
                self.orgName.text = object["name"] as? String
                self.orgDesciption.text = object["description"] as? String
            }
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
