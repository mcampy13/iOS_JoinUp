//
//  ChallengeCategoryViewController.swift
//  SalesGame_swift
//
//  Created by Robert Rock on 11/11/15.
//  Copyright © 2015 Akshay. All rights reserved.
//

import UIKit

class ChallengeCategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var challengeCategoryTable: UITableView!
    
    var arrayCategory:AnyObject?
    var array: NSMutableArray! = []
    
    var challengeUser: String?
    var challengeUserId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSThread .detachNewThreadSelector("showhud", toTarget: self, withObject: nil)

        queryCategories()
        
    }

    func queryCategories() {
        let query = PFQuery(className: "Category")        
        query.findObjectsInBackgroundWithBlock { (objArray, error) -> Void in
            if error == nil {
                self.arrayCategory = objArray;
                
                let obj:PFObject = (self.arrayCategory as! Array)[0];
                self.array.addObject(obj)
                self.challengeCategoryTable.reloadData()
                hideHud(self.view)
            } else {
                print("Error querying for challenge categories: \(error)")
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
        let cell = challengeCategoryTable.dequeueReusableCellWithIdentifier("cell")
        let obj:PFObject = (self.arrayCategory as! Array)[indexPath.row];
        cell!.textLabel?.text = obj.objectForKey("categoryName") as? String
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let challengeSubCategoryVC = self.storyboard?.instantiateViewControllerWithIdentifier("ChallengeSubCategoryViewController") as? ChallengeSubCategoryViewController
        let obj:PFObject = (self.arrayCategory as! Array)[indexPath.row];
        challengeSubCategoryVC?.strMainCategory = obj.objectForKey("categoryName") as! String
        challengeSubCategoryVC?.challengeUserId = self.challengeUserId
        challengeSubCategoryVC?.challengeUser = self.challengeUser
        self.navigationController!.pushViewController(challengeSubCategoryVC!, animated:true)
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
