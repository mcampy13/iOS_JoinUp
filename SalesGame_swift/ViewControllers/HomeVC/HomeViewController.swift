//
//  HomeViewController.swift
//  SalesGame_swift
//
//  Created by Akuma on 9/11/15.
//  Copyright (c) 2015 Akuma. All rights reserved.
//

import UIKit


class HomeViewController: UIViewController {

    
    @IBOutlet var btnPlay : UIButton!
    @IBOutlet var btnSetting : UIButton!
    @IBOutlet weak var btnProfile: UIButton!
    @IBOutlet var btnScore : UIButton!
    @IBOutlet var btnLogout : UIButton!
    @IBOutlet weak var helpBtn: UIButton!
    @IBOutlet weak var btnChallenge: UIButton!
    
    @IBOutlet weak var profilePic: UIImageView?
    
    var pic: AnyObject?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

// MARK: IBAction methods

//==========================================================================================================================

    @IBAction func btnPlay(sender: UIButton) {
        let categoryVC = self.storyboard?.instantiateViewControllerWithIdentifier("AllCategoryViewController") as? AllCategoryViewController
        self.navigationController!.pushViewController(categoryVC!, animated: true)
    }
    
    @IBAction func btnChallenge(sender: AnyObject) {
        let challengeVC = self.storyboard?.instantiateViewControllerWithIdentifier("ChallengeViewController") as? ChallengeViewController
        self.navigationController!.pushViewController(challengeVC!, animated: true)
    }
    
    
    @IBAction func btnProfile(sender: UIButton) {
       let profileVC = self.storyboard?.instantiateViewControllerWithIdentifier("ProfileViewController") as? ProfileViewController
        self.navigationController!.pushViewController(profileVC!, animated: true)
    }
    
    @IBAction func btnSettings(sender: AnyObject) {
        let settingVC = self.storyboard?.instantiateViewControllerWithIdentifier("SettingViewController") as? SettingViewController
        self.navigationController!.pushViewController(settingVC!, animated: true)
    }
    
    @IBAction func messagesButtonTap(sender: AnyObject) {
        displayAlert("Messages", error: "Coming Soon!")
    }
    
    
    @IBAction func btnLeader(sender: UIButton) {
       let highScoreVC = self.storyboard?.instantiateViewControllerWithIdentifier("HighScoreViewController") as? HighScoreViewController
        self.navigationController!.pushViewController(highScoreVC!, animated: true)
    }
    
//    @IBAction func helpBtn(sender: UIButton) {
//        let helpVC = self.storyboard?.instantiateViewControllerWithIdentifier("HelpViewController") as? HelpViewController
//        self.navigationController!.pushViewController(helpVC!, animated: true)
//    }
    
    @IBAction func btnLogout(sender: UIButton) {
        PFUser .logOutInBackground()
        self.navigationController!.popToRootViewControllerAnimated(true)
    }
}
