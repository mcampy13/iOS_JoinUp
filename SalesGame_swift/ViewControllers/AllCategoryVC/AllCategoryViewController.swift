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
    
    var arrayCategory:AnyObject?
    var array: NSMutableArray! = []
    
    var strMainCategory: String?

//==========================================================================================================================

// MARK: Life Cycle methods

//==========================================================================================================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor.orangeColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]

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
        if segue.identifier == "gotoSubCategory" {
            let subCategoryViewController = segue.destinationViewController as? SubCategoryViewController
            
            if let selectedCategoryCell = sender as? UITableViewCell {
                let indexPath = self.tblObj.indexPathForCell(selectedCategoryCell)!
                let selectedCategory:PFObject = (self.arrayCategory as! Array)[indexPath.row]
                print("selectedCategory: \(selectedCategory)")
                
                self.strMainCategory = selectedCategory.objectId
                subCategoryViewController?.strMainCategory = selectedCategory.objectId as String!
                print("selectedCategory id \(selectedCategory.objectId)")
                
                let game = PFObject(className: "Game")
                print("game: \(game)")
                game["player"] = PFUser.currentUser()!
                game["category"] = selectedCategory
                subCategoryViewController?.game = game
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

//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let subCategoryVC = self.storyboard?.instantiateViewControllerWithIdentifier("SubCategoryViewController") as? SubCategoryViewController
//        let obj:PFObject = (self.arrayCategory as! Array)[indexPath.row];
//        subCategoryVC?.strMainCategory = obj.objectId
//        let game = PFObject(className: "Game")
//        game["player"] = PFUser.currentUser()!
//        game["category"] = obj
//        subCategoryVC?.game = game
//
//        self.navigationController!.pushViewController(subCategoryVC!, animated:true)
//    }
    
    
    
//==========================================================================================================================

// MARK: Actions

//==========================================================================================================================
    
    @IBAction func cancelButton(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func searchButton(sender: AnyObject) {
        let searchCategoryVC = self.storyboard?.instantiateViewControllerWithIdentifier("SearchCategoryViewController") as! SearchCategoryViewController
        self.navigationController?.pushViewController(searchCategoryVC, animated: true)
    }
    
    
//==========================================================================================================================

// MARK: Progress hud display methods

//==========================================================================================================================
    func showhud() {
        showHud(self.view)
    }
}
