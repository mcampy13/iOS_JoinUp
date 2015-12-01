//
//  CategoryInfoViewController.swift
//  SalesGame_swift
//
//  Created by Robert Rock on 12/1/15.
//  Copyright © 2015 Akshay. All rights reserved.
//

import UIKit

class CategoryInfoViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var categoryLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor.orangeColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        
        
    }

    
    //==========================================================================================================================
    
    // MARK: Navigation
    
    //==========================================================================================================================

    
    @IBAction func unwindFromSearchCategory(sender: UIStoryboardSegue){
        if let sourceViewController = sender.sourceViewController as? SearchCategoryViewController, fromCategory = sourceViewController.selectedString {
            self.categoryLabel?.text = fromCategory
            print("fromCategory: \(fromCategory)")
        }
    }
    

}
