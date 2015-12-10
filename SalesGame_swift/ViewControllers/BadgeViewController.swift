//
//  BadgeViewController.swift
//  SalesGame_swift
//
//  Created by Robert Rock on 11/10/15.
//  Copyright © 2015 Akshay. All rights reserved.
//

import UIKit

class BadgeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    
    @IBOutlet weak var badgeTableView: UITableView!
    
    var dataArray:AnyObject?
    var finalArray : NSMutableArray = []
    
    var badgeDataArray: AnyObject?
    var badgeFinalArray: NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor.orangeColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        menuButton.target = self.revealViewController()
        menuButton.action = Selector("revealToggle:")
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        NSThread .detachNewThreadSelector("showhud", toTarget: self, withObject: nil)
        
        let query = PFQuery(className: "UserBadges")
        query.addDescendingOrder("createdAt")
        query.findObjectsInBackgroundWithBlock { (objArray, error) -> Void in
            if error == nil {
                print("badge objArray = \(objArray!)")
                self.dataArray = objArray;
                for var i = 0;  i < objArray!.count; i++ {
                    let obj:PFObject = (self.dataArray as! Array)[i];
                    self.finalArray .addObject(obj)
                }
                print("finalArray",self.finalArray as NSMutableArray)
                self.badgeTableView!.reloadData()
                hideHud(self.view)
            } else {
                print("Error \(error)")
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
    
    // MARK: Navigation
    
    //==========================================================================================================================

//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "segueAllBadges" {
//            let allBadgesVC = segue.destinationViewController as! TotalBadgesViewController
//            
//        }
//    }
    
    
    //==========================================================================================================================
    
    // MARK: Table datasource and delegate methods
    
    //==========================================================================================================================
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.finalArray.count == 0 {
            return 0
        } else {
            return self.finalArray.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:BadgeTableViewCell = badgeTableView!.dequeueReusableCellWithIdentifier("cell") as! BadgeTableViewCell
    
        let badgeId = self.finalArray.objectAtIndex(indexPath.row).valueForKey("badge")?.valueForKey("objectId") as! String
        
        let query = PFQuery(className: "Badges")
        query.whereKey("objectId", equalTo: badgeId)
        query.findObjectsInBackgroundWithBlock{ (success, error) -> Void in
            if error == nil {
                self.badgeDataArray = success;
                for var i = 0;  i < success!.count; i++ {
                    let obj:PFObject = (self.badgeDataArray as! Array)[i];
                    self.badgeFinalArray.addObject(obj)
                }
                print("badgeFinalArray",self.badgeFinalArray as NSMutableArray)
                
                let name = self.badgeFinalArray.objectAtIndex(indexPath.row).valueForKey("badgeName") as? String
                cell.labelTitle?.text = name
                
                let description = self.badgeFinalArray.objectAtIndex(indexPath.row).valueForKey("badgeDescription") as? String
                cell.labelDescription?.text = description
                
                let badgePFFile = self.badgeFinalArray.objectAtIndex(indexPath.row).valueForKey("badgeImg") as? PFFile
                badgePFFile?.getDataInBackgroundWithBlock{ (imageData, error) -> Void in
                    if error == nil{
                        if let imageData = imageData {
                            cell.badgeImgView.image = UIImage(data: imageData)
                            //self.badgeTableView!.reloadData()
                            hideHud(self.view)
                        }
                    } else{
                        print("Error in getDataInBackgroundWithBlock \(error)")
                    }
                }
            } else{
                print("Error in querying Bades \(error)")
            }
        }
        
        cell.backgroundColor = UIColor .clearColor()
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        displayAlert("\(self.badgeFinalArray.objectAtIndex(indexPath.row).valueForKey("badgeName")!)", error: "\(self.badgeFinalArray.objectAtIndex(indexPath.row).valueForKey("badgeDescription")!)")
    }
    
    
    //==========================================================================================================================
    
    // MARK: Actions
    
    //==========================================================================================================================
    
    
    
    //==========================================================================================================================
    
    // MARK: Progress hud display methods
    
    //==========================================================================================================================
    
    func showhud() {
        showHud(self.view)
    }

    

}
