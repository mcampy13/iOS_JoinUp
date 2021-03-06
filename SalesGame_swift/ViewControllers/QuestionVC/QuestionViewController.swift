//
//  QuestionViewController.swift
//  SalesGame_swift
//
//  Created by Akuma on 9/11/15.
//  Copyright (c) 2015 Akuma. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox

class QuestionViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var lblTimer: UILabel?
    @IBOutlet weak var lblOutof: UILabel?
    @IBOutlet weak var quitButton: UIBarButtonItem!
    @IBOutlet weak var soundButton: UIBarButtonItem!

    //@IBOutlet weak var btnSound: UIButton?
    @IBOutlet weak var txtQuestionView:UITextView?
    @IBOutlet weak var btnOption1:UIButton?
    @IBOutlet weak var btnOption2:UIButton?
    @IBOutlet weak var btnOption3:UIButton?
    @IBOutlet weak var btnOption4:UIButton?
    @IBOutlet weak var btnFiftyFifty:UIButton?
    @IBOutlet weak var btnSkip:UIButton?
    @IBOutlet weak var btnTimer:UIButton?
    @IBOutlet weak var getHelpButton: UIButton!
    
    
    @IBOutlet weak var questionImage:UIImageView?
    
    @IBOutlet weak var currentScore : UILabel?
    //@IBOutlet weak var adBannerView:GADBannerView?
    let synth = AVSpeechSynthesizer()
    var myUtterance = AVSpeechUtterance(string: "")
    var isSound:Bool = true
    
    //position array
    var posArray:[CGRect] = []
    var originalPosArray:[CGRect] = []
    
    
    var playerScore:Int = 0
    var playerName:String?
    var alertTextbox:UITextField?
    //Object for Admob
    
    var questionImg: PFFile!
    var questionArray:NSArray!
    var passingScore: Int!
    var timer:NSTimer!
    var questionTimer:Int = kQuestionTime
    var stringQuestionTimer: String?
    var currQuestionCount:Int = 1
    var totalQuestionCount:Int!
   
    var MainCategory: PFObject!
    var PFsubCategory: PFObject!
    
    var game: PFObject!
    
    var obj:PFObject!
    var arrWrongAns : NSMutableArray = []
    var arrHalfWrongAns : NSMutableArray = []
    var flagForWrongAnswerpush : Bool!
    var wrongAns: String!
    var oldScore : Int!
    var time: String?

//==========================================================================================================================

// MARK: Life Cycle methods

//==========================================================================================================================

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor.orangeColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        UtilityClass.setMyViewBorder(txtQuestionView, withBorder: 0, radius: 5)
        UtilityClass.setMyViewBorder(btnOption1, withBorder: 0, radius: 10)
        UtilityClass.setMyViewBorder(btnOption2, withBorder: 0, radius: 10)
        UtilityClass.setMyViewBorder(btnOption3, withBorder: 0, radius: 10)
        UtilityClass.setMyViewBorder(btnOption4, withBorder: 0, radius: 10)
        UtilityClass.setMyViewBorder(btnFiftyFifty, withBorder: 0, radius: 15)
        UtilityClass.setMyViewBorder(btnSkip, withBorder: 0, radius: 15)
        UtilityClass.setMyViewBorder(btnTimer, withBorder: 0, radius: 15)
        
        self.originalPosArray.insert(self.btnOption1!.frame, atIndex: 0)
        self.originalPosArray.insert(self.btnOption2!.frame, atIndex: 1)
        self.originalPosArray.insert(self.btnOption3!.frame, atIndex: 2)
        self.originalPosArray.insert(self.btnOption4!.frame, atIndex: 3)
        
        self.posArray.insert(self.originalPosArray[0], atIndex: 0)
        self.posArray.insert(self.originalPosArray[1], atIndex: 1)
        self.posArray.insert(self.originalPosArray[2], atIndex: 2)
        self.posArray.insert(self.originalPosArray[3], atIndex: 3)
        
        self.btnFiftyFifty?.setTitle("50-50",forState: UIControlState.Normal)
        self.btnSkip?.setTitle("SKIP",forState: UIControlState.Normal)
        self.btnTimer?.setTitle("TIMER", forState: UIControlState.Normal)

        if flagForWrongAnswerpush == false {
            let queryQuestion = PFQuery(className: "Question")
            var files = []
            queryQuestion.limit = 10;
            queryQuestion.whereKey("parentSubCategory", equalTo: MainCategory)
            queryQuestion.findObjectsInBackgroundWithBlock { (objArray, error) -> Void in
                if error == nil {
                    
                    self.passingScore = self.MainCategory["minPassingScore"] as! Int
                    print("passingScore : \(self.passingScore)")
                    
                    for var i=0; i < objArray!.count; i++ {
                        print("objArray questionFile: \(objArray![i].objectForKey("questionFile"))")
                        files = objArray!
                        self.questionImage?.image = files[i].objectForKey("questionFile") as? UIImage
                        
                        print("Default questionTimer \(self.questionTimer)")
                        //print("query for timer: \(files[i].objectForKey("timer"))")
                        
                        self.stringQuestionTimer = files[i].objectForKey("timer") as? String
                        if self.stringQuestionTimer != nil {
                            print("stringQuestionTimer: \(self.stringQuestionTimer)")
                            self.lblTimer?.text = self.stringQuestionTimer
                        }
                    }
                    self.questionArray = objArray;
                    
                    //print("question Array \(self.questionArray)")
                    
//                    if let objArray = objArray as! [PFObject]? {
//                        for object in objArray {
//                            print(object.objectForKey("questionFile"))
//                            self.questionImg = object.objectForKey("questionFile") as! PFFile
//                            let questionImageFile = object.objectForKey("questionFile") as? PFFile
//                            questionImageFile!.getDataInBackgroundWithBlock {
//                                (imageData, error) -> Void in
//                                if error == nil {
//                                    if let imageData = imageData {
//                                        let image = UIImage(data:imageData)
//                                        print("image \(image)")
//                                    }
//                                }
//                            }
//                        }
//                    }
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


//==========================================================================================================================
    
// MARK: Navigation
    
//==========================================================================================================================

    @IBAction func unwindFromGameStart(sender: UIStoryboardSegue){
        if let sourceViewController = sender.sourceViewController as? SelectSubCategoryViewController, fromCategory = sourceViewController.PFcategory, fromSubCategory = sourceViewController.PFSubCategory, game = sourceViewController.game {
            self.MainCategory = fromCategory
            self.PFsubCategory = fromSubCategory
            self.flagForWrongAnswerpush = false
            self.game = game
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueOwnScore" {
            
            let ownScoreVC = segue.destinationViewController as? OwnScoreViewController
            
            ownScoreVC?.questionArrayScore = self.questionArray
            ownScoreVC?.playerScore = self.playerScore
            ownScoreVC?.category = self.MainCategory
            ownScoreVC?.strName = self.playerName
            ownScoreVC?.arrWrongQuestion = self.arrWrongAns
            ownScoreVC?.arrOtherAns = self.arrHalfWrongAns
            ownScoreVC?.game = self.game
            
            print("Went to OwnScore with arrWrongQuestion: \(self.arrWrongAns) and arrOtherAns: \(self.arrHalfWrongAns)")
        }
    }
    
    
//==========================================================================================================================

// MARK: Next question & redirect if questions are completed

//==========================================================================================================================
    
    func nextQuestion(questionNo:Int) {
        currentScore?.text = String(playerScore)
        print("In nextQuestion, currentScore \(currentScore)")

        if currQuestionCount > questionArray.count  {
            
            let scoreAsDouble: Double = Double(self.passingScore)
            let playerScoreDouble: Double = Double(self.playerScore)
            
            if (playerScoreDouble / Double(self.questionArray.count * 10)) >= (scoreAsDouble * 0.01)  {
                game["WLD"] = "W"
            } else {
                game["WLD"] = "L"
            }
            
            game["score"] = self.playerScore
            
            self.game.saveInBackgroundWithBlock{ (gameSaveSuccess, error) -> Void in
                if error == nil {
                    print("Game updated & saved successfully")
                    self.performSegueWithIdentifier("segueOwnScore", sender: self)
                } else {
                    print("Error in QuestionVC game saveInBackground: \(error)")
                }
            }
            
            if timer != nil {
                timer.invalidate()
            }
        }
        else {
            obj = nil;
            obj = (self.questionArray as! Array)[currQuestionCount - 1];

            if obj.objectForKey("questionFile") != nil {
                let questionFile = obj["questionFile"] as? PFFile
                questionFile!.getDataInBackgroundWithBlock {
                    (imageData, error) -> Void in
                    if error == nil {
                        if let imageData = imageData {
                            let image = UIImage(data:imageData)
                            self.questionImage?.image = image
                            print("image -> \(self.questionImage?.image)")
                        }
                    }
                }
            }
            
            wrongAns = obj.valueForKey("options")?.objectAtIndex(1) as! String
            txtQuestionView?.text = obj .valueForKey("questionText") as! String
            var ans:String = obj .valueForKey("answer") as! String
            if ans == obj.valueForKey("options")?.objectAtIndex(0) as! String {
                ans = "option1"
            }
            else if ans == obj.valueForKey("options")?.objectAtIndex(1) as! String {
                ans = "option2"
            }
            else if ans == obj.valueForKey("options")?.objectAtIndex(2) as! String {
                ans = "option3"
            }
            else if ans == obj.valueForKey("options")?.objectAtIndex(3) as! String {
                ans = "option4"
            }
            
            //Set Original Position
            btnOption1?.frame = originalPosArray[0]
            btnOption2?.frame = originalPosArray[1]
            btnOption3?.frame = originalPosArray[2]
            btnOption4?.frame = originalPosArray[3]
            
            
            // Originally the 'gray' was 'normal', effecting the buttons background color
            btnOption1?.setBackgroundImage(UIImage(named: "normal"), forState: UIControlState.Normal)
            btnOption2?.setBackgroundImage(UIImage(named: "normal"), forState: UIControlState.Normal)
            btnOption3?.setBackgroundImage(UIImage(named: "normal"), forState: UIControlState.Normal)
            btnOption4?.setBackgroundImage(UIImage(named: "normal"), forState: UIControlState.Normal)
            
            btnOption1?.tag = 0
            btnOption2?.tag = 0
            btnOption3?.tag = 0
            btnOption4?.tag = 0
            
            btnOption1?.hidden = false
            btnOption2?.hidden = false
            btnOption3?.hidden = false
            btnOption4?.hidden = false
            
            questionImage?.image = nil
            
            btnOption1?.setTitle(obj .valueForKey("options")?.objectAtIndex(0) as? String, forState: UIControlState.Normal)
            btnOption2?.setTitle(obj .valueForKey("options")?.objectAtIndex(1) as? String, forState: UIControlState.Normal)
            btnOption3?.setTitle(obj .valueForKey("options")?.objectAtIndex(2) as? String, forState: UIControlState.Normal)
            btnOption4?.setTitle(obj .valueForKey("options")?.objectAtIndex(3) as? String, forState: UIControlState.Normal)
            
            if ans.rangeOfString("1") != nil {
                btnOption1?.tag = 1
            }
            else if ans.rangeOfString("2") != nil {
                btnOption2?.tag = 1
            }
            else if ans.rangeOfString("3") != nil {
                btnOption3?.tag = 1
            }
            else if ans.rangeOfString("4") != nil {
                btnOption4?.tag = 1
            }
        
            for idx in 0..<posArray.count {
                let rnd = Int(arc4random_uniform(UInt32(idx)))
                if rnd != idx {
                    swap(&posArray[idx], &posArray[rnd])
                }
            }
            
            //Set Random Position
            btnOption1?.frame = posArray[0]
            btnOption2?.frame = posArray[1]
            btnOption3?.frame = posArray[2]
            btnOption4?.frame = posArray[3]
            
            self.startTimer();
        }
    }
    
//==========================================================================================================================

// MARK: Methods for timer

//==========================================================================================================================
    func startTimer() {
        questionTimer = kQuestionTime
        
        lblOutof?.text = String(format: "%d/%d",currQuestionCount,questionArray.count)
        
        //if String(format: "%@", locale: NSUserDefaults.standardUserDefaults().valueForKey(kTimer) as? NSLocale) == "YES"
        NSLog("%@",NSUserDefaults.standardUserDefaults().valueForKey(kTimer) as! String)
        if(NSUserDefaults.standardUserDefaults().valueForKey(kTimer) as! String  == "YES") {
            timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("updateTimer:"), userInfo: nil, repeats: true)
        } else {
            lblTimer?.hidden = true
            btnTimer?.hidden = true
        }
    
    }
    
    func updateTimer(dt:NSTimer) {
        questionTimer--
        if questionTimer == 0 {
            currQuestionCount++
    
            NSLog("%d %d",currQuestionCount,questionArray.count)
            if currQuestionCount > questionArray.count {
                print("Game over, ran out of time")
               
                self.performSegueWithIdentifier("segueOwnScore", sender: self)
                
//                let ownScoreVC = self.storyboard?.instantiateViewControllerWithIdentifier("OwnScoreViewController") as! OwnScoreViewController
//                ownScoreVC.playerScore = self.playerScore
//                ownScoreVC.strName = self.playerName
//                ownScoreVC.arrWrongQuestion = self.arrWrongAns
//                ownScoreVC.arrOtherAns = self.arrHalfWrongAns
//                ownScoreVC.game = self.game
//                self.navigationController?.pushViewController(ownScoreVC, animated: true)
                
                if timer != nil {
                    timer.invalidate()
                }
    
            }
            else {
                if timer != nil {
                    timer.invalidate()
                }
                game.addUniqueObject(obj, forKey: "wrongAnswers")
                print("Added obj to wrongAnswers b/c time's up!")
                
                arrWrongAns.addObject(obj)

                //questionTimer = kQuestionTime
                self.nextQuestion(currQuestionCount)
            }
        }
        else {
            lblTimer?.text = String(format: "%d",questionTimer)
        }
    }

//==========================================================================================================================

// MARK: Buttons for Lifeline

//==========================================================================================================================
    
    @IBAction func soundButton(sender: AnyObject) {
        if isSound {
            self.soundButton.title = "Sound On"
            self.soundButton.titleTextAttributesForState(.Normal)
        } else {
            self.soundButton.title = "Sound Off"
            self.soundButton.titleTextAttributesForState(.Normal)
        }
        isSound = !isSound
    }
    
    
    @IBAction func btnFiftyFiftyTap(sender: UIButton) {
        let fiftyFiftyLifeLine = "50-50"
        self.game.addUniqueObject(fiftyFiftyLifeLine, forKey: "lifeLinesUsed")
         let ff = NSUserDefaults.standardUserDefaults().valueForKey(kFiftyFiftyCount) as! String
        var ffInt = Int(ff)
        ffInt?--
        let ffString = String(format: "%d", ffInt!)
        NSUserDefaults.standardUserDefaults().setValue(ffString, forKey: kFiftyFiftyCount)
        btnFiftyFifty!.setTitle("50-50", forState: UIControlState.Normal)
        
        if btnOption1?.tag == 1 {
            btnOption3?.hidden = true
            btnOption4?.hidden = true
        }
        else if btnOption2?.tag == 1 {
            btnOption1?.hidden = true
            btnOption3?.hidden = true
        }
        else if btnOption3?.tag == 1 {
            btnOption1?.hidden = true
            btnOption4?.hidden = true
        }
        else if btnOption4?.tag == 1 {
            btnOption1?.hidden = true
            btnOption2?.hidden = true
        }
        
        btnFiftyFifty?.hidden = true
    }
    
    @IBAction func btnSkipTap(sender: UIButton) {
        let skipLifeLine = "skip"
        self.game.addUniqueObject(skipLifeLine, forKey: "lifeLinesUsed")

        let skip = NSUserDefaults.standardUserDefaults().valueForKey(kSkipCount) as! String
        var ffSkipInt = Int(skip)
        ffSkipInt?--
        let ffSkipString = String(format: "%d", ffSkipInt!)
        NSUserDefaults.standardUserDefaults().setValue(ffSkipString, forKey: kSkipCount)
        
        btnSkip!.setTitle("SKIP", forState: UIControlState.Normal)
        
        if timer != nil {
            timer.invalidate()
        }
        self.currQuestionCount++
        self.nextQuestion(self.currQuestionCount)
        
        btnSkip?.hidden = true
        
    } // END of btnSkipTap
    
    
    @IBAction func btnTimerTap(sender: UIButton) {
        let pauseLifeLine = "Pause"
        self.game.addUniqueObject(pauseLifeLine, forKey: "lifeLinesUsed")

        let time = NSUserDefaults.standardUserDefaults().valueForKey(kTimerCount) as! String
        var ffTimeInt = Int(time)
        ffTimeInt?--
        let ffSkipString = String(format: "%d", ffTimeInt!)
        NSUserDefaults.standardUserDefaults().setValue(ffSkipString, forKey: kTimerCount)
        
        btnTimer!.setTitle(" ", forState: UIControlState.Normal)
        
        if timer != nil {
            timer.invalidate()
        }
        
        
        btnTimer?.hidden = true
        
    } // END of btnTimerTap
    
    
    @IBAction func getHelpButtonTap(sender: AnyObject) {
        
    } // END of getHelpButtonTap
    
    
    
//==========================================================================================================================

// MARK: Methods for selecting a specific option

//==========================================================================================================================
    
    @IBAction func btnOption1Tap(sender: UIButton) {
        
        if timer != nil {
            timer.invalidate()
        }
        
        if sender.tag == 1 {
            self.speechAction(true)
            sender.setBackgroundImage(UIImage(named: "green"), forState: UIControlState.Normal)
            if flagForWrongAnswerpush == false {
                playerScore = playerScore + 10
                
                //game.incrementKey("score", byAmount: 10)

                game.addUniqueObject(obj, forKey: "correctAnswers")
                
            } else {
                playerScore = playerScore + 8
            }
        }
        else {
            game.addUniqueObject(obj, forKey: "wrongAnswers")
            //print("added obj to wrongAnswers from btnOption1Tap")
            
            arrWrongAns.addObject(obj)
            self.speechAction(false)
            sender.setBackgroundImage(UIImage(named: "red"), forState: UIControlState.Normal)
            
            if flagForWrongAnswerpush == false {
                playerScore = playerScore - 5
            } else {
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
        
    } // END of option1Tap
    
    
    @IBAction func btnOption2Tap(sender: UIButton) {
        if timer != nil {
            timer.invalidate()
        }
        
        if sender.tag == 1 {
            self.speechAction(true)
            sender.setBackgroundImage(UIImage(named: "green"), forState: UIControlState.Normal)
            if flagForWrongAnswerpush == false {
                
                playerScore = playerScore + 10
                //game.incrementKey("score", byAmount: 10)
                game.addUniqueObject(obj, forKey: "correctAnswers")
                
            } else {
                playerScore = playerScore + 8
            }
        }
        else {
            game.addUniqueObject(obj, forKey: "wrongAnswers")
            //print("added obj to wrongAnswers from btnOption2Tap")
            
            arrWrongAns.addObject(obj)
            self.speechAction(false)
            sender.setBackgroundImage(UIImage(named: "red"), forState: UIControlState.Normal)
            
            if flagForWrongAnswerpush == false {
                playerScore = playerScore - 5
            } else {
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
    } // END of option2Tap
    
    
    @IBAction func btnOption3Tap(sender: UIButton) {
        if timer != nil {
            timer.invalidate()
        }
        
        if sender.tag == 1 {
            self.speechAction(true)
            sender.setBackgroundImage(UIImage(named: "green"), forState: UIControlState.Normal)
            if flagForWrongAnswerpush == false {
                
                playerScore = playerScore + 10
                //game.incrementKey("score", byAmount: 10)
                game.addUniqueObject(obj, forKey: "correctAnswers")

            } else {
                playerScore = playerScore + 8
            }
        }
        else {
            game.addUniqueObject(obj, forKey: "wrongAnswers")
            //print("added obj to wrongAnswers from btnOption3Tap")
            
            arrWrongAns.addObject(obj)
            self.speechAction(false)
            sender.setBackgroundImage(UIImage(named: "red"), forState: UIControlState.Normal)
            
            if flagForWrongAnswerpush == false {
                playerScore = playerScore - 5
            } else {
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
    } // END of option3Tap
    
    
    @IBAction func btnOption4Tap(sender: UIButton) {
        if timer != nil {
            timer.invalidate()
        }
        if sender.tag == 1 {
            self.speechAction(true)
            sender.setBackgroundImage(UIImage(named: "green"), forState: UIControlState.Normal)
            if flagForWrongAnswerpush == false {
                
                playerScore = playerScore + 10
                //game.incrementKey("score", byAmount: 10)
                game.addUniqueObject(obj, forKey: "correctAnswers")
                
            } else {
                playerScore = playerScore + 8
            }
        }
        else {
            game.addUniqueObject(obj, forKey: "wrongAnswers")
            //print("added obj to wrongAnswers from btnOption4Tap")
            
            arrWrongAns.addObject(obj)
            self.speechAction(false)
            sender.setBackgroundImage(UIImage(named: "red"), forState: UIControlState.Normal)
            
            if flagForWrongAnswerpush == false {
                playerScore = playerScore - 5
            } else {
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
        
    } // END of option4Tap
    
    
//==========================================================================================================================

// MARK: Text field delegate methods

//==========================================================================================================================
   
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        playerName = textField.text
        return true
    }
    
    
//==========================================================================================================================

// MARK: Speech recognize

//==========================================================================================================================
    
    func speechAction(yn: Bool) {
        if(NSUserDefaults.standardUserDefaults().valueForKey(kTimer) as! String  == "YES") {
            if isSound {
                if yn {
                    myUtterance = AVSpeechUtterance(string: "Correct Answer")
                    myUtterance.rate = 0.3
                    synth.speakUtterance(myUtterance)
                } else {
                    NSLog("%@", arrWrongAns)
                    myUtterance = AVSpeechUtterance(string: "Wrong Answer")
                    myUtterance.rate = 0.3
                    synth.speakUtterance(myUtterance)
                }
            }
        }
        
        if(NSUserDefaults.standardUserDefaults().valueForKey(kTimer) as! String  == "YES") {
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
    }
    

//==========================================================================================================================

// MARK: Quit button

//==========================================================================================================================
   
    @IBAction func quitButton(sender: AnyObject) {
        let actionSheetController: UIAlertController = UIAlertController(title: "Quit", message: "Are you sure want to quit?", preferredStyle: .Alert)
        
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in

        }
        actionSheetController.addAction(cancelAction)
        
        //Create and an option action
        let nextAction: UIAlertAction = UIAlertAction(title: "Yes", style: .Default) { action -> Void in
            
            //Create the AlertController
            let actionSheetController1: UIAlertController = UIAlertController(title: "Enter Name", message: "", preferredStyle: .Alert)
            
            //Create and add the Cancel action
            let cancelAction1: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
                //Do some stuff
                //DBFunction.insertData(self.playerName, score: String(self.playerScore))
                let ownScoreVC = self.storyboard?.instantiateViewControllerWithIdentifier("OwnScoreViewController") as! OwnScoreViewController
                ownScoreVC.playerScore = self.playerScore
                ownScoreVC.strName = self.playerName
                ownScoreVC.arrWrongQuestion = self.arrWrongAns
                ownScoreVC.arrOtherAns = self.arrHalfWrongAns
                ownScoreVC.game = self.game
                self.navigationController?.pushViewController(ownScoreVC, animated: true)
                
            }
            actionSheetController1.addAction(cancelAction1)
            
            //Create and an option action in this case for our OK button
            let nextAction1: UIAlertAction = UIAlertAction(title: "Ok", style: .Default) { action -> Void in
                let homeVC = self.storyboard?.instantiateViewControllerWithIdentifier("HomeViewController") as! HomeViewController
                self.navigationController?.pushViewController(homeVC, animated: true)
            }
            actionSheetController1.addAction(nextAction1)
            
            //Add a text field
            actionSheetController1.addTextFieldWithConfigurationHandler { textField -> Void in
                //TextField configuration
                textField.textColor = UIColor.blackColor()
                textField.delegate = self
            }
            
            //Present the AlertController
            self.presentViewController(actionSheetController1, animated: true, completion: nil)
            if self.timer != nil {
                self.timer.invalidate()
            }
        }
        
        actionSheetController.addAction(nextAction)
        
        self.presentViewController(actionSheetController, animated: true, completion: nil)
        
    }
    
}
