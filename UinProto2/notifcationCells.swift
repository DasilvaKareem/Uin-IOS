//
//  notifcationCellsTableViewCell.swift
//  UinProto2
//
//  Created by Kareem Dasilva on 2/14/15.
//  Copyright (c) 2015 Kareem Dasilva. All rights reserved.
//

import UIKit

class subCell: UITableViewCell {

    @IBOutlet var subNotify: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
class memberCell: UITableViewCell {
    
    @IBOutlet var memberNotify: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
class eventMakeCell: UITableViewCell {
    
    @IBOutlet var eventNotify: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
class calendarCell: UITableViewCell {
    
    @IBOutlet var calendarNotify: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
