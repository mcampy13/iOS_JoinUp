//
//  GameHistoryViewController.swift
//  SalesGame_swift
//
//  Created by Robert Rock on 11/18/15.
//  Copyright © 2015 Akshay. All rights reserved.
//

import UIKit

class GameHistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tblView: UITableView!
    
    var anyObj: AnyObject?
    var array: NSMutableArray = []
    
    var holder: PFObject!
    var subHolder: PFObject!
    var categoryString: String!
    var subCategoryString: String!
    
    var historyDataAnyObject: AnyObject?
    var historyArray: NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSThread .detachNewThreadSelector("showhud", toTarget: self, withObject: nil)
        
        let queryGames = PFQuery(className: "Game")
        queryGames.whereKey("player", equalTo: PFUser.currentUser()!)
        queryGames.findObjectsInBackgroundWithBlock { (success, error) -> Void in
            if error == nil {
                self.anyObj = success
                for var i=0; i < self.anyObj!.count; i++ {
                    let PFObj: PFObject = (self.anyObj as! Array)[i]
                    self.array.addObject(PFObj)
                }
                //print("array: \(self.array)")
                self.tblView!.reloadData()
                hideHud(self.view)
            } else {
                print("Error in queryGames: \(error)")
            }
        }
    }

    
    func displayAlert(title: String, error: String){
        let alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: {action in
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }

    
    //==========================================================================================================================
    
    // MARK: Table datasource and delegate methods
    
    //==========================================================================================================================
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.array.count == 0 {
            return 0
        } else{
            return self.array.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: GameHistoryTableViewCell = tblView!.dequeueReusableCellWithIdentifier("cell") as! GameHistoryTableViewCell
        
        let query = PFQuery(className: "Game")
        query.addDescendingOrder("createdAt")
        query.includeKey("category")
        query.includeKey("subCategory")
        query.findObjectsInBackgroundWithBlock { (success, error) -> Void in
            if error == nil {
                self.historyDataAnyObject = success
                for var j=0; j < success!.count; j++ {
                    let obj:PFObject = (self.historyDataAnyObject as! Array)[j]
                    self.historyArray.addObject(obj)
                }
                //print("historyArray: \(self.historyArray as NSMutableArray)")
                
                //print("whole category: \(self.array.objectAtIndex(indexPath.row).valueForKey("category"))")
                self.holder = self.array.objectAtIndex(indexPath.row).valueForKey("category")! as! PFObject
                self.subHolder = self.array.objectAtIndex(indexPath.row).valueForKey("subCategory")! as! PFObject
                
                var categoryName = self.queryCategoryWithID()
                cell.labelCategoryTitle?.text = self.categoryString
                
                var subCategoryName = self.querySubCategory()
                cell.labelSubCategoryTitle?.text = self.subCategoryString
//                let subCategory = self.array.objectAtIndex(indexPath.row).objectForKey("subCategory")?.valueForKey("subCategoryName") as? String
//                cell.labelSubCategoryTitle?.text = subCategory
                
                let gameFile = self.array.objectAtIndex(indexPath.row).valueForKey("category")?.valueForKey("categoryFile") as? PFFile
                gameFile?.getDataInBackgroundWithBlock{ (imageData, error) -> Void in
                    if error == nil {
                        if let imageData = imageData {
                            cell.img.image = UIImage(data: imageData)
                            hideHud(self.view)
                        }
                    } else{
                        print("Error in gameFile: \(error)")
                    }
                }
            } else{
                print("Error in query: \(error)")
            }
        }
        cell.backgroundColor = UIColor.clearColor()
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        displayAlert("\(self.subCategoryString)", error: "You played this game on \(self.array[indexPath.row].createdAt)")
    }
    
    func queryCategoryWithID(){
        let queryCateory = PFQuery(className: "Category")
        queryCateory.whereKey("objectId", equalTo: self.holder.objectId!)
        queryCateory.findObjectsInBackgroundWithBlock{ (success, error) -> Void in
            if error == nil {
                //print("success: \(success)")
                for var l=0; l < success!.count; l++ {
                    let obj: PFObject = (success! as! Array)[l]
                    //print("obj: \(obj.valueForKey("categoryName"))")
                    self.categoryString = obj.valueForKey("categoryName")! as? String
                    //print("string: \(self.categoryString)")
                }
                
            } else{
                print("Error in queryCategory: \(error)")
            }
        }
        
    }
    
    func querySubCategory(){
        let querySubCateory = PFQuery(className: "SubCategory")
        querySubCateory.whereKey("objectId", equalTo: self.subHolder.objectId!)
        querySubCateory.findObjectsInBackgroundWithBlock{ (success, error) -> Void in
            if error == nil {
                //print("success: \(success)")
                for var l=0; l < success!.count; l++ {
                    let obj: PFObject = (success! as! Array)[l]
                    //print("obj: \(obj.valueForKey("categoryName"))")
                    self.subCategoryString = obj.valueForKey("subCategoryName")! as? String
                    //print("string: \(self.categoryString)")
                }
                
            } else{
                print("Error in querySubCategory: \(error)")
            }
        }
        
    }

    
    
    //==========================================================================================================================
    
    // MARK: Actions
    
    //==========================================================================================================================
    
    @IBAction func homeButtonTap(sender: AnyObject) {
        let homeVC = self.storyboard?.instantiateViewControllerWithIdentifier("HomeViewController") as! HomeViewController
        self.navigationController?.pushViewController(homeVC, animated: true)
    }
    
    
    
    //==========================================================================================================================
    
    // MARK: Progress hud display methods
    
    //==========================================================================================================================
    
    func showhud() {
        showHud(self.view)
    }

    
}
