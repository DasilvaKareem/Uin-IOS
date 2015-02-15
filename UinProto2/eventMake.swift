//
//  eventMake.swift
//  UinProto2
//
//  Created by Kareem Dasilva on 1/9/15.
//  Copyright (c) 2015 Kareem Dasilva. All rights reserved.
//

import UIKit


class eventMake: UIViewController, UITextFieldDelegate {
    var dateTime = String()
    var dateStr = String()
    var orderDate = NSDate()
    var endDate = NSDate()
    var startTime = String()
    var endTime = String()
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }

    
    @IBOutlet weak var eventTitle: UITextField!
    
    
    @IBOutlet weak var eventSum: UITextField!
    
    
    @IBAction func startAction(sender: AnyObject) {
        
        self.performSegueWithIdentifier("sendtodate", sender: self)
    }

    @IBAction func endAction(sender: AnyObject) {
        
        self.performSegueWithIdentifier("sendtodate", sender: self)
    }
@IBOutlet var start: UIButton!


   
@IBOutlet var end: UIButton!
  

    var eventPublic:Bool = true
    var onsite:Bool = true
    
    var food:Bool = true
    
    var paid:Bool = false
    
    
   
    
    @IBAction func publicEvent(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            eventPublic = true
        case 1:
            eventPublic = false
            
        default:
            eventPublic = false
            break;
        }  //Switch
        
        
        
    }
    
    
    
    
    @IBAction func location(sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            onsite = true
        case 1:
            onsite = false
            
        default:
            onsite = false
            break;
        }  //Switch
    
        }
   
    
    @IBAction func isFood(sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            food = true
        case 1:
            food = false
            
        default:
            food = false
            break;
        }  //Switch
        
    }
   
   
    @IBAction func isPaid(sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            paid = true
        case 1:
            paid = false
            
        default:
            paid = false
            break;
        }  //Switch
        
    }
    
        @IBAction func makeEvent(sender: AnyObject) {
            
            var userFollowers = [String]()
           var allError = ""
            
            if eventTitle.text == "" {
                
                allError = "Enter a Title for your Event"
                
            }
            
            if eventSum.text == ""{
                
                allError = "Enter a location for your Event"
            }
            
        
            println(allError)
            
            if allError == "" {
            var event = PFObject(className: "Event")
            
            
            event["startEvent"] = orderDate1
            event["endEvent"] = orderDate2
            event["startTime"] = dateTime1 as String
            event["startDate"] = dateStr1 as String
            event["endTime"] = dateTime2 as String
            event["endDate"] = dateStr2 as String
            event["eventTime"] = dateTime2 as String
            event["public"] = eventPublic
            event["food"] = food
            event["paid"] = paid
            event["location"] = onsite
            event["eventLocation"] = eventSum.text
            event["eventTitle"] = eventTitle.text
            event["author"] = PFUser.currentUser().username
            event.saveInBackgroundWithBlock{
            
                (success:Bool!,eventError:NSError!) -> Void in
            
                if (eventError == nil){
                    
           
                    
                    var push =  PFPush()
                    push.setChannel(PFUser.currentUser().username)
                    push.setMessage("This is the push message")
                    push.sendPushInBackgroundWithBlock({
                        
                        (success: Bool!, pushError: NSError!) -> Void in
                        if pushError == nil {
                            
                            println("the push was sent")
                            
                        }
                        
                        
                        
                    })
                    
                            var notify = PFObject(className: "Notification")
                            notify["sender"] = PFUser.currentUser().username
                            notify["receiver"] = PFUser.currentUser().username
                            notify["type"] =  "event"
                            notify.saveInBackgroundWithBlock({
                                (success:Bool!, notifyError: NSError!) -> Void in
                                if notifyError == nil {
                                    println("notifcation has been saved")
                                }
                                else {
                                    println("fail")
                                }
                            })
                    self.performSegueWithIdentifier("eventback", sender: self)
                    println("it worked")

                    }
                }
 
            }
    }
    
  override func viewDidAppear(animated: Bool) {
    if (startString == ""){
        
        start.setTitle("Start Time", forState: UIControlState.Normal)
    
    }
    else {
        start.setTitle(startString, forState: UIControlState.Normal)
        
        
    }
    if (endString == "") {
        
        end.setTitle("End Time", forState: UIControlState.Normal)
        
    }
    else {
        end.setTitle(endString, forState: UIControlState.Normal)
    }
    
    
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
       start.setTitle("Start Time", forState: UIControlState.Normal)
        
        end.setTitle("End Time", forState: UIControlState.Normal)
        
       // if start.text != "start time" {
            
        
            
      //  }
        
      //  if end.text != "end time" {
            
        
       // }
        
        if PFUser.currentUser() == nil{
            
            self.performSegueWithIdentifier("register", sender: self)
            
        }
        // Do any additional setup after loading the view.
    }

   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
