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
    
    @IBOutlet weak var BadgeImg: UIImageView!
    
    var questionArrayScore:NSArray!
    var badgeName: String!

    var arrWrongQuestion : NSMutableArray = []
    var arrOtherAns : NSMutableArray = []
    var achievements = Array(1...10).map( { Double($0) * 1 } )
    var achievement : Double?
    
    var game: PFObject!
    
    var badges = [String]()
    var category: AnyObject?
    

//==========================================================================================================================

// MARK: Life Cycle methods

//==========================================================================================================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let score = self.playerScore
        //let scoreObject = PFObject(className: "Score")
        
        UtilityClass.setMyViewBorder(BadgeImg, withBorder: 0, radius: 60)
        
//        scoreObject["user"] = PFUser.currentUser()?.objectId
//        scoreObject["name"] = PFUser.currentUser()?.objectForKey("username")
//        scoreObject["score"] = score
//        
//        scoreObject.saveInBackgroundWithBlock { (success, error) -> Void in
//            if error == nil {
//                print("Saved")
//                print("success for scoreObject saveInBackground \(success)")
//            } else {
//                print("Error: \(error)")
//            }
//        }
//        
        lblScore?.text = String(format: "%d", playerScore!)
        UtilityClass.setMyViewBorder(lblScore, withBorder: 0, radius: 50)
        
        checkHonorableMention()
        checkLongHoursGuy()
        
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
        return String(badges[row])
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let a : Double? = self.achievements[row]
        self.achievement = a
    }
    
    func checkLongHoursGuy(){
        let totalPossible = self.questionArrayScore.count * 10
        if self.playerScore == totalPossible {
            print("You won: Long Hours Guy!")
            self.badgeName = "Long Hours Guy"
            self.game.addUniqueObject(self.badgeName, forKey: "badgesWonInGame")
            self.addBadge(self.badgeName)
            self.badges.append(self.badgeName)
        } else {
            print("Didn't earn checkLongHoursGuy")
        }
    }
    
    func checkHonorableMention(){
        let totalPossible = self.questionArrayScore.count * 10
        if self.playerScore < totalPossible && self.playerScore > 0 {
            print("You won Honorable Mention !")
            self.badgeName = "Honorable Mention"
            self.game.addUniqueObject(self.badgeName, forKey: "badgesWonInGame")
            self.addBadge(self.badgeName)
            self.badges.append(self.badgeName)
        } else {
            print("Didn't earn checkHonorableMention")
        }
    }
    
    func addBadge(addBadgeName: String){
        
        let UserBadge = PFObject(className: "UserBadges")
        let query = PFQuery(className: "Badges")
        //query.whereKey(badgeName, equalTo: "Honorable Mention")
        query.findObjectsInBackgroundWithBlock{ (badgeObjArray, error) -> Void in
            if error == nil{
                print("badge found")
                UserBadge["badgeName"] = addBadgeName
                UserBadge["createdBy"] = PFUser.currentUser()
                UserBadge["badge"] = badgeObjArray![0]
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
        let summaryVC = self.storyboard?.instantiateViewControllerWithIdentifier("SummaryViewController") as! SummaryViewController
        summaryVC.playerScore = self.playerScore
        summaryVC.arrWrongQuestion = self.arrWrongQuestion
        summaryVC.arrOtherAns = self.arrOtherAns
        summaryVC.game = self.game
        self.navigationController?.pushViewController(summaryVC, animated: true)
    }
    
    
    @IBAction func leaderBoardButton(sender: AnyObject) {
        kTimeForWrongTime = 0
        let highscoreViewController = self.storyboard?.instantiateViewControllerWithIdentifier("HighScoreViewController") as! HighScoreViewController
        self.navigationController?.pushViewController(highscoreViewController, animated: true)
    }
    
    
    @IBAction func saveButton(sender: AnyObject) {
        kTimeForWrongTime = 0
        let score = playerScore
        let scoreObject = PFObject(className: "Score")
        
        scoreObject["user"] = PFUser.currentUser()!
        scoreObject["name"] = PFUser.currentUser()?.objectForKey("username")
        scoreObject["score"] = score
        
        scoreObject.saveInBackgroundWithBlock { (success, error) -> Void in
            if error == nil {
                self.game.saveInBackgroundWithBlock { (gameSuccess, error) -> Void in
                    if error == nil {
                        print("Game Saved")
                        let homeVC = self.storyboard?.instantiateViewControllerWithIdentifier("HomeViewController") as? HomeViewController
                        self.navigationController?.pushViewController(homeVC!, animated: true)

                    } else {
                        print("Error saving game: \(error)")
                    }
                }
            } else{
                print("Error: \(error)")
            }
        }
    }
    
    
}
