    //
//  HighScoreViewController.swift
//  SalesGame_swift
//
//  Created by Akuma on 9/13/15.
//  Copyright (c) 2015 Akuma. All rights reserved.
//

import UIKit

class HighScoreViewController: UIViewController {
    
    @IBOutlet weak var labelFirstPlace: UILabel!
    @IBOutlet weak var labelSecondPlace: UILabel!
    @IBOutlet weak var labelThirdPlace: UILabel!
    
    @IBOutlet weak var firstPlaceImg: UIImageView!
    @IBOutlet weak var secondPlaceImg: UIImageView!
    @IBOutlet weak var thirdPlaceImg: UIImageView!
    
    var pic:AnyObject?

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
        UtilityClass.setMyViewBorder(firstPlaceImg, withBorder: 1, radius: 30)
        UtilityClass.setMyViewBorder(secondPlaceImg, withBorder: 1, radius: 30)
        UtilityClass.setMyViewBorder(thirdPlaceImg, withBorder: 1, radius: 30)


        let query = PFQuery(className: "Score")
        query.addDescendingOrder("score")
//        query.selectKeys(["user","name","score"])
        query.findObjectsInBackgroundWithBlock { (success, error) -> Void in
            if error == nil {
                self.dataArray = success
                for var i=0; i < success!.count; i++ {
                    print("succes[i]: \(success![i])")
                    
                    let PFobj: PFObject = (success as! Array)[i]
                    self.finalArray.addObject(PFobj)
                    
                    self.labelFirstPlace!.text = success![0].objectForKey("name") as! String
                    self.labelSecondPlace!.text = success![1].objectForKey("name") as! String
                    self.labelThirdPlace!.text = success![2].objectForKey("name") as! String
                    
                }
                print("final Array", self.finalArray as NSMutableArray)
                self.displayFirstImg()
                self.displaySecondImg()
                self.displayThirdImg()
                self.tblobj!.reloadData()
                hideHud(self.view)
                
            } else {
                print("Error for Score: \(error)")
            }
            
        }
        
    }
    
    func displayFirstImg(){
        let user = self.finalArray[0].valueForKey("user")
        let userObj = PFQuery.getUserObjectWithId((user?.objectId)!)
        print("First place user: \(user)")
        
        let file: PFFile = userObj?.valueForKey("profilePic") as! PFFile
        print("file \(file)")
        file.getDataInBackgroundWithBlock({
            (imageData, error) -> Void in
            if error == nil {
                let Image: UIImage = UIImage(data: imageData!)!
                print("Image \(Image)")
                self.firstPlaceImg.image = Image
                
                hideHud(self.view)
            } else {
                print("Error \(error)")
            }
        })
        
    } // END of displayFirstImg()
    
    
    func displaySecondImg(){
        let user = self.finalArray[1].valueForKey("user")
        let userObj = PFQuery.getUserObjectWithId((user?.objectId)!)
        print("Second place user: \(user)")
        
        let file: PFFile = userObj?.valueForKey("profilePic") as! PFFile
        print("file \(file)")
        file.getDataInBackgroundWithBlock({
            (imageData, error) -> Void in
            if error == nil {
                let Image: UIImage = UIImage(data: imageData!)!
                print("Image \(Image)")
                self.secondPlaceImg.image = Image
                hideHud(self.view)
            } else {
                print("Error \(error)")
            }
        })
        
    } // END of displaySecondImg()
    
    
    func displayThirdImg(){
        let user = self.finalArray[2].valueForKey("user")
        let userObj = PFQuery.getUserObjectWithId((user?.objectId)!)
        print("Third place user: \(user)")
        
        let file: PFFile = userObj?.valueForKey("profilePic") as! PFFile
        print("file \(file)")
        file.getDataInBackgroundWithBlock({
            (imageData, error) -> Void in
            if error == nil {
                let Image: UIImage = UIImage(data: imageData!)!
                print("Image \(Image)")
                self.thirdPlaceImg.image = Image
                hideHud(self.view)
            } else {
                print("Error \(error)")
            }
        })
        
    } // END of displayThirdImg()
    

    
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
//        
//        let level = self.finalArray.objectAtIndex(indexPath.row).valueForKey("level") as? Int!
//        cell.lblLevel?.text = String(stringInterpolationSegment: level!)
        
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
        //UtilityClass.showAlert("Let's check out your Badges!")
        let badgeVC = self.storyboard?.instantiateViewControllerWithIdentifier("BadgeViewController") as? BadgeViewController
        self.navigationController?.pushViewController(badgeVC!, animated: true)
    }
    
    
//==========================================================================================================================

// MARK: Progress hud display methods

//==========================================================================================================================
    func showhud() {
        showHud(self.view)
    }
    
}
