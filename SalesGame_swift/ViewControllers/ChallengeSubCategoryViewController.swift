//
//  ChallengeSubCategoryViewController.swift
//  SalesGame_swift
//
//  Created by Robert Rock on 11/11/15.
//  Copyright © 2015 Akshay. All rights reserved.
//

import UIKit

class ChallengeSubCategoryViewController: UIViewController {

    
    @IBOutlet weak var labelChallengeCategory: UILabel!
    
    @IBOutlet weak var challengeSubCategoryTable: UITableView!

    var challengeUser: String!
    var challengeUserId: String!
    var strMainCategory: String!
    
    var arraySubCategory:AnyObject?
    var array: NSMutableArray! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSThread .detachNewThreadSelector("showhud", toTarget: self, withObject: nil)
        
        querySubCategories()
    }
    
    func querySubCategories() {
        let query = PFQuery(className: "SubCategory")
        query.findObjectsInBackgroundWithBlock { (objArray, error) -> Void in
            if error == nil {
                self.arraySubCategory = objArray;
                
                let obj:PFObject = (self.arraySubCategory as! Array)[0];
                self.array.addObject(obj)
                self.labelChallengeCategory?.text = self.strMainCategory
                self.challengeSubCategoryTable.reloadData()
                hideHud(self.view)
            } else {
                print("Error querying for challenge sub-categories: \(error)")
            }
        }
    } //END of querySubCategories()


    //==========================================================================================================================
    
    // MARK: Table datasource and delegate methods
    
    //==========================================================================================================================
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.arraySubCategory == nil) {
            return 0
        } else {
            return self.arraySubCategory!.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = challengeSubCategoryTable.dequeueReusableCellWithIdentifier("cell")
        let obj:PFObject = (self.arraySubCategory as! Array)[indexPath.row];
        cell!.textLabel?.text = obj.objectForKey("subCategoryName") as? String
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let challengeFaceOffVC = self.storyboard?.instantiateViewControllerWithIdentifier("ChallengeFaceOffViewController") as? ChallengeFaceOffViewController
        let obj:PFObject = (self.arraySubCategory as! Array)[indexPath.row];
        challengeFaceOffVC?.challengeUser = self.challengeUser
        challengeFaceOffVC?.challengeUserId = self.challengeUserId
        print("Selected Challenge sub-category: \(obj)")
        self.navigationController!.pushViewController(challengeFaceOffVC!, animated:true)
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
