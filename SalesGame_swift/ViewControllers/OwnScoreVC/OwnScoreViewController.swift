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
    
    var arrWrongQuestion : NSMutableArray = []
    var arrOtherAns : NSMutableArray = []
    var achievements = Array(1...10).map( { Double($0) * 1 } )
    var achievement : Double?
   
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
        
    }
    
    
//==========================================================================================================================

// MARK: UIPickerView required methods

//==========================================================================================================================
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return achievements.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //return String(format: "%1.1f", achievements[row])
        return "achievement"
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let a : Double? = self.achievements[row]
        self.achievement = a
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
