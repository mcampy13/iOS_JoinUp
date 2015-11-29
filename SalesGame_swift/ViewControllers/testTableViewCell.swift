//
//  testTableViewCell.swift
//  SalesGame_swift
//
//  Created by Robert Rock on 11/28/15.
//  Copyright © 2015 Akshay. All rights reserved.
//

import UIKit

class testTableViewCell: UITableViewCell {

    
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
