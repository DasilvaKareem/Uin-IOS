//
//  LogInVC.swift
//  
//
//  Created by Kareem Dasilva on 10/8/15.
//
//

import UIKit


class LogInVC: UIViewController {
    //Manges the registrain and login procress for users
    
    //holds registration fields
    @IBOutlet weak var registerEmail: UITextField!
    
    @IBOutlet weak var registerPassword: UITextField!

    @IBOutlet weak var registerConfirmPassword: UITextField!
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func cancel(sender: AnyObject) {
        let user = PFUser.currentUser()
        user!.deleteInBackgroundWithBlock({
            
            (succes:Bool, error:NSError?) -> Void in
            if error == nil {
                PFUser.logOut()
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let register:UIViewController = storyboard.instantiateInitialViewController()!
                
                self.presentViewController(register, animated: true, completion: nil)
            }
            else {
                print(error)
            }
        })
        
    }

    @IBAction func createAccount(sender: AnyObject) {
        
   
        //Signs in user
        let user = PFUser()
        user.email = registerEmail.text
        user.username = registerEmail.text
        user.password = registerPassword.text
        user.signUpInBackgroundWithBlock({
            success,error in
            if error == nil {
                if ( PFUser.currentUser()!.email!.lowercaseString.rangeOfString("memphis.edu") != nil) {
                 
                        print("This guy is ready to procreed")
                        self.performSegueWithIdentifier("next1", sender: self)
                  
                } else {
                    alertUser(self, title: "You do not have a memphis.edu", message: "Please enter a memphis edu")
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
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @IBAction func cancel(sender: AnyObject) {
        let user = PFUser.currentUser()
        user!.deleteInBackgroundWithBlock({
            
            (succes:Bool, error:NSError?) -> Void in
            if error == nil {
                PFUser.logOut()
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let register:UIViewController = storyboard.instantiateInitialViewController()!
                
                self.presentViewController(register, animated: true, completion: nil)
            }
            else {
                print(error)
            }
        })
    }
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
                    self.performSegueWithIdentifier("next2", sender: self)

                } else {
                    alertUser(self, title: "You already have an Account", message: "Please use another one")
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
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @IBOutlet weak var fName: UITextField!
    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var lName: UITextField!
    @IBAction func cancel(sender: AnyObject) {
        let user = PFUser.currentUser()
        user!.deleteInBackgroundWithBlock({
            
            (succes:Bool, error:NSError?) -> Void in
            if error == nil {
                PFUser.logOut()
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let register:UIViewController = storyboard.instantiateInitialViewController()!
                
                self.presentViewController(register, animated: true, completion: nil)
            }
            else {
                print(error)
            }
        })
    }
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
            (success:Bool, error:NSError?) -> Void in
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
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBOutlet weak var gender: UISegmentedControl!
    @IBOutlet weak var classifcation: UIPickerView!
    
    @IBOutlet weak var age: UITextField!
    var classes = ["Freshman", "Sophmore", "Junior","Senior", "Graduate", "N/A"]
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
    @IBAction func cancel(sender: AnyObject) {
        let user = PFUser.currentUser()
        user!.deleteInBackgroundWithBlock({
            
            (succes:Bool, error:NSError?) -> Void in
            if error == nil {
                PFUser.logOut()
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let register:UIViewController = storyboard.instantiateInitialViewController()!
                
                self.presentViewController(register, animated: true, completion: nil)
            }
            else {
                print(error)
            }
        })

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