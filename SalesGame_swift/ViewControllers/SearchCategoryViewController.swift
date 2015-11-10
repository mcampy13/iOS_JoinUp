//
//  SearchCategoryViewController.swift
//  SalesGame_swift
//
//  Created by Robert Rock on 11/1/15.
//  Copyright © 2015 Akshay. All rights reserved.
//

import UIKit

class SearchCategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate{

    
    @IBOutlet weak var searchTableView: UITableView!
    
    var anyObj: AnyObject?
    var allCategories: NSMutableArray! = [] // contains all of our PFObjects from queryCategory aka all categories
    var filteredCategories: NSMutableArray! = []  // contains the string representations of the searched by categoryName
    var resultSearchController = UISearchController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.resultSearchController = ({
//            let controller = UISearchController(searchResultsController: nil)
//            controller.searchResultsUpdater = self
//            
//            return controller
//        })()
        
        let queryCategory = PFQuery(className: "Category")
        queryCategory.addAscendingOrder("createdAt")
        queryCategory.findObjectsInBackgroundWithBlock{ (success, error) -> Void in
            if error == nil {
                
                for var i=0; i < success!.count; i++ {
                    self.anyObj = success
                    let obj: PFObject = (self.anyObj as! Array)[i];
                    self.allCategories.addObject(obj)
                }
                print("allCategories \(self.allCategories!.valueForKey("categoryName"))")
                self.searchTableView.reloadData()
                
            } else{
                print("Error in queryCategory: \(error)")
            }
        }
        
    }

    
    
    //==========================================================================================================================
    // MARK: Table
    //==========================================================================================================================
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.resultSearchController.active {
            return self.filteredCategories.count
        } else {
            return self.allCategories.count
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.searchTableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) 
        
        if self.resultSearchController.active {
            UtilityClass.showAlert("active")
            cell.textLabel?.text = self.filteredCategories[indexPath.row].valueForKey("categoryName") as? String
            return cell
        } else {
            cell.textLabel?.text = self.allCategories[indexPath.row].valueForKey("categoryName") as? String
            return cell
        }
        
    }
    
//    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
//        
//        tableView.deselectRowAtIndexPath(indexPath, animated: true)
//
//    }
    
    
    
    //==========================================================================================================================
    // MARK: Search
    //==========================================================================================================================
    
    
    
    
    //==========================================================================================================================
    // MARK: Actions
    //==========================================================================================================================
    
    @IBAction func backButton(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
