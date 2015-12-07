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
        if user != nil {
            user!.deleteInBackgroundWithBlock({
                
                (succes:Bool, error:NSError?) -> Void in
                if error == nil {
                    PFUser.logOut()
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let register:UIViewController = storyboard.instantiateInitialViewController()!
                    
                    self.presentViewController(register, animated: true, completion: nil)
                }
                else {
                    alertUser(self, title: "Oops!", message: "You were logged out incorrectly. Please try again or contact support@areuin.co")
                    print(error)
                }
            })
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let register:UIViewController = storyboard.instantiateInitialViewController()!
            
            self.presentViewController(register, animated: true, completion: nil)

        }
        
    }

    @IBAction func createAccount(sender: AnyObject) {
        
   
        //Signs in user
        let user = PFUser()
        let email = registerEmail.text
        let password = registerPassword.text
        let cPassword =  registerConfirmPassword.text
        user.email = email
        user.username = email
        user.password = password
        if (email?.isEmpty == true || password?.isEmpty == true) {
            alertUser(self, title: "Enter in all the fields", message: "pls")
            
        } else {
            if cPassword == password {
                user.signUpInBackgroundWithBlock({
                    success,error in
                    if error == nil {
                        if ( PFUser.currentUser()!.email!.lowercaseString.rangeOfString("memphis.edu") != nil) {
                            
                            print("This guy is ready to procreed")
                            self.performSegueWithIdentifier("next1", sender: self)
                            
                        } else {
                            alertUser(self, title: "Where do you go to school?", message: "Please enter an @memphis.edu email address.")
                            print("you do not have a memphis.edu")
                        }
                    } else {
                        print("this guy messed up somewhere", terminator: "")
                    }
                })
                
                
            } else {
                alertUser(self, title: "Passwords do not match", message: "make them match")
            }

        }
        
        
        
                //Only allows users who have memphis.edu proceed
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
    }
        func keyboardWillShow(sender: NSNotification) {
            
            self.view.frame.origin.y = -150
            print("apperaed")
            print(self.view.frame.origin.y)
        }
        func keyboardWillHide(sender: NSNotification) {
            self.view.frame.origin.y = 0.0
            print("disappeared")
            
            print(self.view.frame.origin.y)
        

    }
 
    
    //Calls this function when the tap is recognized.
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
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
                alertUser(self, title: "Oops!", message: "You were logged out incorrectly. Please try again or contact support@areuin.co")

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
                    FBRequestConnection.startForMeWithCompletionHandler({
                        connection, result, error in
                        if error == nil {
                            print(result)
                            self.user!["firstName"] = result["first_name"]
                            self.user!["lastName"] = result["last_name"]
                            self.user!["gender"] = result["gender"]
                            let fbSession = PFFacebookUtils.session()
                            let accessToken = fbSession!.accessTokenData.accessToken
                            let url = NSURL(string: "https://graph.facebook.com/me/picture?type=large&return_ssl_resources=1&access_token="+accessToken)
                            let urlRequest = NSURLRequest(URL: url!)
                            
                            NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue()) { (response:NSURLResponse?, data:NSData?, error:NSError?) -> Void in
                                
                                // Display the image
                                
                                self.user!["profilePicture"] = PFFile(name: "profilepic.jpg", data: data!)
                                
                            }
                            self.user!.saveInBackgroundWithBlock({
                                (success:Bool, error:NSError?) -> Void in
                                if error == nil {
                                    print("The user is saved")
                                    self.performSegueWithIdentifier("next2", sender: self)
                                }
                                
                            })
                        }
                        
                        
                        
                    })
                    

                } else {
                    alertUser(self, title: "You already have an Account", message: "Please use another one")
                }
            })
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
class basicSignUp: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
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
    
    let imagePicker = UIImagePickerController()

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func changeImage(sender: AnyObject) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
  
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profilePic.contentMode = .ScaleAspectFit
            profilePic.image = pickedImage
        }
        
        dismissViewControllerAnimated(true, completion: nil)
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
                alertUser(self, title: "Oops!", message: "You were logged out incorrectly. Please try again or contact support@areuin.co")
                print(error)
            }
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        queryData() // gets data from facebook that was saved in parse
    }
    func keyboardWillShow(sender: NSNotification) {
        
        self.view.frame.origin.y = -200
        print("apperaed")
        print(self.view.frame.origin.y)
    }
    func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0.0
        print("disappeared")
        
        print(self.view.frame.origin.y)
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
        
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
        var file = query["profilePicture"] as! PFFile
        file.getDataInBackgroundWithBlock({
            (data:NSData?, error:NSError?) -> Void in
            if error == nil {
                self.profilePic.image = UIImage(data: data!)
            }
        })
        
        
        
    }
    
    //This function and error set ensures the user inputs a first and last name field
    @IBAction func submitData(sender : AnyObject) {
        let user = PFUser.currentUser()!
        user["firstName"] = fName.text!.capitalizedString
        user["lastName"] = lName.text!.capitalizedString
        user["profilePicture"] = profilePic.image
        if fName.text?.isEmpty == true || lName.text?.isEmpty == true {
             alertUser(self, title: "Oops!", message: "Make sure you fill out a first and last name so we know you're real!")
        } else {
            user.saveInBackgroundWithBlock({
                (success:Bool, error:NSError?) -> Void in
                if error == nil {
                    print("updated username fields")
                    self.performSegueWithIdentifier("next3", sender: self)
                } else {
                    
                    print("Not sucessful")
                }
            })
        }
 
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
    var classes = ["Freshman", "Sophomore", "Junior","Senior", "Graduate"]
    var userClass = "Freshman"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
    }
    func keyboardWillShow(sender: NSNotification) {
        
        self.view.frame.origin.y = -50
        print("apperaed")
        print(self.view.frame.origin.y)
    }
    func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0.0
        print("disappeared")
        
        print(self.view.frame.origin.y)
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
        
        
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
                alertUser(self, title: "Oops!", message: "You were logged out incorrectly. Please try again or contact support@areuin.co")
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
            
        } else {
            alertUser(self, title: "Oops!", message: "Please enter a valid numerical age.")
        }
    }
}