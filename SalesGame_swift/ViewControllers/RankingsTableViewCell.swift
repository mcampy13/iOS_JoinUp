//
//  RankingsTableViewCell.swift
//  SalesGame_swift
//
//  Created by Robert Rock on 12/10/15.
//  Copyright © 2015 Akshay. All rights reserved.
//

import UIKit

class RankingsTableViewCell: UITableViewCell {

    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
