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
    
    @IBOutlet weak var playerImg: UIImageView!
    @IBOutlet weak var labelUsername: UILabel!
    @IBOutlet weak var labelMessageToUser: UILabel!
    
    
    var game: PFObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.labelUsername?.text = PFUser.currentUser()!.username
        scoreLabel?.text = String(format: "%d", playerScore!)
        UtilityClass.setMyViewBorder(playerImg, withBorder: 0, radius: 50)
        
        displayUserImg()
        
        if self.playerScore == 0 {
            self.labelMessageToUser?.text = "That's too bad, we had high hopes for you!"
        } else if self.playerScore > 0 || self.playerScore < 30 {
            self.labelMessageToUser?.text = "Not too bad there. Now try to get a 100% !"
        } else {
            self.labelMessageToUser?.text = "Wow! Congratulations, I guess you don't need any help!"
        }
        
        kTimeForWrongTime = 0
        let score = playerScore
        let scoreObject = PFObject(className: "Score")
        
        scoreObject["user"] = PFUser.currentUser()
        scoreObject["name"] = PFUser.currentUser()?.objectForKey("username")
        scoreObject["score"] = score
        
        scoreObject.saveInBackgroundWithBlock { (success, error) -> Void in
            if success {
                self.game.saveInBackgroundWithBlock { (gameSuccess, error) -> Void in
                    if error == nil {
                        print("Game Saved")
                    } else {
                        print("Error saving game: \(error)")
                    }
                }
            }
        }
    }
    
    func displayUserImg(){
        let query = PFQuery.getUserObjectWithId(PFUser.currentUser()!.objectId!)
        
        let file: PFFile = query?.valueForKey("profilePic") as! PFFile
        print("file \(file)")
        file.getDataInBackgroundWithBlock({
            (imageData, error) -> Void in
            if error == nil {
                let Image: UIImage = UIImage(data: imageData!)!
                print("Image \(Image)")
                self.playerImg.image = Image
            } else {
                print("Error \(error)")
            }
        })
        
    } // END of displayUserImg()

    

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
        let homeVC = self.storyboard?.instantiateViewControllerWithIdentifier("HomeViewController") as! HomeViewController
        self.navigationController?.pushViewController(homeVC, animated: true)
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
