//
//  CategoryTableViewCell.swift
//  SalesGame_swift
//
//  Created by Robert Rock on 11/1/15.
//  Copyright © 2015 Akshay. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    
    @IBOutlet weak var categoryTitle: UILabel!
    @IBOutlet weak var subLeftImage: UIButton!
    @IBOutlet weak var subLeftButton: UIButton!
    @IBOutlet weak var subLeftTitle: UILabel!
    
    @IBOutlet weak var subCenterImage: UIImageView!
    @IBOutlet weak var subCenterButton: UIButton!
    @IBOutlet weak var subCenterTitle: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }
    
    @IBAction func subLeftButton(sender: AnyObject) {
        UtilityClass.showAlert("Left")
    }
    
    @IBAction func subCenterButton(sender: AnyObject) {
        UtilityClass.showAlert("Center")
    }

}
