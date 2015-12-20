//
//  SelectSubCategoryViewController.swift
//  SalesGame_swift
//
//  Created by Robert Rock on 11/11/15.
//  Copyright © 2015 Akshay. All rights reserved.
//

import UIKit

class SelectSubCategoryViewController: UIViewController {

    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    @IBOutlet weak var labelCategoryTitle: UILabel!
    @IBOutlet weak var labelSubCategoryTitle: UILabel!
    @IBOutlet weak var labelQuestionCount: UILabel!
    @IBOutlet weak var subCategoryImageView: UIImageView?
    
    var category: AnyObject!
    var subCategory: AnyObject!
    
    var categoryArray: NSMutableArray = []
    var subCategoryArray: NSMutableArray = []
    
    var strMainCategory : String!
    var strSubCategory: String!
    var PFcategory: PFObject?
    var PFSubCategory: PFObject?
    var game: PFObject!
    
    var subCategoryPFObj: PFObject!
    var categoryPFObj: PFObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSThread .detachNewThreadSelector("showhud", toTarget: self, withObject: nil)
        
        self.navigationController?.navigationBar.barTintColor = UIColor.orangeColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        //print("categoryPFObj: \(self.categoryPFObj)")
        //print("subCategoryPFObj: \(self.subCategoryPFObj)")
        queryCategory()
        querySubCategory()
        
    }
    
    func queryCategory() {
        let queryCategory = PFQuery(className: "Category")
        queryCategory.whereKey("objectId", equalTo: self.categoryPFObj!.objectId!)
        queryCategory.findObjectsInBackgroundWithBlock{ (success, error) -> Void in
            if error == nil {
                self.category = success
                for var i=0; i < self.category!.count; i++ {
                    let PFobj: PFObject = (self.category as! Array)[i]
                    self.categoryArray.addObject(PFobj)
                }
                let obj: PFObject = (self.category as! Array)[0]
                //self.PFcategory = obj
                
                self.labelCategoryTitle?.text = obj.valueForKey("categoryName") as? String
                self.navigationItem.title = obj.valueForKey("categoryName") as? String
                hideHud(self.view)
            } else {
                print("Error querying for categoryTitle \(error)")
            }
        }
    } // END of queryCategory()
    
    func querySubCategory(){
        let query = PFQuery(className: "SubCategory")
        query.whereKey("objectId", equalTo: self.subCategoryPFObj!.objectId!)
        query.findObjectsInBackgroundWithBlock { (success, error) -> Void in
            if error == nil {
                self.subCategory = success
                for var i=0; i < self.subCategory!.count; i++ {
                    let obj: PFObject = (self.subCategory as! Array)[i]
                    self.subCategoryArray.addObject(obj)
                }
                let obj: PFObject = (self.subCategory as! Array)[0]
                self.PFSubCategory = obj
                print("PFSubCategory in querySubCategory: \(self.PFSubCategory)")
                self.questionCount()
                self.labelSubCategoryTitle?.text = obj.valueForKey("subCategoryName") as? String
                let subCategoryFile = obj.objectForKey("subCategoryFile") as? PFFile
                subCategoryFile?.getDataInBackgroundWithBlock{ (imageData, error) -> Void in
                    if error == nil{
                        if let imageData = imageData {
                            self.subCategoryImageView!.image = UIImage(data: imageData)
                            hideHud(self.view)
                        }
                    } else{
                        print("Error in getDataInBackgroundWithBlock \(error)")
                    }
                }
                hideHud(self.view)
            } else {
                print("Error in querySubCategory: \(error)")
            }
        }
    } // END of querySubCategory()

    func questionCount(){
        let queryQuestion = PFQuery(className: "Question")
        print("PFSubCategory in questionCount: \(self.PFSubCategory)")
        queryQuestion.whereKey("parentSubCategory", equalTo: self.PFSubCategory!)
        queryQuestion.countObjectsInBackgroundWithBlock { (count: Int32, error) -> Void in
            if error == nil {
                self.labelQuestionCount?.text = String(format: "%d", count)
                print("count \(count)")
                hideHud(self.view)
            } else {
                print("Error in queryQuestionCount \(error)")
            }
        }
    }// END of questionCount()
    
    func displayAlert(title: String, error: String){
        let alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: {action in
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
//==========================================================================================================================

// MARK: Navigation
    
//==========================================================================================================================
    
    @IBAction func cancelButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueQuestion" {
            let questionViewController = segue.destinationViewController as! QuestionViewController
            let obj:PFObject = (self.subCategory as! Array)[0]
            
            questionViewController.MainCategory = obj
            questionViewController.PFsubCategory = self.PFSubCategory
            questionViewController.flagForWrongAnswerpush = false
            questionViewController.game = self.game
        }
        else if segue.identifier == "segueRankings" {
            let rankingsVC = segue.destinationViewController as! RankingsViewController
            
            //navigationItem.title = "Back"
            
            let categoryPFObj: PFObject = (self.category as! Array)[0]
            let subCategoryPFObj: PFObject = (self.subCategory as! Array)[0]
            
            rankingsVC.PFCategory = categoryPFObj
            rankingsVC.PFSubCategory = subCategoryPFObj
        }
        
    } // END of prepareForSegue()
    
    
//==========================================================================================================================
    
// MARK: Actions
    
//==========================================================================================================================
    
    @IBAction func opponentButton(sender: AnyObject) {
        displayAlert("Challenge", error: "You must win!")
    }

    
//==========================================================================================================================
    
// MARK: Progress hud display methods
    
//==========================================================================================================================
    
    func showhud() {
        showHud(self.view)
    }

    
}
