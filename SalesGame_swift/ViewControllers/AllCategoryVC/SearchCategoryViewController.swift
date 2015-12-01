//
//  SearchCategoryViewController.swift
//  SalesGame_swift
//
//  Created by Robert Rock on 11/16/15.
//  Copyright © 2015 Akshay. All rights reserved.
//

import UIKit

class SearchCategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate {

    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var toolBarView: UIToolbar!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    var filteredCategories = [String]()
    var resultSearchController = UISearchController()
    
    var categories: NSMutableArray = []
    var holder: AnyObject?
    
    var selectedString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor.orangeColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        queryCategories()
        
        self.resultSearchController = UISearchController(searchResultsController: nil)
        self.resultSearchController.searchResultsUpdater = self
        self.resultSearchController.dimsBackgroundDuringPresentation = false
        self.definesPresentationContext = true
        self.resultSearchController.searchBar.sizeToFit()
        
        self.tblView.tableHeaderView = self.resultSearchController.searchBar
        
        self.tblView.reloadData() // adds searchBar to tblView
        
    }
    
    func queryCategories(){
        let query = PFQuery(className: "Category")
        query.findObjectsInBackgroundWithBlock{ (success, error) -> Void in
            if error == nil {
                self.holder = success
                for var i=0; i < self.holder!.count; i++ {
                    let obj: PFObject = (self.holder as! Array)[i]
                    self.categories.addObject(obj.valueForKey("categoryName")!)
                }
                
                print("categories: \(self.categories)")
            } else{
                print("Error \(error)")
            }
        }
    }
    
    func displayAlert(title: String, error: String){
        let alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: {action in
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }

    
//==========================================================================================================================
    
// MARK: Navigation
    
//==========================================================================================================================
    
    @IBAction func unwindFromAllCategory(sender: UIStoryboardSegue){
        if let sourceViewController = sender.sourceViewController as? AllCategoryViewController, fromCategory = sourceViewController.PFCategoryArray as? [PFObject] {
            
            let indexPath = NSIndexPath(forRow: categories.count, inSection: 0)
            for var i=0; i < fromCategory.count; i++ {
                self.tblView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Bottom)
//                searchCategoryCell.textLabel?.text = fromCategory[i].valueForKey("categoruName") as! String
            }
            
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "gotoCategoryInfo" {
            let categoryInfoDestinationVC = segue.destinationViewController as? CategoryInfoViewController
            
            if let selectedCategoryCell = sender as? UITableViewCell {
                let indexPath = self.tblView.indexPathForCell(selectedCategoryCell)!
                
                let selectedCategory: PFObject = (self.holder as! Array)[indexPath.row]
                self.selectedString = selectedCategory.valueForKey("categoryName") as! String
                print("selectedCategory in prepareForSegue: \(selectedCategory)")
                
            }
        }
    }
    
    
//==========================================================================================================================
    
// MARK: Table datasource and delegate methods
    
//==========================================================================================================================
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.resultSearchController.active {
            return self.filteredCategories.count
        } else {
            return self.categories.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell?
        
        if self.resultSearchController.active {
            cell!.textLabel?.text = self.filteredCategories[indexPath.row]
        } else {
            cell!.textLabel?.text = self.categories[indexPath.row] as? String
        }
        
        return cell!
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        // removes all items from filteredCategories array
        self.filteredCategories.removeAll(keepCapacity: false)
        
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        let array = (self.categories as NSArray).filteredArrayUsingPredicate(searchPredicate)
        
        // casts array back into array of Strings b/c above we cast to NSArray, placing the value in the filteredCategories array
        self.filteredCategories = array as! [String]
        
        self.tblView.reloadData()
    
    }
    
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
    }
    
    
    //==========================================================================================================================
    
    // MARK: Actions
    
    //==========================================================================================================================
    
    
    //==========================================================================================================================
    
    // MARK: Progress hud display methods
    
    //==========================================================================================================================
    
    func showhud() {
        showHud(self.view)
    }

    
    
}
