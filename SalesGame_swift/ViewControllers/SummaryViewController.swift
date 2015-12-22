//
//  SummaryViewController.swift
//  SalesGame_swift
//
//  Created by Robert Rock on 10/30/15.
//  Copyright © 2015 Akshay. All rights reserved.
//

import UIKit

class SummaryViewController: UIViewController, UINavigationControllerDelegate {

    var playerScore:Int?
    var arrWrongQuestion : NSMutableArray = []
    var arrOtherAns : NSMutableArray = []
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var playerImg: UIImageView!
    @IBOutlet weak var labelUsername: UILabel!
    @IBOutlet weak var labelMessageToUser: UILabel!
    
<<<<<<< HEAD
=======
    @IBOutlet weak var homeButton: UIButton!
>>>>>>> d6e906b4510cf39f9ffcbdd178848ad1fce0298e
    
    var game: PFObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.barTintColor = UIColor.orangeColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        self.labelUsername?.text = PFUser.currentUser()!.username
        scoreLabel?.text = String(format: "%d/%d", playerScore!, 10 * (self.arrOtherAns.count + self.arrWrongQuestion.count))
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
    
    // MARK: Navigation
    
    //==========================================================================================================================
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueCheckAnswers" {
            let checkAnswersVC = segue.destinationViewController as! CheckAnswersViewController
            checkAnswersVC.wrongAnswers = self.arrWrongQuestion
            checkAnswersVC.correctAnswers = self.arrOtherAns
        }
        
    }
    

    //==========================================================================================================================
    
    // MARK: Actions
    
    //==========================================================================================================================
    
<<<<<<< HEAD
    @IBAction func doneButton(sender: AnyObject) {
=======
    @IBAction func homeButtonTapped(sender: AnyObject) {
>>>>>>> d6e906b4510cf39f9ffcbdd178848ad1fce0298e
        let homeVC = self.storyboard?.instantiateViewControllerWithIdentifier("HomeViewController") as! HomeViewController
        self.navigationController?.pushViewController(homeVC, animated: true)
    }
    
<<<<<<< HEAD
    
=======
>>>>>>> d6e906b4510cf39f9ffcbdd178848ad1fce0298e
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
