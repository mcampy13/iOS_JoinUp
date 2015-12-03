//
//  SubCategoryViewController.swift
//  SalesGame_swift
//
//  Created by Robert Rock on 10/19/15.
//  Copyright © 2015 Akshay. All rights reserved.
//

import UIKit

class SubCategoryViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var subCategoryTableView: UITableView!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    
    var subCategories: AnyObject?
    var parent: AnyObject?
    var subArray: NSMutableArray = []
    
    var strMainCategory : String?
    var stringSubCategory: String?
    
    var testValue: String?
    
    var game: PFObject!

    var PFSubCategory: PFObject?
    var PFCategory: PFObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("in SubCategoryVC strMainCateogyry: \(self.strMainCategory)")

        self.navigationController?.navigationBar.barTintColor = UIColor.orangeColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]

        NSThread .detachNewThreadSelector("showhud", toTarget: self, withObject: nil)
        self.querySubCategories()
    }

    //method for getting sub-category
    func querySubCategories() {
        
        let query = PFQuery(className: "SubCategory")
        
        let queryParent = PFQuery(className: "Category")
        queryParent.limit = 1000
//        queryParent.whereKey("objectId", equalTo: strMainCategory!)
        queryParent.whereKey("objectId", equalTo: self.PFCategory!.objectId!)
        queryParent.findObjectsInBackgroundWithBlock {  (parentObjs, error) -> Void in
            if error == nil {
                self.parent = parentObjs
                let obj:PFObject = (self.parent as! Array)[0]
                
                query.whereKey("parentCategory", equalTo: obj)
                query.limit = 1000;
                
                query.findObjectsInBackgroundWithBlock { (objArray, error) -> Void in
                    if error == nil {
                        self.subCategories = objArray
                        
//                        let subObj:PFObject = (self.subCategories as! Array)[0]
//                        self.subArray.addObject(subObj)
                        
                        for var i=0; i < self.subCategories!.count; i++ {
                            let subObj:PFObject = (self.subCategories as! Array)[i]
                            self.subArray.addObject(subObj)
                            print("subObj in query: \(subObj)")
                        }
                        print("subCategories: \(self.subCategories)")
                        print("subArray: \(self.subArray)")
                        self.subCategoryTableView.reloadData()
                        hideHud(self.view)
                    } else {
                        print("Error in query: \(error)")
                    }
                }
            }
            else {
                print("Error in queryParent: \(error)")
            }
        }
    } //END of querySubCategories()
    
    
    //==========================================================================================================================
    
    // MARK: Navigation
    
    //==========================================================================================================================
    
    @IBAction func cancelButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "gotoGameStart" {
            let gameStartConfirm = segue.destinationViewController as? SelectSubCategoryViewController
            
            if let selectedSubCategoryCell = sender as? UITableViewCell {
                let indexPath = self.subCategoryTableView.indexPathForCell(selectedSubCategoryCell)!
                let selectedSubCategory: PFObject = (self.subCategories as! Array)[indexPath.row]
                print("selectedSubCategory in SubCategory prepareForSegue: \(selectedSubCategory)")
                
                self.stringSubCategory = selectedSubCategory.objectId
                gameStartConfirm?.strMainCategory = self.strMainCategory
                gameStartConfirm?.strSubCategory = selectedSubCategory.objectId
                
                game["subCategory"] = selectedSubCategory
                gameStartConfirm?.game = self.game
                print("selectedSubCategory id in SubCategory prepareForSegue: \(selectedSubCategory.objectId)")
            }
        } else if segue.identifier == "gotoSearchSubCategory" {
            let searchSubCategoryVC = segue.destinationViewController as? SearchSubCategoryViewController
                
            searchSubCategoryVC?.strMainCategory = self.strMainCategory
            searchSubCategoryVC?.mainCategoryPF = self.PFCategory
            
            print("segue id == gotoSearchSubCategory strMainCategory: \(self.strMainCategory)")
            print("segue id == gotoSearchSubCategory PFCategory: \(self.PFCategory)")
        }
    }
    
    
    //==========================================================================================================================
    
    // MARK: Table datasource and delegate methods
    
    //==========================================================================================================================
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.subCategories == nil) {
            return 0
        } else {
            return self.subCategories!.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = subCategoryTableView.dequeueReusableCellWithIdentifier("cell")
        let obj:PFObject = (self.subCategories as! Array)[indexPath.row]
        //print("obj in cellForRowAtIndexPath: \(obj)")
        cell!.textLabel?.text = obj.objectForKey("subCategoryName") as? String
        return cell!
    }
    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {        
//        let selectSubCategoryVC = self.storyboard?.instantiateViewControllerWithIdentifier("SelectSubCategoryViewController") as? SelectSubCategoryViewController
//        let obj:PFObject = (self.parent as! Array)[indexPath.row]
//        
//        /* BUG: Regardless of Category, app crashes when you choose any other row except for the first row in
//         *  sub category table with error, 'NSArrayI objectAtIndex: index 1 beyond bounds [0 .. 0]'.  
//         *  I assume this is referencing that self.subCategories[indexPath.row] is somehow out of bounds, meaning
//         *  that it would have to be empty, or it literally only has index 0 ... Why would it only have index 0 of our 
//         *  row? 
//         *
//         * UPDATE: When even trying (self.subCategories as! Array)[0], I get the same error which must mean that 
//         *  it is referencing a different NSArray.
//         */
//        
//        let subPF: PFObject = (self.subCategories as! Array)[indexPath.row]
//        print("subPF in didSelectRow: \(subPF)")
//        
//        selectSubCategoryVC?.strMainCategory = obj.objectId
//        selectSubCategoryVC?.strSubCategory = subPF.objectId
//        game["subCategory"] = subPF
//        selectSubCategoryVC?.game = self.game
//        //selectSubCategoryVC?.PFSubCategory = subPF
//        self.navigationController!.pushViewController(selectSubCategoryVC!, animated:true)
//    }
    
    
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
