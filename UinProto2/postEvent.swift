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
 
    @IBOutlet weak var eventSum: UILabel!
    
    var storeTitle = String()
    
    var storeLocation = String()
    
    var storeTime = String()
    
    var storeDate = String()
    
    var storeSum = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       eventTitle.text = storeTitle
        //self.example.text = self.data
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
