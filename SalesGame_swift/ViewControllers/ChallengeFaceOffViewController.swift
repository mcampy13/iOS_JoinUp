//
//  ChallengeFaceOffViewController.swift
//  SalesGame_swift
//
//  Created by Robert Rock on 11/11/15.
//  Copyright © 2015 Akshay. All rights reserved.
//

import UIKit

class ChallengeFaceOffViewController: UIViewController {

    
    @IBOutlet weak var challengeSubCategoryLabel: UILabel!
    @IBOutlet weak var labelUsername1: UILabel!
    @IBOutlet weak var labelUsername2: UILabel!
    @IBOutlet weak var imgUsername1: UIImageView!
    @IBOutlet weak var imgUsername2: UIImageView!
    
    var pic:AnyObject?
    
    var challengeUser: String!
    var challengeUserId: String!
    var strMainCategory: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //NSThread .detachNewThreadSelector("showhud", toTarget: self, withObject: nil)
        UtilityClass.setMyViewBorder(imgUsername1, withBorder: 2, radius: 50)
        UtilityClass.setMyViewBorder(imgUsername2, withBorder: 2, radius: 50)

        self.labelUsername1?.text = PFUser.currentUser()?.objectForKey("username") as! String
        self.labelUsername2?.text = self.challengeUser
        
        displayUserImg()
        displayUserImg2()
    }

    func displayUserImg(){
        let queryUserPhoto = PFQuery(className: "UserPhotos")
        queryUserPhoto.whereKey("user", equalTo: PFUser.currentUser()!)
        queryUserPhoto.addDescendingOrder("createdAt")
        queryUserPhoto.findObjectsInBackgroundWithBlock { (imgObjectArray, error) -> Void in
            if error == nil {
                self.pic = imgObjectArray
                print("pic \(self.pic)")
                
                let picObject:PFObject = (self.pic as! Array)[0]
                print("Most Recent picObject \(picObject)")
                
                let file: PFFile = picObject["userImg"] as! PFFile
                print("file \(file)")
                
                file.getDataInBackgroundWithBlock({
                    (imageData, error) -> Void in
                    if error == nil {
                        let Image: UIImage = UIImage(data: imageData!)!
                        print("Image \(Image)")
                        self.imgUsername1.image = Image
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
        
    } // END of displayUserImg()
    
    func displayUserImg2(){
        let queryUserPhoto = PFQuery(className: "UserPhotos")
        let userObj = PFQuery.getUserObjectWithId("Ee1iMt5s9e")
        queryUserPhoto.whereKey("user", equalTo: userObj!)
        queryUserPhoto.addDescendingOrder("createdAt")
        queryUserPhoto.findObjectsInBackgroundWithBlock { (imgObjectArray, error) -> Void in
            if error == nil {
                self.pic = imgObjectArray
                print("pic \(self.pic)")
                
                let picObject:PFObject = (self.pic as! Array)[0]
                print("Most Recent picObject \(picObject)")
                
                let file: PFFile = picObject["userImg"] as! PFFile
                print("file \(file)")
                
                file.getDataInBackgroundWithBlock({
                    (imageData, error) -> Void in
                    if error == nil {
                        let Image: UIImage = UIImage(data: imageData!)!
                        print("Image \(Image)")
                        self.imgUsername2.image = Image
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
        
    } // END of displayUserImg2()

    
    
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
