//
//  FaceOffQuestionViewController.swift
//  SalesGame_swift
//
//  Created by Robert Rock on 11/13/15.
//  Copyright © 2015 Akshay. All rights reserved.
//

import UIKit

class FaceOffQuestionViewController: UIViewController {

    
    @IBOutlet weak var ImgUser1: UIImageView!
    @IBOutlet weak var labelUsername1: UILabel!
    @IBOutlet weak var lvlUsername1: UILabel!
    
    @IBOutlet weak var ImgUser2: UIImageView!
    @IBOutlet weak var labelUsername2: UILabel!
    @IBOutlet weak var lvlUsername2: UILabel!
    
    @IBOutlet weak var labelQuestionCount: UILabel!
    
    @IBOutlet weak var questionView: UILabel!
    
    @IBOutlet weak var optionAbutton: UIButton!
    @IBOutlet weak var optionBbutton: UIButton!
    @IBOutlet weak var optionCbutton: UIButton!
    @IBOutlet weak var optionDbutton: UIButton!
    @IBOutlet weak var button50: UIBarButtonItem!
    @IBOutlet weak var timerButton: UIBarButtonItem!
    @IBOutlet weak var passButton: UIBarButtonItem!
    
    @IBOutlet weak var labelTimer: UILabel!
    @IBOutlet weak var currentScore: UILabel!
    
    var posArray:[CGRect] = []
    var originalPosArray:[CGRect] = []
    
    var playerScore:Int = 0
    var playerName:String?
    
    var challengeUser: String!
    var challengeUserId: String!
    var challengeUserLevel: String!
    
    var questionImg: PFFile!
    var questionArray:NSArray!
    var timer:NSTimer!
    var questionTimer:Int = kQuestionTime
    var stringQuestionTimer: String?
    var currQuestionCount:Int = 1
    var totalQuestionCount:Int!
    
    var MainCategory: PFObject!
    var pic:AnyObject?
    
    var obj:PFObject!
    var arrWrongAns : NSMutableArray = []
    var arrHalfWrongAns : NSMutableArray = []
    var flagForWrongAnswerpush : Bool!
    var wrongAns: String!
    var oldScore : Int!
    var time: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //NSThread .detachNewThreadSelector("showhud", toTarget: self, withObject: nil)
        
        self.labelUsername1.text = PFUser.currentUser()?.valueForKey("username") as! String
        self.lvlUsername1.text = PFUser.currentUser()?.valueForKey("level") as? String
        
        self.labelUsername2.text = self.challengeUser as? String
        self.lvlUsername2.text = self.challengeUserLevel
        
        UtilityClass.setMyViewBorder(questionView, withBorder: 0, radius: 5)
        
        self.originalPosArray.insert(self.optionAbutton!.frame, atIndex: 0)
        self.originalPosArray.insert(self.optionBbutton!.frame, atIndex: 1)
        self.originalPosArray.insert(self.optionCbutton!.frame, atIndex: 2)
        self.originalPosArray.insert(self.optionDbutton!.frame, atIndex: 3)
        
        self.posArray.insert(self.originalPosArray[0], atIndex: 0)
        self.posArray.insert(self.originalPosArray[1], atIndex: 1)
        self.posArray.insert(self.originalPosArray[2], atIndex: 2)
        self.posArray.insert(self.originalPosArray[3], atIndex: 3)
        
        displayImgUser1()

        if flagForWrongAnswerpush == false {
            let queryQuestion = PFQuery(className: "Question")
            var files = []
            queryQuestion.limit = 10;
            queryQuestion.whereKey("parentSubCategory", equalTo: MainCategory)
            queryQuestion.findObjectsInBackgroundWithBlock { (objArray, error) -> Void in
                if error == nil {
                    for var i=0; i < objArray!.count; i++ {
                        print("Default questionTimer \(self.questionTimer)")
                        //print("query for timer: \(files[i].objectForKey("timer"))")
                        
                        self.stringQuestionTimer = files[i].objectForKey("timer") as? String
                        if self.stringQuestionTimer != nil {
                            print("stringQuestionTimer: \(self.stringQuestionTimer)")
                            self.labelTimer?.text = self.stringQuestionTimer
                        }
                    }
                    self.questionArray = objArray;
                    
                    self.nextQuestion(self.currQuestionCount)
                } else {
                    print("Error \(error)")
                }
            }
        }
            //when Review button press then this code called
        else {
            playerScore = oldScore
            //  var totalQuestionCount:Int = self.questionArray.count as Int
            self.nextQuestion(self.currQuestionCount)
        }

    }
    
    func displayAlert(title: String, error: String){
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: {action in
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }

    func displayImgUser1(){
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
                        self.ImgUser1.image = Image
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
        
    } // END of displayImgUser1()

    
    //==========================================================================================================================
    
    // MARK: methods for Next question
    
    //==========================================================================================================================
    
    //This method is used for run next question.
    func nextQuestion(questionNo:Int) {
        currentScore?.text = String(playerScore)
        print("In nextQuestion, currentScore \(currentScore)")
        if currQuestionCount > questionArray.count  {
            let ownScoreVC = self.storyboard?.instantiateViewControllerWithIdentifier("OwnScoreViewController") as! OwnScoreViewController
            
            ownScoreVC.questionArrayScore = self.questionArray
            ownScoreVC.playerScore = self.playerScore   // value sent to OwnScoreViewController
            
            ownScoreVC.strName = self.playerName
            ownScoreVC.arrWrongQuestion = self.arrWrongAns
            ownScoreVC.arrOtherAns = self.arrHalfWrongAns
            self.navigationController?.pushViewController(ownScoreVC, animated: true)
            
            if timer != nil {
                timer.invalidate()
            }
        }
        else {
            obj = nil;
            obj = (self.questionArray as! Array)[currQuestionCount - 1];
            
            wrongAns = obj.valueForKey("options")?.objectAtIndex(1) as! String
            questionView?.text = obj .valueForKey("questionText") as! String
            var ans:String = obj .valueForKey("answer") as! String
            if ans == obj.valueForKey("options")?.objectAtIndex(0) as! String {
                ans = "optionA"
            }
            else if ans == obj.valueForKey("options")?.objectAtIndex(1) as! String {
                ans = "optionB"
            }
            else if ans == obj.valueForKey("options")?.objectAtIndex(2) as! String {
                ans = "optionC"
            }
            else if ans == obj.valueForKey("options")?.objectAtIndex(3) as! String {
                ans = "optionD"
            }
            
            //Set Original Position
            optionAbutton?.frame = originalPosArray[0]
            optionBbutton?.frame = originalPosArray[1]
            optionCbutton?.frame = originalPosArray[2]
            optionDbutton?.frame = originalPosArray[3]
            
            
            // Originally the 'gray' was 'normal', effecting the buttons background color
            optionAbutton?.setBackgroundImage(UIImage(named: "normal"), forState: UIControlState.Normal)
            optionBbutton?.setBackgroundImage(UIImage(named: "normal"), forState: UIControlState.Normal)
            optionCbutton?.setBackgroundImage(UIImage(named: "normal"), forState: UIControlState.Normal)
            optionDbutton?.setBackgroundImage(UIImage(named: "normal"), forState: UIControlState.Normal)
            
            optionAbutton?.tag = 0
            optionBbutton?.tag = 0
            optionCbutton?.tag = 0
            optionDbutton?.tag = 0
            
            optionAbutton?.hidden = false
            optionBbutton?.hidden = false
            optionCbutton?.hidden = false
            optionDbutton?.hidden = false
                        
            optionAbutton?.setTitle(obj .valueForKey("options")?.objectAtIndex(0) as? String, forState: UIControlState.Normal)
            optionBbutton?.setTitle(obj .valueForKey("options")?.objectAtIndex(1) as? String, forState: UIControlState.Normal)
            optionCbutton?.setTitle(obj .valueForKey("options")?.objectAtIndex(2) as? String, forState: UIControlState.Normal)
            optionDbutton?.setTitle(obj .valueForKey("options")?.objectAtIndex(3) as? String, forState: UIControlState.Normal)
            
            if ans.rangeOfString("1") != nil {
                optionAbutton?.tag = 1
            }
            else if ans.rangeOfString("2") != nil {
                optionBbutton?.tag = 1
            }
            else if ans.rangeOfString("3") != nil {
                optionCbutton?.tag = 1
            }
            else if ans.rangeOfString("4") != nil {
                optionDbutton?.tag = 1
            }
            
            for idx in 0..<posArray.count {
                let rnd = Int(arc4random_uniform(UInt32(idx)))
                if rnd != idx {
                    swap(&posArray[idx], &posArray[rnd])
                }
            }
            
            //Set Random Position
            optionAbutton?.frame = posArray[0]
            optionBbutton?.frame = posArray[1]
            optionCbutton?.frame = posArray[2]
            optionDbutton?.frame = posArray[3]
            
            self.startTimer();
        }
    }
    

    //==========================================================================================================================
    
    // MARK: Methods for timer
    
    //==========================================================================================================================
    func startTimer() {
        questionTimer = kQuestionTime
        
        labelQuestionCount?.text = String(format: "%d/%d",currQuestionCount,questionArray.count)
        
        //if String(format: "%@", locale: NSUserDefaults.standardUserDefaults().valueForKey(kTimer) as? NSLocale) == "YES"
        //NSLog("%@",NSUserDefaults.standardUserDefaults().valueForKey(kTimer) as! String)
        if(NSUserDefaults.standardUserDefaults().valueForKey(kTimer) as! String  == "YES") {
            timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("updateTimer:"), userInfo: nil, repeats: true)
        } else {
            labelTimer?.hidden = true
            timerButton = nil
        }
        
    }
    
    func updateTimer(dt:NSTimer) {
        questionTimer--
        if questionTimer == 0 {
            currQuestionCount++
            
            NSLog("%d %d",currQuestionCount,questionArray.count)
            if currQuestionCount >= questionArray.count {
                NSLog("Game Over")
                let ownScoreVC = self.storyboard?.instantiateViewControllerWithIdentifier("OwnScoreViewController") as! OwnScoreViewController
                ownScoreVC.playerScore = self.playerScore
                ownScoreVC.strName = self.playerName
                ownScoreVC.arrWrongQuestion = self.arrWrongAns
                ownScoreVC.arrOtherAns = self.arrHalfWrongAns
                self.navigationController?.pushViewController(ownScoreVC, animated: true)
                
                if timer != nil {
                    timer.invalidate()
                }
                
            }
            else {
                if timer != nil {
                    timer.invalidate()
                }
                //questionTimer = kQuestionTime
                self.nextQuestion(currQuestionCount)
            }
        }
        else {
            self.labelTimer?.text = String(format: "%d",questionTimer)
        }
    }
    
    
    //==========================================================================================================================
    
    // MARK: Buttons for options
    
    //==========================================================================================================================
    
    
    @IBAction func optionAbuttonTap(sender: AnyObject) {
        if timer != nil {
            timer.invalidate()
        }
        
        if sender.tag == 1 {
            sender.setBackgroundImage(UIImage(named: "green"), forState: UIControlState.Normal)
            if flagForWrongAnswerpush == false {
                playerScore = playerScore + 10
            } else {
                playerScore = playerScore + 8
            }
        }
        else {
            if sender.titleLabel?!.text == wrongAns {
                arrWrongAns .addObject(obj)
                sender.setBackgroundImage(UIImage(named: "red"), forState: UIControlState.Normal)
                
                if flagForWrongAnswerpush == false {
                    playerScore--
                } else {
                    playerScore = playerScore - 2
                }
            }
            else {
                // playerScore = playerScore + 5
                arrHalfWrongAns.addObject(obj)
            }
            
            //var btn:UIButton = self.view.viewWithTag(1) as! UIButton
            //btn.setBackgroundImage(UIImage(named: "green"), forState: UIControlState.Normal)
        }
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW,
            Int64(2 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.currQuestionCount++
            self.nextQuestion(self.currQuestionCount)
        }
    }
    
    @IBAction func optionBbuttonTap(sender: AnyObject) {
        if timer != nil {
            timer.invalidate()
        }
        
        if sender.tag == 1 {
            sender.setBackgroundImage(UIImage(named: "green"), forState: UIControlState.Normal)
            if flagForWrongAnswerpush == false {
                playerScore = playerScore + 10
            } else {
                playerScore = playerScore + 8
            }
        }
        else {
            if sender.titleLabel?!.text == wrongAns {
                arrWrongAns .addObject(obj)
                sender.setBackgroundImage(UIImage(named: "red"), forState: UIControlState.Normal)
                if flagForWrongAnswerpush == false {
                    playerScore--
                } else {
                    playerScore = playerScore - 2
                }
            }
            else {
                // playerScore = playerScore + 5
                arrHalfWrongAns.addObject(obj)
            }
            
            //var btn:UIButton = self.view.viewWithTag(1) as! UIButton
            //btn.setBackgroundImage(UIImage(named: "green"), forState: UIControlState.Normal)
        }
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW,
            Int64(2 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.currQuestionCount++
            self.nextQuestion(self.currQuestionCount)
        }
    }
    
    @IBAction func optionCbuttonTap(sender: AnyObject) {
        if timer != nil {
            timer.invalidate()
        }
        
        if sender.tag == 1 {
            sender.setBackgroundImage(UIImage(named: "green"), forState: UIControlState.Normal)
            if flagForWrongAnswerpush == false {
                playerScore = playerScore + 10
            } else {
                playerScore = playerScore + 8
            }
        }
        else {
            if sender.titleLabel?!.text == wrongAns {
                arrWrongAns .addObject(obj)
                sender.setBackgroundImage(UIImage(named: "red"), forState: UIControlState.Normal)
                if flagForWrongAnswerpush == false {
                    playerScore--
                } else {
                    playerScore = playerScore - 2
                }
            }
            else {
                // playerScore = playerScore + 5
                arrHalfWrongAns.addObject(obj)
            }
            
            //var btn:UIButton = self.view.viewWithTag(1) as! UIButton
            //btn.setBackgroundImage(UIImage(named: "green"), forState: UIControlState.Normal)
        }
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW,
            Int64(2 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.currQuestionCount++
            self.nextQuestion(self.currQuestionCount)
        }
    }
    
    @IBAction func optionDbuttonTap(sender: AnyObject) {
        if timer != nil {
            timer.invalidate()
        }
        if sender.tag == 1 {
            sender.setBackgroundImage(UIImage(named: "green"), forState: UIControlState.Normal)
            if flagForWrongAnswerpush == false {
                playerScore = playerScore + 10
            } else {
                playerScore = playerScore + 8
            }
        }
        else {
            if sender.titleLabel?!.text == wrongAns {
                arrWrongAns .addObject(obj)
                sender.setBackgroundImage(UIImage(named: "red"), forState: UIControlState.Normal)
                if flagForWrongAnswerpush == false {
                    playerScore--
                } else {
                    playerScore = playerScore - 2
                }
            }
            else {
                //playerScore = playerScore + 5
                arrHalfWrongAns.addObject(obj)
            }
            
            //var btn:UIButton = self.view.viewWithTag(1) as! UIButton
            //btn.setBackgroundImage(UIImage(named: "green"), forState: UIControlState.Normal)
            
        }
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW,
            Int64(2 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.currQuestionCount++
            self.nextQuestion(self.currQuestionCount)
        }

    }
    
 
    //==========================================================================================================================
    
    // MARK: Actions
    
    //==========================================================================================================================
    
    @IBAction func button50(sender: AnyObject) {
        let ff = NSUserDefaults.standardUserDefaults().valueForKey(kFiftyFiftyCount) as! String
        var ffInt = Int(ff)
        ffInt?--
        let ffString = String(format: "%d", ffInt!)
        NSUserDefaults.standardUserDefaults().setValue(ffString, forKey: kFiftyFiftyCount)
        //button50.setTitleTextAttributes("50-50", forState: UIControlState.Normal)
        button50.title = "50-50"

        if optionAbutton?.tag == 1 {
            optionCbutton?.hidden = true
            optionDbutton?.hidden = true
        }
        else if optionBbutton?.tag == 1 {
            optionAbutton?.hidden = true
            optionCbutton?.hidden = true
        }
        else if optionCbutton?.tag == 1 {
            optionAbutton?.hidden = true
            optionDbutton?.hidden = true
        }
        else if optionDbutton?.tag == 1 {
            optionAbutton?.hidden = true
            optionBbutton?.hidden = true
        }
        
        button50?.tintColor = UIColor.clearColor()
    }
    
    @IBAction func timerButton(sender: AnyObject) {
        let time = NSUserDefaults.standardUserDefaults().valueForKey(kTimerCount) as! String
        var ffTimeInt = Int(time)
        ffTimeInt?--
        let ffSkipString = String(format: "%d", ffTimeInt!)
        NSUserDefaults.standardUserDefaults().setValue(ffSkipString, forKey: kTimerCount)
        timerButton!.title = " "
        
        if timer != nil {
            timer.invalidate()
        }
        //timerButton hide ??
    }
    
    
    @IBAction func passButton(sender: AnyObject) {
//        let skip = NSUserDefaults.standardUserDefaults().valueForKey(kSkipCount) as! String
//        var ffSkipInt = Int(skip)
//        ffSkipInt?--
//        let ffSkipString = String(format: "%d", ffSkipInt!)
//        NSUserDefaults.standardUserDefaults().setValue(ffSkipString, forKey: kSkipCount)
//        //btnSkip?.setTitle(String(format: "SKIP : %@",NSUserDefaults.standardUserDefaults().valueForKey(kSkipCount)as! String), forState: UIControlState.Normal)
//        btnSkip!.setTitle("SKIP", forState: UIControlState.Normal)
//        //if ffSkipInt >= 0
//        //{
//        if timer != nil {
//            timer.invalidate()
//        }
//        self.currQuestionCount++
//        self.nextQuestion(self.currQuestionCount)
//        //}
//        
//        btnSkip?.hidden = true
        let homeVC = self.storyboard?.instantiateViewControllerWithIdentifier("HomeViewController") as! HomeViewController
        self.navigationController?.pushViewController(homeVC, animated: true)
    }
    
    
    //==========================================================================================================================
    
    // MARK: Progress hud display methods
    
    //==========================================================================================================================
    
    func showhud() {
        showHud(self.view)
    }

}
