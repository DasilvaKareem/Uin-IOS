//
//  postEvent.swift
//  UinProto2
//
//  Created by Kareem Dasilva on 1/26/15.
//  Copyright (c) 2015 Kareem Dasilva. All rights reserved.
//

import UIKit

class postEvent: UIViewController {

 
    
    @IBOutlet weak var eventTitle: UILabel!
    
    @IBOutlet weak var location: UILabel!
    
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var date: UILabel!
 
    @IBOutlet weak var isFood: UIImageView!
    
    
    @IBOutlet weak var isSite: UIImageView!
    
    
    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var isPaid: UIImageView!
  
    var users = String()
    
    var storeTitle = String()
    
    var storeLocation = String()
    
    var storeTime = String()
    
    var storeDate = String()
    
    var storeSum = String()
    
    var data = Int()
    
    var onsite = Bool()
    
    var food = Bool()
    
    var  cost = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
       location.text = storeLocation
        
        eventTitle.text = storeTitle
        
        username.text = users
        
        time.text = storeTime
        
        date.text = storeDate
        putIcons()
        
    
        //self.example.text = self.data
        // Do any additional setup after loading the view.
    }
    
   
    
    func putIcons(){
        
        
        if  onsite == true {
            
            
            isSite.image = UIImage(named: "oncampusicon@3x.png")
         
            
            
            
        }
        else{
            
            isSite.image = UIImage(named: "offCampus@3x.png")
            
   
            
        }
        
        if food == true {
            
            
            isFood.image = UIImage(named: "foodicon@3x.png")
           
            
            
        }
        else{
            
            isFood.image = UIImage(named: "noFood@3x.png")
            
        
            
            
        }
        if cost == false {
            
            
            isPaid.image = UIImage(named: "freeicon@3x.png")
           
            
            
        }
        else{
            
            isPaid.image = UIImage(named: "noFree@3x.png")
            
            
        }
        
        
        
        
        
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
