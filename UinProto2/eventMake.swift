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
    
    
   
    @IBOutlet var start: UILabel!
    

    @IBOutlet var end: UILabel!

    var eventPublic:Bool = true
    var onsite:Bool = true
    
    var food:Bool = true
    
    var paid:Bool = false
    
    
   
    
    @IBAction func publicEvent(sender: UISegmentedControl) {
        
        if UISegmentedControlNoSegment == 1 {
            
            eventPublic = true
            
            
        }
        
        else {
            
            
            eventPublic = false
        }

        
        
        
    }
    
    
    
    
    @IBAction func location(sender: UISegmentedControl) {
        
        if UISegmentedControlNoSegment == 1 {
            
            onsite = true
            
            
        }
        else {
            
            onsite = false
            
        }
        
    
        }
   
    
    @IBAction func isFood(sender: UISegmentedControl) {
        
        if UISegmentedControlNoSegment == 1 {
            
            food = true
            
        }
        else {
            
            food = false
            
        }
        
        
    }
   
   
    @IBAction func isPaid(sender: UISegmentedControl) {
        
        
        if UISegmentedControlNoSegment == 1 {
            
            paid = false
            
        }
        else {
            
            paid = true
            
        }
        
        
    }
    
        @IBAction func makeEvent(sender: AnyObject) {
            
     
           var allError = ""
            
            if eventTitle.text == "" {
                
                allError = "Enter a Title for your Event"
                
            }
            
            if eventSum.text == ""{
                
                allError = "Enter a location for your Event"
            }
            
        
            println(allError)
            
            if allError == "" {
                
            var empty = ""
            var event = PFObject(className: "event")
            println(dateStr)
            event["public"] = eventPublic
            event["endDate"] = orderDate1
            event["dateTime"] = orderDate2
            event["time"] = dateTime1 as String
            event["date"] = dateStr1 as String
            event["eventTime"] = dateTime2 as String
            
            event["food"] = food
            event["paid"] = paid
            event["location"] = onsite
            event["sum"] = eventSum.text
            event["title"] = eventTitle.text
            event["user"] = PFUser.currentUser().username
            event.saveInBackgroundWithBlock{
            
                (success:Bool!,eventError:NSError!) -> Void in
            
                if (eventError == nil){
                
                    self.performSegueWithIdentifier("eventback", sender: self)
                    println("it worked")
                
                
                
                }
                
                else {
                
                    println("nah")
                
                }
            
            
            
            }
        
            }
        
    }
    
  override func viewDidAppear(animated: Bool) {
    if (startString == ""){
        
        start.text = "Start Time"
    
    }
    else {
          start.text = startString
        
        
    }
    if (endString == "") {
        
        end.text = "End Time"
        
    }
    else {
        end.text = endString
    }
    
    
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
       start.text = "Start Time"
        
        end.text = "End Time"
        
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
