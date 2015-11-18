//
//  BadgeOverviewViewController.swift
//  SalesGame_swift
//
//  Created by Robert Rock on 11/12/15.
//  Copyright © 2015 Akshay. All rights reserved.
//

import UIKit

class BadgeOverviewViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var successArray: AnyObject?
    var arrayOverview: NSMutableArray = []
    
    var success2Array: AnyObject?
    var array2Overview: NSMutableArray = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //NSThread .detachNewThreadSelector("showhud", toTarget: self, withObject: nil)
        
        let query = PFQuery(className: "Badges")
        query.addAscendingOrder("createdAt")
        query.findObjectsInBackgroundWithBlock { (success, error) -> Void in
            if error == nil {
                print("success: \(success!)")
                self.successArray = success
                for var l=0; l<success!.count; l++ {
                    let PFobj: PFObject = (self.successArray as! Array)[l]
                    self.arrayOverview.addObject(PFobj)
                }
    
                print("arrayOverview: \(self.arrayOverview as NSMutableArray)")
                
            } else {
                print("Error querying Badges \(error)")
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
    
    // MARK: Collection View methods
    
    //==========================================================================================================================
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.arrayOverview.count == 0 {
            return 0
        } else {
            return self.arrayOverview.count
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let Cell: BadgeOverviewCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! BadgeOverviewCollectionViewCell
        
        let queryBadges = PFQuery(className: "Badges")
        queryBadges.addAscendingOrder("createdAt")
        queryBadges.findObjectsInBackgroundWithBlock { (success, error) -> Void in
            if error == nil {
                print("success2: \(success!)")
                self.success2Array = success
                for var l=0; l<success!.count; l++ {
                    let obj: PFObject = (self.success2Array as! Array)[l]
                    self.array2Overview.addObject(obj)
                }
                print("array2Overview: \(self.array2Overview as NSMutableArray)")
        
                let name = self.arrayOverview.objectAtIndex(indexPath.row).valueForKey("badgeName") as? String
                Cell.badgeNameLabel.text = name
                
                let badgeFile = self.array2Overview.objectAtIndex(indexPath.row).valueForKey("badgeImg") as? PFFile
                badgeFile?.getDataInBackgroundWithBlock{ (imageData, error) -> Void in
                    if error == nil{
                        if let imageData = imageData {
                            Cell.badgeImgView.image = UIImage(data: imageData)
                            hideHud(self.view)
                        }
                    } else{
                        print("Error in getDataInBackgroundWithBlock \(error)")
                    }
                }
                
            } else {
                print("Error querying Badges \(error)")
            }
            
        }
        
        return Cell
        
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
