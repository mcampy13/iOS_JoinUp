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
    
    var categoryAnyObj:AnyObject?
    var categoryArray: NSMutableArray! = []
    
    var PFCategoriesFromHome:AnyObject?
    
    var categoriesFromLocal: AnyObject?
    
    var PFCategoryArray = [PFObject]()
    
    var strMainCategory: String?
    var PFMainCategory: PFObject?
    
    var Game: PFObject!
    
    var categories = ["Human Resources", "Values", "New Hire", "Data", "Security"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("PFCategoriesFromHome: \(self.PFCategoriesFromHome)")
        self.navigationController?.navigationBar.barTintColor = UIColor.orangeColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
    }
    
    
    //==========================================================================================================================
    
    // MARK: CollectionView
    
    //==========================================================================================================================
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as? CategoryCollectionViewCell
        
        let queryCategoryFromLocal = PFQuery(className: "Category")
        queryCategoryFromLocal.fromLocalDatastore()
        queryCategoryFromLocal.findObjectsInBackgroundWithBlock{ (found, error) -> Void in
            if error == nil {
                self.categoriesFromLocal = found
                print("categoriesFromLocal: \(self.categoriesFromLocal)")
                
                let obj:PFObject = (self.categoriesFromLocal as! Array)[indexPath.row]
                cell!.categoryTitleCell?.text = obj.valueForKey("categoryName") as? String
                
                let categoryFile = obj.valueForKey("categoryFile") as? PFFile
                categoryFile?.getDataInBackgroundWithBlock{ (imageData, error) -> Void in
                    if error == nil {
                        if let imageData = imageData {
                            cell?.categoryImageCell.image = UIImage(data: imageData)
                        }
                    } else{
                        print("Error in gameFile: \(error)")
                    }
                }

            } else{
                print("Error in queryFromLocal: \(error)")
            }
        }
        return cell!
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("segueShowCategory", sender: self)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueShowCategory" {
            
            let indexPaths = self.collectionView!.indexPathsForSelectedItems()!
            let indexPath = indexPaths[0] as NSIndexPath
            
            let showCategoryVC = segue.destinationViewController as! ShowCategoryViewController
            
            let obj:PFObject = (self.categoriesFromLocal as! Array)[indexPath.row]
            
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
