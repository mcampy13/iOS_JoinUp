//
//  MenuTableViewCell.swift
//  SalesGame_swift
//
//  Created by Robert Rock on 11/22/15.
//  Copyright © 2015 Akshay. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    
    @IBOutlet weak var menuItemTitleLabel: UILabel!
    @IBOutlet weak var menuItemIconImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
