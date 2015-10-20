//
//  OwnScoreViewController.swift
//  SalesGame_swift
//
//  Created by Akuma on 9/13/15.
//  Copyright (c) 2015 Akuma. All rights reserved.
//

import UIKit

class OwnScoreViewController: UIViewController {

    @IBOutlet weak var lblScore: UILabel?
    var playerScore:Int?
    var strName : String?
    @IBOutlet var btnHome : UIButton!
    @IBOutlet var btnLeaderBoard : UIButton!
    @IBOutlet var btnWrongAns : UIButton!
    @IBOutlet var btnOtherAns : UIButton!
    
    var arrWrongQuestion : NSMutableArray = []
    var arrOtherAns : NSMutableArray = []
   
//==========================================================================================================================

// MARK: Life Cycle methods

//==========================================================================================================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblScore?.text = String(format: "%d", playerScore!)
    }
    
//==========================================================================================================================

// MARK: IBAction for Buttons

//==========================================================================================================================
    
    @IBAction func btnHomeTap(sender: UIButton) {
        kTimeForWrongTime = 0
        let testObject = PFObject(className: "score")
        testObject["UserObjectID"] = NSUserDefaults .standardUserDefaults().valueForKey(kLoggedInUserId)
        let score = playerScore
        testObject["UserScore"] = score
        testObject["Name"] = NSUserDefaults .standardUserDefaults().objectForKey(kLoggedInUserName)
        // testObject.saveInBackground()
        testObject.saveInBackgroundWithBlock { (success, error) -> Void in
            if success {
                let arr : NSArray = self.navigationController!.viewControllers
                
                self.navigationController!.popToViewController(arr.objectAtIndex(1) as! UIViewController, animated: true)
            }
        }
    }

    @IBAction func btnScoreboardTap(sender: UIButton) {
        kTimeForWrongTime = 0
        let testObject = PFObject(className: "score")
        testObject["UserObjectID"] = NSUserDefaults .standardUserDefaults().valueForKey(kLoggedInUserId)
        let score = playerScore
        testObject["UserScore"] = score
        testObject["Name"] = NSUserDefaults .standardUserDefaults().objectForKey(kLoggedInUserName)
        testObject.saveInBackgroundWithBlock { (success, error) -> Void in
            if success {
                let highscoreViewController = self.storyboard?.instantiateViewControllerWithIdentifier("HighScoreViewController") as! HighScoreViewController
                self.navigationController?.pushViewController(highscoreViewController, animated: true)
            }
        }
    }
    
//==========================================================================================================================

// MARK: IBAction for Wrong answer

//==========================================================================================================================
    @IBAction func btnWrongAns(sender: UIButton) {
        kTimeForWrongTime = kTimeForWrongTime + 1
        if kTimeForWrongTime <= 2 {
            if arrWrongQuestion.count > 0 {
                let questionVC = self.storyboard?.instantiateViewControllerWithIdentifier("QuestionViewController") as? QuestionViewController
                questionVC?.questionArray = arrWrongQuestion
                questionVC?.flagForWrongAnswerpush = true
                questionVC!.oldScore = playerScore
                self.navigationController!.pushViewController(questionVC!, animated:true)
            } else {
                let alertController = UIAlertController(title: "Alert", message:
                    "No Wrong answered question available!", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
        else {
            let alertController = UIAlertController(title: "Alert", message:
                "Game Over!", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }

//==========================================================================================================================

// MARK: IBAction for other Answer clicked

//==========================================================================================================================
    @IBAction func btnOtherAns(sender: UIButton) {
        kTimeForWrongTime = kTimeForWrongTime + 1
        if kTimeForWrongTime <= 2 {
            
            if arrOtherAns.count > 0 {
                let questionVC = self.storyboard?.instantiateViewControllerWithIdentifier("QuestionViewController") as? QuestionViewController
                questionVC?.questionArray = arrOtherAns
                questionVC?.flagForWrongAnswerpush = true
                questionVC!.oldScore = playerScore
                self.navigationController!.pushViewController(questionVC!, animated:true)
            }
            else {
                let alertController = UIAlertController(title: "Alert", message:
                    "No Wrong answered question available!", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
        else {
            let alertController = UIAlertController(title: "Alert", message:
                "Game Over!", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
}
