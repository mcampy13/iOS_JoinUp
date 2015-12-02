//
//  CategoryInfoViewController.swift
//  SalesGame_swift
//
//  Created by Robert Rock on 12/1/15.
//  Copyright © 2015 Akshay. All rights reserved.
//

import UIKit

class CategoryInfoViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var categoryImg: UIImageView!
    
    var categoryPFObj: PFObject?
    var holder: AnyObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor.orangeColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        print("obj in viewDidLoad: \(self.categoryPFObj)")
        
        self.navigationItem.title = self.categoryPFObj!.valueForKey("categoryName") as? String
        //queryCategory()
        
        let categoryFile = self.categoryPFObj?.objectForKey("categoryFile") as? PFFile
        categoryFile?.getDataInBackgroundWithBlock{ (imageData, error) -> Void in
            if error == nil {
                if let imageData = imageData {
                    self.categoryImg!.image = UIImage(data: imageData)
                }
            } else{
                print("Error in categoryFile.getData: \(error)")
            }
        }

        
    }
    
    
//    func queryCategory() {
//        let query = PFQuery(className: "Category")
//        query.whereKey("objectId", equalTo: self.categoryPFObj!.objectId!)
//        query.findObjectsInBackgroundWithBlock { (success, error) -> Void in
//            if error == nil {
//                self.holder = success
//                print("holder: \(self.holder)")
//            } else {
//                print("Error in queryCategory: \(error)")
//            }
//        }
//    }


    //==========================================================================================================================
    
    // MARK: Navigation
    
    //==========================================================================================================================

    
//    @IBAction func unwindFromSearchCategory(sender: UIStoryboardSegue){
//        if let sourceViewController = sender.sourceViewController as? SearchCategoryViewController, fromCategory = sourceViewController.selectedCategoryToPass {
//
//            self.categoryPFObj = fromCategory
//        }
//    }
    

}
