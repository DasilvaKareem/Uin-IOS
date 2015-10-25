//
//  LogInVC.swift
//  
//
//  Created by Kareem Dasilva on 10/8/15.
//
//

import UIKit
import Parse

class LogInVC: UIViewController {
    //Manges the registrain and login procress for users
    
    //holds registration fields
    @IBOutlet weak var registerEmail: UITextField!
    
    @IBOutlet weak var registerPassword: UITextField!

    @IBOutlet weak var registerConfirmPassword: UITextField!
    
    @IBAction func createAccount(sender: AnyObject) {
   
        //Signs in user
        let user = PFUser()
        user.email = registerEmail.text
        user.username = registerEmail.text
        user.password = registerPassword.text
        user.signUpInBackgroundWithBlock({
            success,error in
            if error == nil {
                if ( PFUser.currentUser()!.email!.rangeOfString("memphis.edu") != nil) {
                 
                        print("This guy is ready to procreed")
                        self.performSegueWithIdentifier("next1", sender: self)
                  
                } else {
                    print("you do not have a memphis.edu")
                }
            } else {
                print("this guy messed up somewhere", terminator: "")
            }
        })
        //Only allows users who have memphis.edu proceed
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PFUser.logOut()
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
class LinkUser: UIViewController {
    //Link user with facebook or Twitter
    var user = PFUser.currentUser()
    
    @IBAction func nextSubmission(sender: AnyObject) {
        self.performSegueWithIdentifier("next2", sender: self)
    }

    @IBAction func linkWithFacebook(sender: AnyObject) {
        if !PFFacebookUtils.isLinkedWithUser(user!) {
            PFFacebookUtils.linkUser(user!, permissions: nil, block: {
                succeeded, error in
                if succeeded {
                    print("Woohoo, the user is linked with Facebook!", terminator: "")
                }
            })
        }

    }

    @IBAction func linkWithTwitter(sender: AnyObject) {
     
        if !PFTwitterUtils.isLinkedWithUser(user) {
            PFTwitterUtils.linkUser(user, block: {
                (succeeded: Bool, error: NSError?) -> Void in
                if PFTwitterUtils.isLinkedWithUser(self.user) {
                    print("Woohoo, user logged in with Twitter!", terminator: "")
                }
            })
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
class basicSignUp: UIViewController {
    @IBOutlet weak var fName: UITextField!
    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var lName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        //queryData()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func queryData(){
        let query = PFUser.currentUser() as PFUser!
        
        if query["firstName"] != nil {
            fName.text = query["firstName"] as? String
        }
        if query["lasttName"] != nil {
            lName.text = query["lastName"] as? String
        }
       /* var file = query["profilePicture"] as! PFFile
        file.getDataInBackgroundWithBlock({
            (data:NSData!, error:NSError?) -> Void in
            if error == nil {
                self.profilePic.image = UIImage(data: data)
            }
        })*/
        
        
        
    }
    @IBAction func submitData(sender : AnyObject) {
        let user = PFUser.currentUser()!
        user["firstName"] = fName.text!.capitalizedString
        user["lName"] = lName.text!.capitalizedString
        user.saveInBackgroundWithBlock({
            (success:Bool!, error:NSError?) -> Void in
            if error == nil {
                print("updated username fields")
                self.performSegueWithIdentifier("next3", sender: self)
            } else {
                print("Not sucessfuk")
            }
        })
    }
}
class extraSignUp: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var gender: UISegmentedControl!
    @IBOutlet weak var classifcation: UIPickerView!
    
    @IBOutlet weak var age: UITextField!
    var classes = ["Freshman", "Sophmore", "Junior","Senior", "Graduate"]
    var userClass = "Freshman"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return classes[row]
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return classes.count
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.userClass = classes[row]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func submitData(sender: AnyObject) {
        let user = PFUser.currentUser()!
        var error = ""
        if gender.selectedSegmentIndex == 1 {
            user["gender"] = "male"
        } else {
            user["gender"] = "female"
        }
        if Int(age.text!) != nil {
            user["age"] = Int(age.text!)
        } else {
            print("This is not a real number")
            error = "please enter a real number"
        }
        
        user["classifcation"] = userClass
        if error == "" {
            user["profileReady"] = true
            user.saveInBackgroundWithBlock({
                (success:Bool, error:NSError?) -> Void in
                if error == nil {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let poop:UIViewController = storyboard.instantiateInitialViewController()!
                    
                    self.presentViewController(poop, animated: true, completion: nil)
                    print("user object was saved")
                } else {
                    print("user object was not saved")
                }
            })
            
        }
    }
}