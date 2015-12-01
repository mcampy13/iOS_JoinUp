//
//  HomeViewController.swift
//  SalesGame_swift
//
//  Created by Akuma on 9/11/15.
//  Copyright (c) 2015 Akuma. All rights reserved.
//

import UIKit


class HomeViewController: UIViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    //
    @IBOutlet var btnPlay : UIButton!
    @IBOutlet var btnScore : UIButton!
    @IBOutlet var btnLogout : UIButton!
    @IBOutlet weak var btnChallenge: UIButton!
    
    @IBOutlet weak var profilePic: UIImageView?
    
    var pic: AnyObject?
    var emailObj: AnyObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor.orangeColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        //self.revealViewController().rearViewRevealWidth = 200

        menuButton.target = self.revealViewController()
        menuButton.action = Selector("revealToggle:")
        
        UtilityClass.setMyViewBorder(profilePic, withBorder: 0, radius: 75)
        displayUserImg()
        navigationItem.title = "Home"
    }
    
    
    /*
    * Retrieve user's profile pic and display it.  Allows user to change img
    */
    func displayUserImg(){
        let query = PFQuery.getUserObjectWithId(PFUser.currentUser()!.objectId!)
        
        let file: PFFile = query?.valueForKey("profilePic") as! PFFile
        print("file \(file)")
        file.getDataInBackgroundWithBlock({
            (imageData, error) -> Void in
            if error == nil {
                let Image: UIImage = UIImage(data: imageData!)!
                print("Image \(Image)")
                self.profilePic!.image = Image
                hideHud(self.view)
            } else {
                print("Error \(error)")
            }
        })

        
    } // END of displayUserImg()
    

    func displayAlert(title: String, error: String){
        let alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: {action in
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }

    
//==========================================================================================================================
    
// MARK: Navigation
    
//==========================================================================================================================
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "newGame" {
//            let categoryViewController = segue.destinationViewController as! AllCategoryViewController
//            
//        }
//    }
    
//==========================================================================================================================

// MARK: Actions

//==========================================================================================================================

//    @IBAction func btnPlay(sender: UIButton) {
//        let categoryVC = self.storyboard?.instantiateViewControllerWithIdentifier("AllCategoryViewController") as? AllCategoryViewController
//        self.navigationController!.pushViewController(categoryVC!, animated: true)
//    }
    
    @IBAction func btnChallenge(sender: AnyObject) {
        let challengeVC = self.storyboard?.instantiateViewControllerWithIdentifier("ChallengeViewController") as? ChallengeViewController
        self.navigationController!.pushViewController(challengeVC!, animated: true)
    }
    
    @IBAction func btnLeader(sender: UIButton) {
       let highScoreVC = self.storyboard?.instantiateViewControllerWithIdentifier("HighScoreViewController") as? HighScoreViewController
        self.navigationController!.pushViewController(highScoreVC!, animated: true)
    }
    
    @IBAction func btnLogout(sender: UIButton) {
        PFUser.logOutInBackground()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    @IBAction func unwindToHomeFromSettings(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? SettingViewController, email = sourceViewController.email {
            //let user = PFUser.currentUser()
            
            // If email isn't empty, user wants to reset password
            let queryEmails = PFUser.query()
            queryEmails?.whereKey("email", equalTo: email)
            queryEmails?.findObjectsInBackgroundWithBlock{
                (emailObjects, error) -> Void in
                if error == nil {
                    self.emailObj = emailObjects
                    let obj:PFObject = (self.emailObj as! Array)[0];
                    
                    PFUser.requestPasswordResetForEmailInBackground(obj.objectForKey("email") as! String)
                }
                else {
                    print("Error in queryEmails: \(error)")
                }
            }
        }
    }

}
