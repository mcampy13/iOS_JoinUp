//
//  ProfileViewController.swift
//  SalesGame_swift
//
//  Created by Robert Rock on 10/20/15.
//  Copyright © 2015 Akshay. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var departmentLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    
    @IBOutlet weak var labelTotalGamesAmount: UILabel!
    
    @IBOutlet weak var homeButton: UIBarButtonItem!
    @IBOutlet weak var gamesButton: UIBarButtonItem!
    @IBOutlet weak var badgesButton: UIBarButtonItem!
    @IBOutlet weak var friendButton: UIBarButtonItem!
    @IBOutlet weak var logOutButton: UIBarButtonItem!
    
    
    var pic:AnyObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //NSThread .detachNewThreadSelector("showhud", toTarget: self, withObject: nil)
        
        UtilityClass.setMyViewBorder(img, withBorder: 0, radius: 75)
        self.displayUserImg()
        
        let currentUser = PFUser.currentUser()!.objectForKey("username")
        let currentDepartment = PFUser.currentUser()!.objectForKey("department")
        let level = PFUser.currentUser()!.objectForKey("level")
        self.usernameLabel.text = currentUser as? String
        self.departmentLabel.text = currentDepartment as? String
        self.levelLabel.text = String(level)
        
        getTotalGamesPlayed()
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
                self.img.image = Image
                hideHud(self.view)
            } else {
                print("Error \(error)")
            }
        })

    } // END of displayUserImg()
    
    func getTotalGamesPlayed(){
        let queryGame = PFQuery(className: "Game")
        queryGame.whereKey("player", equalTo: PFUser.currentUser()!)
        queryGame.findObjectsInBackgroundWithBlock { (success, error) -> Void in
            if error == nil {
                self.labelTotalGamesAmount?.text = String(success!.count)
            } else{
                print("Error in getTotalGamesPlayed: \(error)")
            }
        }
    }
    

    //==========================================================================================================================
    
    // MARK: Actions
    
    //==========================================================================================================================
    
    @IBAction func homeButton(sender: AnyObject) {
        let homeVC = self.storyboard?.instantiateViewControllerWithIdentifier("HomeViewController") as? HomeViewController
        self.navigationController?.pushViewController(homeVC!, animated: true)
    }
    
    @IBAction func gamesButton(sender: AnyObject) {
        let gameHistoryVC = self.storyboard?.instantiateViewControllerWithIdentifier("GameHistoryViewController") as? GameHistoryViewController
        self.navigationController?.pushViewController(gameHistoryVC!, animated: true)
    }
    
    @IBAction func badgesButton(sender: AnyObject) {
        let myBadgesVC = self.storyboard?.instantiateViewControllerWithIdentifier("BadgeViewController") as! BadgeViewController
        self.navigationController?.pushViewController(myBadgesVC, animated: true)
    }
    
    @IBAction func settingsButton(sender: AnyObject) {
        let editProfileVC = self.storyboard?.instantiateViewControllerWithIdentifier("EditProfileViewController") as? EditProfileViewController
        self.navigationController?.pushViewController(editProfileVC!, animated: true)
    }
    
    @IBAction func friendButton(sender: AnyObject) {
        let friendVC = self.storyboard?.instantiateViewControllerWithIdentifier("FriendViewController") as? FriendViewController
        self.navigationController?.pushViewController(friendVC!, animated: true)
    }
    
    @IBAction func logOutButton(sender: AnyObject) {
        PFUser.logOutInBackground()
        self.navigationController!.popToRootViewControllerAnimated(true)
    }
    
    
    //==========================================================================================================================
    
    // MARK: Progress hud display methods
    
    //==========================================================================================================================
    
    func showhud() {
        showHud(self.view)
    }

}
