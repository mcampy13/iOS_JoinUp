//
//  OwnScoreViewController.swift
//  SalesGame_swift
//
//  Created by Akuma on 9/13/15.
//  Copyright (c) 2015 Akuma. All rights reserved.
//

import UIKit

class OwnScoreViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var lblScore: UILabel?
    var playerScore:Int?
    var strName : String?
    @IBOutlet weak var leaderBoardButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var summaryButton: UIButton!
    @IBOutlet weak var achievementsPickerView: UIPickerView!
    @IBOutlet weak var badgePickerViewLabel: UILabel!
    
    var questionArrayScore:NSArray!
    var badgeName: String!

    var arrWrongQuestion : NSMutableArray = []
    var arrOtherAns : NSMutableArray = []
    var achievements = Array(1...10).map( { Double($0) * 1 } )
    var achievement : Double?
    
    var badges = [String]()
   
//==========================================================================================================================

// MARK: Life Cycle methods

//==========================================================================================================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        var queryScore = PFQuery(className: "score")
//        queryScore.whereKey("UserObjectID", equalTo: (PFUser.currentUser()?.objectId)!)
//        queryScore.findObjectsInBackgroundWithBlock { (success, error) -> Void in
//            if error == nil {
//                print("queryScore \(success)")
//            } else {
//                print("Error \(error)")
//            }
//        }
        lblScore?.text = String(format: "%d", playerScore!)
        UtilityClass.setMyViewBorder(lblScore, withBorder: 0, radius: 50)

        
        checkHonorableMention()
        if badges.count > 0 {
            self.badgePickerViewLabel.text = "Congratulations on WINNING Badges!"
        } else {
            self.badgePickerViewLabel.text = "Sorry, no new badges for you"
        }
        
        
        
    }
    
    
//==========================================================================================================================

// MARK: UIPickerView required methods

//==========================================================================================================================
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return badges.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //return String(format: "%1.1f", achievements[row])
        //return "achievement"
        return String(badges[row])
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let a : Double? = self.achievements[row]
        self.achievement = a
    }
    
    func checkHonorableMention(){
        let totalPossible = self.questionArrayScore.count * 10
        if self.playerScore == totalPossible {
            print("You won Honorable Mention !")
            self.badgeName = "Honorable Mention"
            self.addBadge(self.badgeName)
            self.badges.append(self.badgeName)
        } else {
            print("error")
        }
    }
    
    func addBadge(badgeName: String){
        
        let UserBadge = PFObject(className: "UserBadges")
        let query = PFQuery(className: "Badges")
        query.whereKey(badgeName, equalTo: "HonorableMention")
        query.findObjectsInBackgroundWithBlock{ (badgeObjArray, error) -> Void in
            if error == nil{
                //UserBadge["badge"] = badgeObjArray![0]
                print("badge found")
                UserBadge["badgeName"] = badgeName
                UserBadge["createdBy"] = PFUser.currentUser()
//                UserBadge["badge"] = badgeObjArray![0])
                UserBadge.saveInBackgroundWithBlock{ (success, error) -> Void in
                    if error == nil {
                        print("Badge successfully saved!")
                    } else{
                        print("Error saving badge \(error)")
                    }
                
                }
                
            } else{
                print("Error in addBadge \(error)")
            }
        
        }
    }
    
//==========================================================================================================================

// MARK: IBAction for Buttons

//==========================================================================================================================
    
    @IBAction func summaryButton(sender: AnyObject) {
        //UtilityClass.showAlert("Summary")
        let summaryVC = self.storyboard?.instantiateViewControllerWithIdentifier("SummaryViewController") as! SummaryViewController
        summaryVC.playerScore = self.playerScore
        summaryVC.arrWrongQuestion = self.arrWrongQuestion
        summaryVC.arrOtherAns = self.arrOtherAns
        self.navigationController?.pushViewController(summaryVC, animated: true)
    }
    
    
    @IBAction func leaderBoardButton(sender: AnyObject) {
        kTimeForWrongTime = 0
        let score = playerScore
        let scoreObject = PFObject(className: "Score")
        
        scoreObject["user"] = PFUser.currentUser()?.objectId
        scoreObject["name"] = PFUser.currentUser()?.objectForKey("username")
        scoreObject["score"] = score
        
        scoreObject.saveInBackgroundWithBlock { (success, error) -> Void in
            if success {
                let highscoreViewController = self.storyboard?.instantiateViewControllerWithIdentifier("HighScoreViewController") as! HighScoreViewController
                self.navigationController?.pushViewController(highscoreViewController, animated: true)
            }
        }
    }
    
    
    @IBAction func saveButton(sender: AnyObject) {
        kTimeForWrongTime = 0
        let score = playerScore
        let scoreObject = PFObject(className: "Score")
        
        scoreObject["user"] = PFUser.currentUser()
        scoreObject["name"] = PFUser.currentUser()?.objectForKey("username")
        scoreObject["score"] = score
        
        scoreObject.saveInBackgroundWithBlock { (success, error) -> Void in
            if success {
                let arr : NSArray = self.navigationController!.viewControllers
                
                self.navigationController!.popToViewController(arr.objectAtIndex(1) as! UIViewController, animated: true)
            }
        }
    }
    
    
}
