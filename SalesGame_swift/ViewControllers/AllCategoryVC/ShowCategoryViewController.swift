//
//  ShowCategoryViewController.swift
//  SalesGame_swift
//
//  Created by Robert Rock on 12/6/15.
//  Copyright © 2015 Akshay. All rights reserved.
//

import UIKit

class ShowCategoryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UINavigationControllerDelegate {

    
    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    var strMainCategory: String?
    
    var subCategoriesFromLocal: AnyObject?
    var parent: AnyObject?
    
    var game: PFObject!
    var PFCategory: PFObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    
    //==========================================================================================================================
    
    // MARK: CollectionView
    
    //==========================================================================================================================
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as? SubCategoryCollectionViewCell
        
        let querySubCategoryFromLocal = PFQuery(className: "SubCategory")
        let queryParent = PFQuery(className: "Category")
        
        queryParent.limit = 100
        queryParent.whereKey("objectId", equalTo: self.strMainCategory!)
        queryParent.findObjectsInBackgroundWithBlock {  (parentObjs, error) -> Void in
            if error == nil {
                self.parent = parentObjs
                let parentObj: PFObject = (self.parent as! Array)[0]
                self.PFCategory = parentObj
                querySubCategoryFromLocal.fromLocalDatastore()
                querySubCategoryFromLocal.whereKey("parentCategory", equalTo: parentObj)
                
                querySubCategoryFromLocal.findObjectsInBackgroundWithBlock{ (found, error) -> Void in
                    if error == nil {
                        self.subCategoriesFromLocal = found
                        //print("subCategoriesFromLocal: \(self.subCategoriesFromLocal)")
                        
//                        var temp: NSArray = found as! NSArray
//                        self.subCategoriesFromLocal = temp.mutableCopy() as! NSMutableArray
//                        let obj:PFObject = self.subCategoriesFromLocal!.objectAtIndex(indexPath.row) as! PFObject
                        
                        let obj:PFObject = (self.subCategoriesFromLocal as! Array)[indexPath.row]
                        let labelText = obj.valueForKey("subCategoryName") ?? ""
                        cell!.subCategoryLabel?.text = labelText as? String
                        cell!.subCategoryLabel?.text = obj["subCategoryName"] as? String
                        
                        let subCategoryFile = obj.valueForKey("subCategoryFile") as? PFFile
                        subCategoryFile?.getDataInBackgroundWithBlock{ (imageData, error) -> Void in
                            if error == nil {
                                if let imageData = imageData {
                                    cell?.imageView.image = UIImage(data: imageData)
                                }
                            } else{
                                print("Error in subCategoryFile: \(error)")
                            }
                        }
                    } else{
                        print("Error in querySubCategoryFromLocal: \(error)")
                    }
                }
            } else {
                print("Error in queryParent: \(error)")
            }
        }
        
        return cell!
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("segueGameStart", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueGameStart" {
            
            let indexPaths = self.collectionView!.indexPathsForSelectedItems()!
            let indexPath = indexPaths[0] as NSIndexPath
            
            let navSelectSubCategoryVC = segue.destinationViewController as! UINavigationController
            let selectSubCategoryVC = storyboard?.instantiateViewControllerWithIdentifier("SelectSubCategoryViewController") as! SelectSubCategoryViewController
            
            let parentObj: PFObject = (self.parent as! Array)[indexPath.row]
            let obj:PFObject = (self.subCategoriesFromLocal as! Array)[indexPath.row]
            
            game["subCategory"] = obj
            
            selectSubCategoryVC.title = obj.valueForKey("subCategoryName") as? String
            selectSubCategoryVC.strMainCategory = parentObj.objectId as String!
            selectSubCategoryVC.strSubCategory = obj.objectId as String!
            selectSubCategoryVC.game = self.game
            
            let categoryFile = parentObj.valueForKey("categoryFile") as? PFFile
            categoryFile?.getDataInBackgroundWithBlock{ (imageData, error) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        selectSubCategoryVC.subCategoryImageView?.image = UIImage(data: imageData)
                    }
                } else{
                    print("Error in prepareForSegue categoryFile: \(error)")
                }
            }
            navSelectSubCategoryVC.pushViewController(selectSubCategoryVC, animated: true)
            
        } else if segue.identifier == "segueSearchSubCategory" {
            let searchSubCategoryVC = segue.destinationViewController as! SearchSubCategoryViewController
            
            searchSubCategoryVC.strMainCategory = self.strMainCategory
            searchSubCategoryVC.mainCategoryPF = self.PFCategory
            
            //print("segue id == segueSearchSubCategory strMainCategory: \(self.strMainCategory)")
            //print("segue id == segueSearchSubCategory PFCategory: \(self.PFCategory)")
        }
        
    } // END of prepareForSegue()
    

}
