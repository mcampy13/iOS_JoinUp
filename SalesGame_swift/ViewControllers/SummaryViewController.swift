//
//  SummaryViewController.swift
//  SalesGame_swift
//
//  Created by Robert Rock on 10/30/15.
//  Copyright © 2015 Akshay. All rights reserved.
//

import UIKit

class SummaryViewController: UIViewController {

    var playerScore:Int?
    var arrWrongQuestion : NSMutableArray = []
    var arrOtherAns : NSMutableArray = []
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var leaderBoardButton: UIBarButtonItem!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var reviewCorrectButton: UIButton!
    @IBOutlet weak var reviewIncorrectButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scoreLabel?.text = String(format: "%d", playerScore!)
        
        // Do any additional setup after loading the view.
    }
    

    //==========================================================================================================================
    
    // MARK: Actions
    
    //==========================================================================================================================
    
    @IBAction func backButton(sender: AnyObject) {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    
    @IBAction func leaderBoardButton(sender: AnyObject) {
        let highscoreViewController = self.storyboard?.instantiateViewControllerWithIdentifier("HighScoreViewController") as! HighScoreViewController
        self.navigationController?.pushViewController(highscoreViewController, animated: true)
    }
    
    
    @IBAction func doneButton(sender: AnyObject) {
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
    
    
    @IBAction func reviewCorrectButton(sender: AnyObject) {
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
    
    
    @IBAction func reviewIncorrectButton(sender: AnyObject) {
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
    
    
}
