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
                            
                            user["profileReady"] = false
                            user["gender"] = result["gender"]
                            var fbSession = PFFacebookUtils.session()
                            var accessToken = fbSession.accessTokenData.accessToken
                            let url = NSURL(string: "https://graph.facebook.com/me/picture?type=large&return_ssl_resources=1&access_token="+accessToken)
                            let urlRequest = NSURLRequest(URL: url!)
                            
                            NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue()) { (response:NSURLResponse!, data:NSData!, error:NSError!) -> Void in
                                
                                // Display the image
                              
                                user["profilePicture"] = PFFile(name: "profilepic.jpg", data: data)
                                
                            }
                            user.saveInBackgroundWithBlock({
                                (success:Bool, error:NSError!) -> Void in
                                if error == nil {
                                   println("The user is saved")
                                    self.performSegueWithIdentifier("push", sender: self)
                                }
                                
                            })
                        }
                        
                        
                        
                    })
                    
                } else {
                    
                    NSLog("User is already signed in with us")
                    if PFUser.currentUser()["profileReady"] as! Bool == true {
                        self.performSegueWithIdentifier("login", sender: self)
                    } else {
                        self.performSegueWithIdentifier("push", sender: self)

                    }
                    
                }
            } else {
                println("Something")
                println(error)
            }
            
        })

    }

    @IBAction func twitterLogin(sender: AnyObject) {
      
        PFTwitterUtils.logInWithBlock {
            
            (user: PFUser?, error: NSError?) -> Void in
            
            if let user = user {
                
           
                
                if user.isNew {
                    var token : NSString = PFTwitterUtils.twitter().authToken
                    var secret : NSString = PFTwitterUtils.twitter().authTokenSecret
                    var usern : NSString = PFTwitterUtils.twitter().screenName
                    
                    var credential : ACAccountCredential = ACAccountCredential(OAuthToken: token as String, tokenSecret: secret as String)
                    var verify : NSURL = NSURL(string: "https://api.twitter.com/1.1/account/verify_credentials.json")!
                    var request : NSMutableURLRequest = NSMutableURLRequest(URL: verify)
                    
                    //You don't need this line
                    //request.HTTPMethod = "GET"
                    
                    PFTwitterUtils.twitter().signRequest(request)
                    
                    //Using just the standard NSURLResponse.
                    var response: NSURLResponse? = nil
                    var error: NSError? = nil
                    var data = NSURLConnection.sendSynchronousRequest(request,
                        returningResponse: &response, error: nil) as NSData?
                    
                    if error != nil {
                        println("error \(error)")
                    } else {
                        //This will print the status code repsonse. Should be 200.
                        //You can just println(response) to see the complete server response
                        println((response as! NSHTTPURLResponse).statusCode)
                        //Converting the NSData to JSON
                        let json: NSDictionary = NSJSONSerialization.JSONObjectWithData(data!,
                            options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
                        println(json)
                        let url = NSURL(string: json["profile_image_url"] as! String)
                        let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
                        var name = json["name"] as! String
                        let fullNameArr = name.componentsSeparatedByString(" ")
                        var firstName: String = fullNameArr[0]
                        var lastName: String = fullNameArr[1]
                        user["firstName"] = firstName
                        user["lastName"] = lastName
                        user["profilePicture"] = PFFile(name: "profilePic.jpg", data: data)
                        user.saveInBackgroundWithBlock({
                            (success:Bool, error:NSError!) -> Void in
                            if error == nil {
                                self.performSegueWithIdentifier("push", sender: self)

                            } else {
                                
                            }
                        })
                        
                    }
                    println("User signed up and logged in with Twitter!")
                    
                } else {
                    if PFUser.currentUser()["profileReady"] as! Bool == true {
                        self.performSegueWithIdentifier("login", sender: self)
                    } else {
                         self.performSegueWithIdentifier("push", sender: self)
                    }
                   
                    println("User logged in with Twitter!")
                    
                }
                
            } else {
                
                println("Uh oh. The user cancelled the Twitter login.")
                
            }
            
        }
        

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //PFUser.logOut()
     
    
    }
    override func viewDidAppear(animated: Bool) {
        if PFUser.currentUser() != nil {
            self.performSegueWithIdentifier("login", sender: self)
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
class registrationProcess: UIViewController {
    
    @IBOutlet weak var emailSignUp: UITextField!
    @IBOutlet weak var emailVerify: UIButton!
    @IBOutlet weak var nextLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
      nextButton.hidden = true
        nextLabel.hidden = true
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func verifyEmail(sender: AnyObject) {
        if PFUser.currentUser() != nil {
            PFUser.currentUser().email = emailSignUp.text
            PFUser.currentUser().saveInBackgroundWithBlock({
                (succss:Bool, error:NSError!) -> Void in
                if error == nil {
                    println("email is changed")
                    self.nextButton.hidden = false
                    self.nextLabel.hidden = false
                } else {
                    println("email was not saved")
                }
            })
        }
    }
        
    
    var characterSet:NSCharacterSet = NSCharacterSet(charactersInString: "@memphis.edu")
    @IBAction func nextView(sender: AnyObject) {
        //Sign user in
     
      
                    
        
                    if ( PFUser.currentUser().email.rangeOfString("memphis.edu") != nil) {
                            println("This guy is ready to procreed")
                            self.performSegueWithIdentifier("push", sender: self)
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
    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var lName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        queryData()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func queryData(){
        var query = PFUser.currentUser()
        
        if query["firstName"] != nil {
            fName.text = query["firstName"] as! String
        }
        if query["lasttName"] != nil {
              lName.text = query["lastName"] as! String
        }
        var file = query["profilePicture"] as! PFFile
        file.getDataInBackgroundWithBlock({
            (data:NSData!, error:NSError!) -> Void in
            if error == nil {
                self.profilePic.image = UIImage(data: data)
            }
        })
        
      
        
    }
    @IBAction func submitData(sender : AnyObject) {
        var user = PFUser.currentUser()
        user["firstName"] = fName.text.capitalizedString
        user["lName"] = lName.text.capitalizedString
        user.saveInBackgroundWithBlock({
            (success:Bool, error:NSError!) -> Void in
            if error == nil {
                println("updated username fields")
                self.performSegueWithIdentifier("push", sender: self)
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
    var classes = ["Freshman", "Sophmore", "Junior","Senior", "Graduate"]
    var userClass = "Freshman"
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
        var error = ""
        if gender.selectedSegmentIndex == 1 {
            user["gender"] = "male"
        } else {
            user["gender"] = "female"
        }
        if age.text.toInt() != nil {
            user["age"] = age.text.toInt()
        } else {
            println("This is not a real number")
            error = "please enter a real number"
        }
        
        user["classifcation"] = userClass
        if error == "" {
            user["profileReady"] = true
            user.saveInBackgroundWithBlock({
                (success:Bool, error:NSError!) -> Void in
                if error == nil {
                    self.performSegueWithIdentifier("push", sender: self)
                    
                    println("user object was saved")
                } else {
                    println("user object was not saved")
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