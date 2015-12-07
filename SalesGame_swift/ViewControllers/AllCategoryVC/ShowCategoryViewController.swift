//
//  ShowCategoryViewController.swift
//  SalesGame_swift
//
//  Created by Robert Rock on 12/6/15.
//  Copyright © 2015 Akshay. All rights reserved.
//

import UIKit

class ShowCategoryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    var strMainCategory: String?
    
    var subCategoriesFromLocal: AnyObject?
    var parent: AnyObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    
    //==========================================================================================================================
    
    // MARK: CollectionView
    
    //==========================================================================================================================
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if self.subCategoriesFromLocal == nil {
//            return 0
//        } else {
//            return self.subCategoriesFromLocal!.count
//        }
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
                let obj:PFObject = (self.parent as! Array)[0]
            
                querySubCategoryFromLocal.fromLocalDatastore()
                querySubCategoryFromLocal.whereKey("parentCategory", equalTo: obj)
                querySubCategoryFromLocal.findObjectsInBackgroundWithBlock{ (found, error) -> Void in
                    if error == nil {
                        self.subCategoriesFromLocal = found
                        print("categoriesFromLocal: \(self.subCategoriesFromLocal)")
                        
                        let obj:PFObject = (self.subCategoriesFromLocal as! Array)[indexPath.row]
                        var labelText = obj.valueForKey("subCategoryName") ?? ""
                        cell!.subCategoryLabel?.text = labelText as? String
//                        cell!.subCategoryLabel?.text = obj.valueForKey("subCategoryName") as? String
                        
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
        self.performSegueWithIdentifier("gameStart", sender: self)
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "gameStart" {
//            
//            let indexPaths = self.collectionView!.indexPathsForSelectedItems()!
//            let indexPath = indexPaths[0] as NSIndexPath
//            
//            let vc = segue.destinationViewController as! SelectSubCategoryViewController
//            
//            let obj:PFObject = (self.subCategoriesFromLocal as! Array)[indexPath.row]
//            
//            vc.title = obj.valueForKey("categoryName") as? String
//            vc.strMainCategory = obj.objectId as String!
//            
//            let categoryFile = obj.valueForKey("categoryFile") as? PFFile
//            categoryFile?.getDataInBackgroundWithBlock{ (imageData, error) -> Void in
//                if error == nil {
//                    if let imageData = imageData {
//                        vc.imageView?.image = UIImage(data: imageData)
//                    }
//                } else{
//                    print("Error in prepareForSegue categoryFile: \(error)")
//                }
//            }
//            
//        }
//    }
    

}
