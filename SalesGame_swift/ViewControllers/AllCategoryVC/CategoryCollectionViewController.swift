//
//  CategoryCollectionViewController.swift
//  SalesGame_swift
//
//  Created by Robert Rock on 12/6/15.
//  Copyright © 2015 Akshay. All rights reserved.
//

import UIKit

class CategoryCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UINavigationControllerDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var listButton: UIButton!
    
    var categoryAnyObj:AnyObject?
    var categoryArray: NSMutableArray = NSMutableArray()
    
    var PFCategoryArray = [PFObject]()
    
    var strMainCategory: String?
    var PFMainCategory: PFObject?
    
    var Game: PFObject!
    
//    var categories = Category()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //print("categories using model: \(self.categories)")
        
        self.navigationController?.navigationBar.barTintColor = UIColor.orangeColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        self.fetchAllObjectFromLocalDatastore()
        self.fetchAllObjects()
    }
    
    func fetchAllObjectFromLocalDatastore() {
        let queryCategoryFromLocal = PFQuery(className: "Category")
        queryCategoryFromLocal.fromLocalDatastore()
        queryCategoryFromLocal.findObjectsInBackgroundWithBlock{ (objects, error) -> Void in
            if error == nil {
                var temp: NSArray = objects! as NSArray

                self.categoryArray = temp.mutableCopy() as! NSMutableArray
                self.collectionView.reloadData()
                
            } else{
                print("Error CategoryCollection; in fetchAllObjectsFromLocalDatastore() : \(error)")
            }
        }
        print("fetchAllObjectFromLocalDatastore() objects: \(self.categoryArray)")
    }
    
    func fetchAllObjects() {
        //PFObject.unpinAllObjectsInBackgroundWithBlock(nil)
        
        let query = PFQuery(className: "Category")
        query.addAscendingOrder("createdAt")
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                PFObject.pinAllInBackground(objects, block: nil)
//                var temp: NSArray = objects! as NSArray
//                
//                for var i=0; i < temp.count; i++ {
//                    let obj: PFObject = temp.objectAtIndex(i) as! PFObject
//                    obj.pinInBackground()
//                    self.categoryArray.addObject(obj)
//                }

                self.fetchAllObjectFromLocalDatastore()
                
            } else {
                print("Error CategoryCollectionVC; in fetchAllObjects() : \(error)")
            }
        }
    }
    
    
    //==========================================================================================================================
    
    // MARK: CollectionView
    
    //==========================================================================================================================
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categoryArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as?CategoryCollectionViewCell
        
        let obj: PFObject = self.categoryArray.objectAtIndex(indexPath.row) as! PFObject
        
        cell!.categoryTitleCell?.text = obj["categoryName"] as? String
        
        let categoryFile = obj["categoryFile"] as? PFFile
        categoryFile?.getDataInBackgroundWithBlock{ (imageData, error) -> Void in
            if error == nil {
                if let imageData = imageData {
                    cell!.categoryImageCell.image = UIImage(data: imageData)
                }
            } else{
                print("Error in gameFile: \(error)")
            }
        }
        return cell!
    }
    
//        let queryCategoryFromLocal = PFQuery(className: "Category")
//        queryCategoryFromLocal.fromLocalDatastore()
//        queryCategoryFromLocal.findObjectsInBackgroundWithBlock{ (objects, error) -> Void in
//            if error == nil {
//                //print("queryFromLocal objects in CategoryCollection cellForItemAt: \(objects)")
//                var temp: NSArray = objects! as NSArray
//                self.categoryArray = temp.mutableCopy() as! NSMutableArray
//                
//                let obj:PFObject = self.categoryArray.objectAtIndex(indexPath.row) as! PFObject
//                cell!.categoryTitleCell?.text = obj["categoryName"] as? String
//                
//                let categoryFile = obj["categoryFile"] as? PFFile
//                categoryFile?.getDataInBackgroundWithBlock{ (imageData, error) -> Void in
//                    if error == nil {
//                        if let imageData = imageData {
//                            cell?.categoryImageCell.image = UIImage(data: imageData)
//                        }
//                    } else{
//                        print("Error in gameFile: \(error)")
//                    }
//                }
//            } else{
//                print("Error in queryFromLocal: \(error)")
//            }
//        }
//        return cell!
//    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("segueShowCategory", sender: self)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueShowCategory" {
                        
            let indexPaths = self.collectionView!.indexPathsForSelectedItems()!
            let indexPath = indexPaths[0] as NSIndexPath
            
            let showCategoryVC = segue.destinationViewController as! ShowCategoryViewController
            
            let obj:PFObject = self.categoryArray.objectAtIndex(indexPath.row) as! PFObject
            
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
            if let selectedCategoryCell = sender as? UICollectionViewCell {
                let indexPath = self.collectionView.indexPathForCell(selectedCategoryCell)!
                let selectedCategory: PFObject = (self.categoryAnyObj as! Array)[indexPath.row]
                //print("segue id == segueSearchCategory selectedCategory: \(selectedCategory)")
            }
        }
        
    } // END of prepareForSegue()
    
    
    
    
    
    
    
    
    
}
