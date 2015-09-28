//
//  eventCell.swift
//  UinProto2
//
//  Created by Kareem Dasilva on 1/9/15.
//  Copyright (c) 2015 Kareem Dasilva. All rights reserved.
//

import UIKit



class eventCell: UITableViewCell {

    

    @IBOutlet var tag2Text: UILabel!
    @IBOutlet weak var tag3Text: UILabel!
    @IBOutlet weak var tag1Text: UILabel!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var privateImage: UIImageView!
    @IBOutlet weak var tag1: UIImageView!
    @IBOutlet weak var tag2: UIImageView!
    @IBOutlet weak var tag3: UIImageView!
    @IBOutlet weak var uinBtn: UIButton!
    @IBOutlet weak var people: UILabel!
    @IBOutlet weak var time: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
