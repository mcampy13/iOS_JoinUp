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
    @IBOutlet weak var labelMyLevel: UILabel!
    @IBOutlet weak var labelOpponentLevel: UILabel!
    
    
    var pic:AnyObject?
    
    var MainCategory: PFObject!
    
    var suc: AnyObject?
    var playerLevel: Int?
    
    var challengeUser: String!
    var challengeUserId: String!
    var challengeUserLevel: Int?
    var strMainCategory: String!
    var intLevel: NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //NSThread .detachNewThreadSelector("showhud", toTarget: self, withObject: nil)
        UtilityClass.setMyViewBorder(imgUsername1, withBorder: 1, radius: 50)
        UtilityClass.setMyViewBorder(imgUsername2, withBorder: 1, radius: 50)

        self.labelUsername1?.text = PFUser.currentUser()?.objectForKey("username") as? String
        let level = PFUser.currentUser()!.objectForKey("level")
        self.playerLevel = level as? Int
        self.labelMyLevel?.text = String(format: "%d", self.playerLevel!)
        
        self.labelUsername2?.text = self.challengeUser
       // self.labelOpponentLevel?.text = self.challengeUserLevel as! String
    
        displayMe()
        displayOpponent()
        
        let queryLvl = PFUser.query()!.whereKey("objectId", equalTo: challengeUserId)
        queryLvl.findObjectsInBackgroundWithBlock { (success, error) -> Void in
            if error == nil {
                self.suc = success
                //print("success: \(self.suc)")
                let intChallengeUserLevel = self.suc![0].objectForKey("level")
                self.challengeUserLevel = intChallengeUserLevel as? Int
                self.labelOpponentLevel?.text = String(format: "%d", self.challengeUserLevel!)
                //print("challengeUserLevel: \(self.challengeUserLevel)")

            } else{
                print("Error getting level: \(error)")
            }
        }
    }

    func displayMe(){
        let userObj = PFQuery.getUserObjectWithId((PFUser.currentUser()?.objectId)!)
        
        let file: PFFile = userObj?.valueForKey("profilePic") as! PFFile
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
    } // END of displayMe()
    
    func displayOpponent(){
        let userObj = PFQuery.getUserObjectWithId(challengeUserId)
        
        let file: PFFile = userObj?.valueForKey("profilePic") as! PFFile
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
    } // END of displayOpponent()

    
    
    //==========================================================================================================================
    
    // MARK: Actions
    
    //==========================================================================================================================
    
    @IBAction func homeButton(sender: AnyObject) {
        let homeVC = self.storyboard?.instantiateViewControllerWithIdentifier("HomeViewController") as? HomeViewController
        self.navigationController?.pushViewController(homeVC!, animated: true)
    }
    
    @IBAction func backButton(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func playButton(sender: AnyObject) {
        let faceOffQuestionVC = self.storyboard?.instantiateViewControllerWithIdentifier("FaceOffQuestionViewController") as? FaceOffQuestionViewController
        let obj:PFObject = self.MainCategory
        faceOffQuestionVC?.challengeUser = self.challengeUser
        let level = self.challengeUserLevel
        faceOffQuestionVC?.challengeUserLevel = level
        faceOffQuestionVC?.challengeUserId = self.challengeUserId
        faceOffQuestionVC?.MainCategory = obj
        faceOffQuestionVC?.flagForWrongAnswerpush = false
        self.navigationController!.pushViewController(faceOffQuestionVC!, animated:true)

    }
    
    //==========================================================================================================================
    
    // MARK: Progress hud display methods
    
    //==========================================================================================================================
    
    func showhud() {
        showHud(self.view)
    }


}
