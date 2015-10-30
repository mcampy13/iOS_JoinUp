//
//  AllCategoryViewController.swift
//  SalesGame_swift
//
//  Created by Akuma on 9/11/15.
//  Copyright (c) 2015 Akuma. All rights reserved.
//

import UIKit

class AllCategoryViewController: UIViewController {

    @IBOutlet var tblObj : UITableView!
    var arrayCategory:AnyObject?

//==========================================================================================================================

// MARK: Life Cycle methods

//==========================================================================================================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSThread .detachNewThreadSelector("showhud", toTarget: self, withObject: nil)
        self.queryCategories()
    }
    
    //method for getting all category
    func queryCategories() {
        let query = PFQuery(className: "Category")
        query.limit = 1000;
        
        query.findObjectsInBackgroundWithBlock { (objArray, error) -> Void in
            if error == nil {
                //NSLog("object = %@", objArray!);
                self.arrayCategory = objArray;
                
                let obj:PFObject = (self.arrayCategory as! Array)[0];
                //NSLog("%@", obj.description);
                self.tblObj .reloadData()
                hideHud(self.view)
            } else {
                NSLog("error=%@",error!);
            }
        }
    } //END of queryForTable()
    
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
        cell!.backgroundColor = UIColor .clearColor()
        cell!.textLabel?.textColor = UIColor .whiteColor()
        return cell!
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let subCategoryVC = self.storyboard?.instantiateViewControllerWithIdentifier("SubCategoryViewController") as? SubCategoryViewController
        let obj:PFObject = (self.arrayCategory as! Array)[indexPath.row];
        subCategoryVC?.strMainCategory = obj.objectId
        self.navigationController!.pushViewController(subCategoryVC!, animated:true)
    }
    
//==========================================================================================================================

// MARK: Buttons IBAction

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
