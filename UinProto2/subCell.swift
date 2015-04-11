//
//  notifcationCellsTableViewCell.swift
//  UinProto2
//
//  Created by Kareem Dasilva on 2/14/15.
//  Copyright (c) 2015 Kareem Dasilva. All rights reserved.
//

import UIKit

class subCell: UITableViewCell {
   
    @IBOutlet weak var notifyMessage: UILabel!
    
    @IBOutlet var timeStamp: UILabel!
    @IBOutlet var noteImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

