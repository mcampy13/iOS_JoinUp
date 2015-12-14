//
//  SubCategoryInfoViewController.swift
//  SalesGame_swift
//
//  Created by Robert Rock on 12/1/15.
//  Copyright © 2015 Akshay. All rights reserved.
//

import UIKit

class SubCategoryInfoViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var subCategoryImg: UIImageView!
    
    var subCategoryPFObj: PFObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.barTintColor = UIColor.orangeColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationItem.title = self.subCategoryPFObj?.valueForKey("subCategoryName") as? String
        
        let subCategoryFile = subCategoryPFObj!.objectForKey("subCategoryFile") as? PFFile
        subCategoryFile?.getDataInBackgroundWithBlock{ (imageData, error) -> Void in
            if error == nil{
                if let imageData = imageData {
                    self.subCategoryImg!.image = UIImage(data: imageData)
                }
            } else{
                print("Error in getDataInBackgroundWithBlock \(error)")
            }
        }
        
    }
    
    
    //==========================================================================================================================
    
    // MARK: Navigation
    
    //==========================================================================================================================

    
    
}
