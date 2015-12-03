//
//  TotalBadgesViewController.swift
//  SalesGame_swift
//
//  Created by Robert Rock on 11/12/15.
//  Copyright © 2015 Akshay. All rights reserved.
//

import UIKit

class TotalBadgesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tblBadges: UITableView!
    
    var dataArray:AnyObject?
    var finalArray : NSMutableArray = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSThread .detachNewThreadSelector("showhud", toTarget: self, withObject: nil)
        
        self.navigationController?.navigationBar.barTintColor = UIColor.orangeColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        let query = PFQuery(className: "Badges")
        query.addAscendingOrder("createdAt")
        query.findObjectsInBackgroundWithBlock { (success, error) -> Void in
            if error == nil {
                print("Badge Array \(success!)")
                self.dataArray = success
                for var l=0; l<success!.count; l++ {
                    let PFO: PFObject = (self.dataArray as! Array)[l]
                    self.finalArray.addObject(PFO)
                }
                print("Final Array \(self.finalArray as NSMutableArray)")
                self.tblBadges!.reloadData()
                hideHud(self.view)
                
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
        let cell: TotalBadgesTableViewCell = tblBadges!.dequeueReusableCellWithIdentifier("Cell") as! TotalBadgesTableViewCell
        
        let name = self.finalArray.objectAtIndex(indexPath.row).valueForKey("badgeName") as? String
        cell.labelTitle?.text = name
        
        let description = self.finalArray.objectAtIndex(indexPath.row).valueForKey("badgeDescription") as? String
        cell.labelDescription?.text = description

        let badgePFFile = self.finalArray.objectAtIndex(indexPath.row).valueForKey("badgeImg") as? PFFile
        badgePFFile?.getDataInBackgroundWithBlock{ (imageData, error) -> Void in
            if error == nil{
                if let imageData = imageData {
                    cell.badgeImage.image = UIImage(data: imageData)
                    hideHud(self.view)
                }
            } else{
                print("Error in getDataInBackgroundWithBlock \(error)")
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        displayAlert("\(self.finalArray.objectAtIndex(indexPath.row).valueForKey("badgeName")!)", error: "\(self.finalArray.objectAtIndex(indexPath.row).valueForKey("badgeDescription")!)")
    }
    
    //==========================================================================================================================
    
    // MARK: Actions
    
    //==========================================================================================================================
    
    @IBAction func homeButton(sender: AnyObject) {
        let homeVC = self.storyboard?.instantiateViewControllerWithIdentifier("HomeViewController") as? HomeViewController
        self.navigationController?.pushViewController(homeVC!, animated: true)
    }
    
    @IBAction func doneButton(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    //==========================================================================================================================
    
    // MARK: Progress hud display methods
    
    //==========================================================================================================================
    
    func showhud() {
        showHud(self.view)
    }
    
}
