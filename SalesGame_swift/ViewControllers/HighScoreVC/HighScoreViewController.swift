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
        query.selectKeys(["name","score"])
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
                self.tblobj!.reloadData()
                hideHud(self.view)
                
            } else {
                print("Error for Score: \(error)")
            }
            
        }
        
        //let queryUser = PFUser.query()
    
//        queryUser?.limit = 3
//        for var j=0; j < self.finalArray.count; j++ {
//            queryUser?.whereKey("username", equalTo: self.finalArray[j].objectForKey("name")!)
//            queryUser?.findObjectsInBackgroundWithBlock { (success, error) -> Void in
//                if error == nil {
//                    let file: PFFile = queryUser?.valueForKey("profilePic") as! PFFile
//                    print("file \(file)")
//                    file.getDataInBackgroundWithBlock({
//                    (imageData, error) -> Void in
//                        if error == nil {
//                            let Image: UIImage = UIImage(data: imageData!)!
//                            print("Image \(Image)")
//                            if j == 1 {
//                                self.firstPlaceImg.image = Image
//                            } else if j == 2 {
//                                self.secondPlaceImg.image = Image
//                            } else if j == 3 {
//                                self.thirdPlaceImg.image = Image
//                            } else {
//                                hideHud(self.view)
//                            }
////                            hideHud(self.view)
//                        } else {
//                            print("Error \(error)")
//                        }
//                    })
//
//                } else{
//                    print("Error: \(error)")
//                }
//                
//            }
//        }

        displayFirstImg()
        displaySecondImg()
        displayThirdImg()
        
    }
    
    func displayFirstImg(){
        let queryUserPhoto = PFQuery(className: "UserPhotos")
        let userObj = PFQuery.getUserObjectWithId("OaCnKgyHhA")
        queryUserPhoto.whereKey("user", equalTo: userObj!)
        queryUserPhoto.addDescendingOrder("createdAt")
        queryUserPhoto.findObjectsInBackgroundWithBlock { (imgObjectArray, error) -> Void in
            if error == nil {
                self.pic = imgObjectArray
                print("pic \(self.pic)")
                
                let picObject:PFObject = (self.pic as! Array)[0]
                print("Most Recent picObject for \(userObj) was \(picObject)")
                
                let file: PFFile = picObject["userImg"] as! PFFile
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
            } else {
                print("Error: \(error)")
                UtilityClass.showAlert("Error: \(error)")
            }
        }
        
        
    } // END of displayFirstImg()
    
    
    func displaySecondImg(){
        let queryUserPhoto = PFQuery(className: "UserPhotos")
        let userObj = PFQuery.getUserObjectWithId("Ee1iMt5s9e")
        queryUserPhoto.whereKey("user", equalTo: userObj!)
        queryUserPhoto.addDescendingOrder("createdAt")
        queryUserPhoto.findObjectsInBackgroundWithBlock { (imgObjectArray, error) -> Void in
            if error == nil {
                self.pic = imgObjectArray
                print("pic \(self.pic)")
                
                let picObject:PFObject = (self.pic as! Array)[0]
                print("Most Recent picObject for \(userObj) was \(picObject)")
                
                let file: PFFile = picObject["userImg"] as! PFFile
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
            } else {
                print("Error: \(error)")
                UtilityClass.showAlert("Error: \(error)")
            }
        }
        
    } // END of displaySecondImg()
    
    
    func displayThirdImg(){
        let queryUserPhoto = PFQuery(className: "UserPhotos")
        queryUserPhoto.whereKey("user", equalTo: PFUser.currentUser()!)
        queryUserPhoto.addDescendingOrder("createdAt")
        queryUserPhoto.findObjectsInBackgroundWithBlock { (imgObjectArray, error) -> Void in
            if error == nil {
                self.pic = imgObjectArray
                print("pic \(self.pic)")
                
                let picObject:PFObject = (self.pic as! Array)[0]
                print("Most Recent picObject for \(PFUser.currentUser()) was \(picObject)")
                
                let file: PFFile = picObject["userImg"] as! PFFile
                print("file \(file)")
                
                file.getDataInBackgroundWithBlock({
                    (imageData, error) -> Void in
                    if error == nil {
                        let Image: UIImage = UIImage(data: imageData!)!
                        print("Image \(Image)")
                        self.thirdPlaceImg?.image = Image
                        //                        if self.firstPlaceImg?.image == nil {
                        //                            self.firstPlaceImg.image = Image
                        //                        }
                        hideHud(self.view)
                    } else {
                        print("Error \(error)")
                    }
                })
            } else {
                print("Error: \(error)")
                UtilityClass.showAlert("Error: \(error)")
            }
        }
        
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
