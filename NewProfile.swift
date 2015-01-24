//
//  NewProfile.swift
//  UinProto2
//
//  Created by Kareem Dasilva on 1/24/15.
//  Copyright (c) 2015 Kareem Dasilva. All rights reserved.
//

import UIKit

class NewProfile: UIViewController, UITableViewDelegate {

    @IBOutlet weak var orgName: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        orgName.text = PFUser.currentUser().username
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}