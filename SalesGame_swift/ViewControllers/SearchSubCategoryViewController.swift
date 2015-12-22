//
//  SearchSubCategoryViewController.swift
//  SalesGame_swift
//
//  Created by Robert Rock on 11/16/15.
//  Copyright © 2015 Akshay. All rights reserved.
//

import UIKit

class SearchSubCategoryViewController: UIViewController, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating{

    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var toolBar: UIToolbar!
    
    var filteredSubCategories = [String]()
    var resultSearchController = UISearchController()
    
    var subCategories: NSMutableArray = []
    var holder: AnyObject?
    var parent: AnyObject?
    
    var mainCategoryPF: PFObject?
    var subCategoryPFObj: PFObject?
    var game: PFObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor.orangeColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        self.resultSearchController = UISearchController(searchResultsController: nil)
        self.resultSearchController.searchResultsUpdater = self
        self.resultSearchController.dimsBackgroundDuringPresentation = false
        self.resultSearchController.searchBar.sizeToFit()
        
        querySubCategories()
        
        self.tblView.tableHeaderView = self.resultSearchController.searchBar
        self.tblView.reloadData()
    
    }
    
    
    //==========================================================================================================================
    
    // MARK: Navigation
    
    //==========================================================================================================================
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
<<<<<<< HEAD
        if segue.identifier == "segueSubCategoryInfo" {
            let subCategoryInfoDestinationVC = segue.destinationViewController as? SubCategoryInfoViewController
            
            if let selectedSubCategoryCell = sender as? UITableViewCell {
                let indexPath = self.tblView.indexPathForCell(selectedSubCategoryCell)!
                
                let selectedSubCategory: PFObject = (self.holder as! Array)[indexPath.row]
                let selectedCategory: PFObject = (self.parent as! Array)[indexPath.row]
                
                self.subCategoryPFObj = selectedSubCategory
                subCategoryInfoDestinationVC?.subCategoryPFObj = selectedSubCategory
                subCategoryInfoDestinationVC?.categoryPFObj = selectedCategory
                subCategoryInfoDestinationVC?.game = self.game
            }
        }
    }
    
    func querySubCategories(){
=======
        if segue.identifier == "segueStartGame" {
            if let selectedSubCategoryCell = sender as? UITableViewCell {
                let indexPath = self.tblView.indexPathForCell(selectedSubCategoryCell)!
                
                let navSelectSubCategoryVC = segue.destinationViewController as! UINavigationController
                let selectSubCategoryVC = storyboard?.instantiateViewControllerWithIdentifier("SelectSubCategoryViewController") as! SelectSubCategoryViewController
                
                
                let selectedSubCategory: PFObject = (self.holder as! Array)[indexPath.row]
                let selectedCategory: PFObject = (self.parent as! Array)[indexPath.row]
                
                game!["subCategory"] = selectedSubCategory
                
                selectSubCategoryVC.title = selectedSubCategory["subCategoryName"] as? String
                selectSubCategoryVC.categoryPFObj = selectedCategory
                selectSubCategoryVC.subCategoryPFObj = selectedSubCategory
                selectSubCategoryVC.game = self.game
                
                let categoryFile = selectedCategory["categoryFile"] as? PFFile
                categoryFile?.getDataInBackgroundWithBlock { (imageData, error) -> Void in
                    if error == nil {
                        if let imageData = imageData {
                            selectSubCategoryVC.subCategoryImageView?.image = UIImage(data: imageData)
                        }
                    } else {
                        print("Error in categoryFile getDataInBackground: \(error)")
                    }
                }
                navSelectSubCategoryVC.pushViewController(selectSubCategoryVC, animated: true)
            }
        }
        
    } // END of prepareForSegue()
    
    
    func querySubCategories() {
>>>>>>> d6e906b4510cf39f9ffcbdd178848ad1fce0298e
        let query = PFQuery(className: "SubCategory")
        let queryParent = PFQuery(className: "Category")
        queryParent.limit = 1000
        queryParent.whereKey("objectId", equalTo: self.mainCategoryPF!.objectId!)
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
            } else {
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
        let cell = tblView!.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        if self.resultSearchController.active {
            cell.textLabel?.text = self.filteredSubCategories[indexPath.row]
        } else {
            cell.textLabel?.text = self.subCategories[indexPath.row] as? String
        }
        
        return cell
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
    
    

    //==========================================================================================================================
    
    // MARK: Progress hud display methods
    
    //==========================================================================================================================
    
    func showhud() {
        showHud(self.view)
    }
    
    
}
