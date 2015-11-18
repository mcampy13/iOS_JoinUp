//
//  SearchSubCategoryViewController.swift
//  SalesGame_swift
//
//  Created by Robert Rock on 11/16/15.
//  Copyright © 2015 Akshay. All rights reserved.
//

import UIKit

class SearchSubCategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating{

    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    var filteredSubCategories = [String]()
    var resultSearchController = UISearchController()
    
    var subCategories: NSMutableArray = []
    var holder: AnyObject?
    var parent: AnyObject?
    
    var strMainCategory: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        querySubCategories()
        
        self.resultSearchController = UISearchController(searchResultsController: nil)
        self.resultSearchController.searchResultsUpdater = self
        self.resultSearchController.dimsBackgroundDuringPresentation = false
        self.resultSearchController.searchBar.sizeToFit()
        
        self.tblView.tableHeaderView = self.resultSearchController.searchBar
        self.tblView.reloadData()
        
    }

    func querySubCategories(){
        let query = PFQuery(className: "SubCategory")
        let queryParent = PFQuery(className: "Category")
        queryParent.limit = 1000
        queryParent.whereKey("objectId", equalTo: strMainCategory)
        queryParent.findObjectsInBackgroundWithBlock{ (parentObjs, error) -> Void in
            if error == nil {
                self.parent = parentObjs
                let obj:PFObject = (self.parent as! Array)[0];
                
                query.whereKey("parentCategory", equalTo: obj)
                query.limit = 1000;
                query.findObjectsInBackgroundWithBlock { (success, error) -> Void in
                    if error == nil {
                        self.holder = success
                        
                        for var i=0; i < self.holder!.count; i++ {
                            let subObj:PFObject = (self.holder as! Array)[i];
                            self.subCategories.addObject(subObj.valueForKey("subCategoryName")!)
                            //self.tblView.reloadData()
                        }
                    } else {
                        print("Error in query: \(error)")
                    }
                }
            }
            else {
                print("Error in queryParent: \(error)")
            }
        }
    } // END of querySubCategories()
    
    
    //==========================================================================================================================
    
    // MARK: Table datasource and delegate methods
    
    //==========================================================================================================================
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.resultSearchController.active {
            return self.filteredSubCategories.count
        } else {
            return self.subCategories.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tblView!.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as? UITableViewCell
        
        if self.resultSearchController.active {
            cell!.textLabel?.text = self.filteredSubCategories[indexPath.row]
        } else {
            cell!.textLabel?.text = self.subCategories[indexPath.row] as! String
        }
        
        return cell!
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        self.filteredSubCategories.removeAll(keepCapacity: false)
        
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        
        let array = (self.subCategories as NSArray).filteredArrayUsingPredicate(searchPredicate)
        
        // casts array back into array of Strings b/c above we cast to NSArray, placing the value in the filteredSubCategories array
        self.filteredSubCategories = array as! [String]
        
        self.tblView.reloadData()
        
    }
    
    
    
    //==========================================================================================================================
    
    // MARK: Actions
    
    //==========================================================================================================================
    
    @IBAction func backButton(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    

    //==========================================================================================================================
    
    // MARK: Progress hud display methods
    
    //==========================================================================================================================
    
    func showhud() {
        showHud(self.view)
    }

    
    
    
    
}
