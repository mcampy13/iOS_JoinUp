//
//  CategoryViewController.swift
//  SalesGame_swift
//
//  Created by Robert Rock on 11/1/15.
//  Copyright © 2015 Akshay. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var categoryTableView: UITableView!
    
    var obj: PFObject!
    var object: AnyObject?
    var categories: NSMutableArray! = []
    
    var subObject: AnyObject?
    var subs: NSMutableArray! = []
    
    var strMainCategory: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        queryCategory()
    }
    
    
    func queryCategory(){
        let query = PFQuery(className: "Category")
        query.limit = 10;
        
        let querySubs = PFQuery(className: "SubCategory")
        querySubs.limit = 3
        
        query.findObjectsInBackgroundWithBlock { (objArray, error) -> Void in
            if error == nil {
                self.object = objArray
                
                for var i=0; i < objArray!.count; i++ {
                    self.obj = (self.object as! Array)[i];
                    self.categories.addObject(self.obj)
                    self.strMainCategory = (String(self.obj.valueForKey("categoryName")))
                    
                    querySubs.whereKey("parentCategory", equalTo: self.obj)
                    querySubs.findObjectsInBackgroundWithBlock { (success, error) -> Void in
                        if error == nil {
                            self.subObject = success
                            
                            for var j=0; j < success!.count; j++ {
                                let subPFObject: PFObject = (self.subObject as! Array)[j]
                                self.subs.addObject(subPFObject)
                            }
                            print("subs: \(self.subs)")
                            self.categoryTableView.reloadData()
                            hideHud(self.view)
                        } else {
                            print("Error querying for Subs: \(error)")
                        }
                    }
                }

            } else{
                print("Error in queryCategory: \(error)")
            }
        } // END of querying for categories in background
        
    }
    


    
    //==========================================================================================================================
    // MARK: Table View
    //==========================================================================================================================

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.categories.count == 0 {
            return 0
        } else {
            return self.categories.count
        }
    }
    

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.categoryTableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CategoryTableViewCell
        cell.categoryTitle.text = self.categories.objectAtIndex(indexPath.row).valueForKey("categoryName") as? String
        cell.subLeftTitle.text = self.subs.objectAtIndex(indexPath.row).valueForKey("subCategoryName") as? String
        cell.subCenterTitle.text = self.subs[1].valueForKey("subCategoryName") as? String

        return cell
        
    }
    
    
    
    
    
}
