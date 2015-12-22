//
//  GameHistoryTableViewCell.swift
//  SalesGame_swift
//
//  Created by Robert Rock on 11/18/15.
//  Copyright © 2015 Akshay. All rights reserved.
//

import UIKit

class GameHistoryTableViewCell: UITableViewCell {

    
    @IBOutlet weak var labelCategoryTitle: UILabel!
    @IBOutlet weak var labelSubCategoryTitle: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
