//
//  AllCategoryViewController.swift
//  SalesGame_swift
//
//  Created by Akuma on 9/11/15.
//  Copyright (c) 2015 Akuma. All rights reserved.
//

import UIKit

class AllCategoryViewController: UIViewController {

    @IBOutlet weak var tblObj : UITableView!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var categoryCollectionViewButton: UIButton!
    
    var arrayCategory:AnyObject?
    var array: NSMutableArray! = []
    
    var strMainCategory: String?
    var PFMainCategory: PFObject?
    
    var PFCategoryArray = [PFObject]()
    
    var Game: PFObject!

//==========================================================================================================================

// MARK: Life Cycle methods

//==========================================================================================================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor.orangeColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationItem.title = "Categories"
        
        NSThread .detachNewThreadSelector("showhud", toTarget: self, withObject: nil)
        self.queryCategories()
        
        self.navigationItem.backBarButtonItem = nil
    }
    
    //method for getting all category
    func queryCategories() {
        let query = PFQuery(className: "Category")
        query.limit = 1000;
        
        query.findObjectsInBackgroundWithBlock { (objArray, error) -> Void in
            if error == nil {
                self.arrayCategory = objArray;
                
                let obj:PFObject = (self.arrayCategory as! Array)[0];
                self.array.addObject(obj)
                self.PFCategoryArray.append(obj)
                self.tblObj .reloadData()
                hideHud(self.view)
            } else {
                NSLog("error=%@",error!);
            }
        }
    } //END of queryForTable()
    
    
//==========================================================================================================================
    
// MARK: Navigation
    
//==========================================================================================================================

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueShowCategory" {
            
            //let indexPaths = self.tblObj!.indexPathsForSelectedItems()!
            //let indexPath = indexPaths[0] as NSIndexPath
            
            let showCategoryVC = segue.destinationViewController as! ShowCategoryViewController
            
//            if let selectedSubCategoryCell = sender as? UITableViewCell {
//                let indexPath = self.tblView.indexPathForCell(selectedSubCategoryCell)!
//                
//                let selectedSubCategory: PFObject = (self.holder as! Array)[indexPath.row]
//                self.subCategoryPFObj = selectedSubCategory
//                subCategoryInfoDestinationVC?.subCategoryPFObj = selectedSubCategory
//            }
            
            if let selectedCategoryCell = sender as? UITableViewCell {
                let indexPath = self.tblObj.indexPathForCell(selectedCategoryCell)!
                let obj:PFObject = self.array.objectAtIndex(indexPath.row) as! PFObject
                
                let game = PFObject(className: "Game")
                print("game: \(game)")
                game["player"] = PFUser.currentUser()!
                game["category"] = obj
                self.Game = game
                
                showCategoryVC.title = obj.valueForKey("categoryName") as? String
                showCategoryVC.strMainCategory = obj.objectId as String!
                showCategoryVC.game = game
                
                let categoryFile = obj.valueForKey("categoryFile") as? PFFile
                categoryFile?.getDataInBackgroundWithBlock{ (imageData, error) -> Void in
                    if error == nil {
                        if let imageData = imageData {
                            showCategoryVC.imageView?.image = UIImage(data: imageData)
                        }
                    } else{
                        print("Error in prepareForSegue categoryFile: \(error)")
                    }
                }
                
            } else if segue.identifier == "segueSearchCategory" {
                if let selectedCategoryCell = sender as? UITableViewCell {
                    let indexPath = self.tblObj.indexPathForCell(selectedCategoryCell)!
                    let selectedCategory: PFObject = (self.arrayCategory as! Array)[indexPath.row]
                    print("segue id == segueSearchCategory selectedCategory: \(selectedCategory)")
                }
            }
        }
    }
    
//==========================================================================================================================

// MARK: Table datasource and delegate methods
    
//==========================================================================================================================
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.arrayCategory == nil) {
            return 0
        } else {
            return self.arrayCategory!.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tblObj.dequeueReusableCellWithIdentifier("cell")
        let obj:PFObject = (self.arrayCategory as! Array)[indexPath.row];
        cell!.textLabel?.text = obj.objectForKey("categoryName") as? String
        return cell!
    }
    
//==========================================================================================================================

// MARK: Actions

//==========================================================================================================================
    
    @IBAction func categoryCollectionViewButtonTap(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
//==========================================================================================================================

// MARK: Progress hud display methods

//==========================================================================================================================
    func showhud() {
        showHud(self.view)
    }
}
