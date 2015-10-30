    //
//  HighScoreViewController.swift
//  SalesGame_swift
//
//  Created by Akuma on 9/13/15.
//  Copyright (c) 2015 Akuma. All rights reserved.
//

import UIKit

class HighScoreViewController: UIViewController {

    @IBOutlet weak var tblobj: UITableView?
    @IBOutlet weak var badgeButton: UIBarButtonItem!
    
    var dataArray:AnyObject?
    var finalArray : NSMutableArray = []
    
//==========================================================================================================================

// MARK: Life Cycle methods

//==========================================================================================================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSThread .detachNewThreadSelector("showhud", toTarget: self, withObject: nil)
        let query = PFQuery(className: "Score")
        query.addDescendingOrder("score")
        query.findObjectsInBackgroundWithBlock { (objArray, error) -> Void in
           if error == nil {
            print("object = \(objArray!)")
            self.dataArray = objArray;
            for var i = 0;  i < objArray!.count; i++ {
                let obj:PFObject = (self.dataArray as! Array)[i];
                self.finalArray .addObject(obj)
            }
            print("finalArray",self.finalArray as NSMutableArray)
            self.tblobj!.reloadData()
            hideHud(self.view)
           } else {
                print("Error \(error)")
            }
        }
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
        let cell:HighScoreTableViewCell = tblobj!.dequeueReusableCellWithIdentifier("cell") as! HighScoreTableViewCell
        
        let score = self.finalArray .objectAtIndex(indexPath.row).valueForKey("score") as? Int!
        cell.lblScore?.text = String(stringInterpolationSegment: score!)
        
        cell.lblName?.text = self.finalArray .objectAtIndex(indexPath.row).valueForKey("name") as? String
        
        cell.backgroundColor = UIColor .clearColor()
        return cell
    }
//==========================================================================================================================

// MARK: IBAction Button methods

//==========================================================================================================================
    
    @IBAction func doneButton(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func badgeButton(sender: AnyObject) {
        UtilityClass.showAlert("Let's check out your Badges!")
    }
//==========================================================================================================================

// MARK: Progress hud display methods

//==========================================================================================================================
    func showhud() {
        showHud(self.view)
    }
    
}
