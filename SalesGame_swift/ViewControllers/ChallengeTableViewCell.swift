//
//  ChallengeTableViewCell.swift
//  SalesGame_swift
//
//  Created by Robert Rock on 10/21/15.
//  Copyright © 2015 Akshay. All rights reserved.
//

import UIKit

class ChallengeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var buttonLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
