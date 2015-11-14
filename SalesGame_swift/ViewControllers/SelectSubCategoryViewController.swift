//
//  SelectSubCategoryViewController.swift
//  SalesGame_swift
//
//  Created by Robert Rock on 11/11/15.
//  Copyright © 2015 Akshay. All rights reserved.
//

import UIKit

class SelectSubCategoryViewController: UIViewController {

    
    @IBOutlet weak var labelCategoryTitle: UILabel!
    @IBOutlet weak var labelSubCategoryTitle: UILabel!
    @IBOutlet weak var labelQuestionCount: UILabel!
    @IBOutlet weak var subCategoryImageView: UIImageView?
    
    var category: AnyObject!
    var subCategory: AnyObject!
    
    var strMainCategory : String!
    var strSubCategory: String!
    var PFcategory: PFObject?
    var PFSubCategory: PFObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSThread .detachNewThreadSelector("showhud", toTarget: self, withObject: nil)
        
        queryCategory()
        querySubCategory()
        //questionCount()
    }
    
    
    func queryCategory() {
        let queryCategory = PFQuery(className: "Category")
        queryCategory.whereKey("objectId", equalTo: strMainCategory)
        queryCategory.findObjectsInBackgroundWithBlock{ (success, error) -> Void in
            if error == nil {
                self.category = success
                let obj: PFObject = (self.category as! Array)[0]
                self.labelCategoryTitle?.text = obj.valueForKey("categoryName") as! String
                hideHud(self.view)
            } else {
                print("Error querying for categoryTitle \(error)")
            }
        }
    } // END of queryCategory()
    
    
    func querySubCategory(){
        let query = PFQuery(className: "SubCategory")
        query.whereKey("objectId", equalTo: strSubCategory)
        query.findObjectsInBackgroundWithBlock { (success, error) -> Void in
            if error == nil {
                self.subCategory = success
                let obj: PFObject = (self.subCategory as! Array)[0]
                self.labelSubCategoryTitle?.text = obj.valueForKey("subCategoryName") as? String
                self.subCategoryImageView?.image = obj.objectForKey("subCategoryFile") as? UIImage
                print("subCategoryImageView \(self.subCategoryImageView?.image)")
                
                hideHud(self.view)
            } else {
                print("Error in querySubCategory: \(error)")
            }
        }
    } // END of querySubCategory()

    func questionCount(){
        let queryQuestion = PFQuery(className: "Question")
        queryQuestion.whereKey("parentSubCategory", equalTo: (self.PFSubCategory?.objectId)!)
        queryQuestion.countObjectsInBackgroundWithBlock { (count: Int32, error) -> Void in
            if error == nil {
                self.labelQuestionCount.text = String(count)
                print("count \(count)")
                hideHud(self.view)
            } else {
                print("Error in queryQuestionCount \(error)")
            }
        }
    }
    
    func displayAlert(title: String, error: String){
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: {action in
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //==========================================================================================================================
    
    // MARK: Actions
    //==========================================================================================================================
    
    @IBAction func playButton(sender: AnyObject) {
        let questionVC = self.storyboard?.instantiateViewControllerWithIdentifier("QuestionViewController") as? QuestionViewController
        let obj:PFObject = (self.subCategory as! Array)[0];
        questionVC?.MainCategory = obj
        questionVC?.PFsubCategory = self.PFSubCategory
        questionVC?.flagForWrongAnswerpush = false
        self.navigationController!.pushViewController(questionVC!, animated:true)
        
    }
    
    @IBAction func opponentButton(sender: AnyObject) {
        displayAlert("Challenge", error: "You must win!")
    }
    
    @IBAction func leaderboardButton(sender: AnyObject) {
        
    }
    
    
    @IBAction func homeButton(sender: AnyObject) {
        let homeVC = self.storyboard?.instantiateViewControllerWithIdentifier("HomeViewController") as? HomeViewController
        self.navigationController?.pushViewController(homeVC!, animated: true)
    }
    
    
    @IBAction func profileButton(sender: AnyObject) {
        let profileVC = self.storyboard?.instantiateViewControllerWithIdentifier("ProfileViewController") as? ProfileViewController
        self.navigationController!.pushViewController(profileVC!, animated: true)
    }
    
    
    //==========================================================================================================================
    
    // MARK: Progress hud display methods
    
    //==========================================================================================================================
    
    func showhud() {
        showHud(self.view)
    }

    
}
