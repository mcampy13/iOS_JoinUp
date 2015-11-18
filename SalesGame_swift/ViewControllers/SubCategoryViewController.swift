//
//  SubCategoryViewController.swift
//  SalesGame_swift
//
//  Created by Robert Rock on 10/19/15.
//  Copyright © 2015 Akshay. All rights reserved.
//

import UIKit

class SubCategoryViewController: UIViewController {

    @IBOutlet weak var subCategoryTableView: UITableView!
    var subCategories: AnyObject?
    var parent: AnyObject?
    
    var strMainCategory : String!
    
    var game: PFObject!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSThread .detachNewThreadSelector("showhud", toTarget: self, withObject: nil)
        self.querySubCategories()
    }

    //method for getting sub-category
    func querySubCategories() {
        
        let query = PFQuery(className: "SubCategory")
        
        let queryParent = PFQuery(className: "Category")
        queryParent.limit = 1000
        queryParent.whereKey("objectId", equalTo: strMainCategory)
        queryParent.findObjectsInBackgroundWithBlock {  (parentObjs, error) -> Void in
            if error == nil {
                //NSLog("parent = %@", parentObjs!)
                self.parent = parentObjs
                let obj:PFObject = (self.parent as! Array)[0];
                //NSLog("%@", obj.description);
                
                query.whereKey("parentCategory", equalTo: obj)
                query.limit = 1000;
                
                query.findObjectsInBackgroundWithBlock { (objArray, error) -> Void in
                    if error == nil {
                        //NSLog("object = %@", objArray!);
                        self.subCategories = objArray;
                        
                        let subObj:PFObject = (self.subCategories as! Array)[0];
                        //NSLog("%@", subObj.description);
                        self.subCategoryTableView.reloadData()
                        hideHud(self.view)
                    } else {
                        NSLog("error=%@",error!);
                    }
                }
            }
            else {
                NSLog("error=%@",error!);
            }
        }
    } //END of querySubCategories()
    
    
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
        let obj:PFObject = (self.subCategories as! Array)[indexPath.row];
        cell!.textLabel?.text = obj.objectForKey("subCategoryName") as? String
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {        
        let selectSubCategoryVC = self.storyboard?.instantiateViewControllerWithIdentifier("SelectSubCategoryViewController") as? SelectSubCategoryViewController
        let obj:PFObject = (self.parent as! Array)[indexPath.row];
        let subObj: PFObject = (self.subCategories as! Array)[indexPath.row]
        selectSubCategoryVC?.strMainCategory = obj.objectId
        selectSubCategoryVC?.strSubCategory = subObj.objectId
        game["subCategory"] = subObj
        selectSubCategoryVC?.game = self.game
        //selectSubCategoryVC?.PFSubCategory = subObj
        self.navigationController!.pushViewController(selectSubCategoryVC!, animated:true)
    }
    
    //==========================================================================================================================
    
    // MARK: Buttons IBAction
    
    //==========================================================================================================================
    
    @IBAction func backButton(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func searchButtonTap(sender: AnyObject) {
        let searchSubCategoryVC = self.storyboard?.instantiateViewControllerWithIdentifier("SearchSubCategoryViewController") as! SearchSubCategoryViewController
        searchSubCategoryVC.strMainCategory = self.parent![0].objectId
        self.navigationController?.pushViewController(searchSubCategoryVC, animated: true)
    }
    
    //==========================================================================================================================
    
    // MARK: Progress hud display methods
    
    //==========================================================================================================================
    func showhud() {
        showHud(self.view)
    }

}
