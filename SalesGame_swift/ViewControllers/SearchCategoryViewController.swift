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
    
    var anyObj: AnyObject!
    var allCategories: NSMutableArray! = []
    var filteredCategories: NSMutableArray! = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let queryCategory = PFQuery(className: "Category")
        queryCategory.findObjectsInBackgroundWithBlock{ (success, error) -> Void in
            if error == nil {
                
                for var i=0; i < success!.count; i++ {
                    self.anyObj = success
                    let obj: PFObject = (self.anyObj as! Array)[i];
                    self.allCategories.addObject(obj)
                }
                
                self.searchTableView.reloadData()
                
            } else{
                print("Error in queryCategory: \(error)")
            }
        }
    }

    
    // MARK: Table
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.searchDisplayController?.searchResultsTableView {
            return self.filteredCategories.count
        } else {
            return self.allCategories.count
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.searchTableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        
        
//        if tableView == self.searchDisplayController?.searchResultsTableView {
//            cat = self.filteredCategories[indexPath.row]
//        } else {
//            cat = self.allCategories[indexPath.row]
//        }
        
        return cell
    }
    
    
}
