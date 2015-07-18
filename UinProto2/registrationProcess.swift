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
class homePage: UIViewController {
    
    @IBAction func facebookLogin(sender: AnyObject) {
        var fbloginView:FBLoginView = FBLoginView(readPermissions: ["email", "public_profile"])
        var permissions = ["public_profile", "email"]
        PFFacebookUtils.logInWithPermissions(permissions, block: {
            (user: PFUser!, error: NSError!) -> Void in
            if error == nil {
                if user == nil {
                    NSLog("Uh oh. The user cancelled the Facebook login.")
                    println(error)
                  
                    
                } else if user.isNew {
                    NSLog("User signed up and logged in through Facebook!")
                    
                    FBRequestConnection.startForMeWithCompletionHandler({
                        connection, result, error in
                        if error == nil {
                            println(result)
                            user["firstName"] = result["first_name"]
                            user["lastName"] = result["last_name"]
                            user.username = result["email"] as! String
                            user.email = result["email"] as!String
                            user["gender"] = result["gender"]
                            user.saveInBackgroundWithBlock({
                                (success:Bool, error:NSError!) -> Void in
                                if error == nil {
                                   println("The user is saved")
                                }
                                
                            })
                        }
                        
                        
                        
                    })
                    
                } else {
                    
                    NSLog("User is already signed in with us")
             
                    
                }
            }
            
        })

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
class registrationProcess: UIViewController {
    
    @IBOutlet weak var emailSignUp: UITextField!
    @IBOutlet weak var emailVerify: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
      
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
                (success:Bool, error:NSError!) -> Void in
                if error == nil {
                    println("Made temp account")
                }
            })
        }
    }
        
    
    var characterSet:NSCharacterSet = NSCharacterSet(charactersInString: "@memphis.edu")
    @IBAction func nextView(sender: AnyObject) {
        //Sign user in
        PFUser.logInWithUsername(PFUser.currentUser().username, password: "123Test")
        if ( PFUser.currentUser().email.rangeOfString("@memphis.edu") != nil) {
            if PFUser.currentUser()["emailVerified"]  as! Bool == true {
                println("This guy is ready to procreed")
            } else {
                println("This guy email is not Verified")
            }
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
    @IBOutlet weak var fName: UITextField!
    
    @IBOutlet weak var lName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitData(sender: AnyObject) {
        var user = PFUser.currentUser()
        user["firstName"] = fName.text.capitalizedString
        user["lName"] = lName.text.capitalizedString
        user.saveInBackgroundWithBlock({
            (success:Bool, error:NSError!) -> Void in
            if error == nil {
                println("updated username fields")
            } else {
                println("Not sucessfuk")
            }
        })
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
class extraSignUp: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var gender: UISegmentedControl!
    @IBOutlet weak var classifcation: UIPickerView!
    
    @IBOutlet weak var age: UITextField!
    var classes = ["FreshMan", "Sophmore", "Junior","Senior", "Graduate"]
    var userClass = (String)()
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
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
        var user = PFUser.currentUser()
        if gender.selectedSegmentIndex == 1 {
            user["gender"] = "male"
        } else {
            user["gender"] = "female"
        }
        if age.text.toInt() != nil {
            user["gender"] = age.text.toInt()
        } else {
            println("This is not a real number")
        }
        if userClass.isEmpty {
            user["classifcation"] = userClass
        } else {
            
        }
        user.saveInBackgroundWithBlock({
            (success:Bool, error:NSError!) -> Void in
            if error == nil {
                println("user object was saved")
            } else {
                println("user object was not saved")
            }
        })
        

        
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