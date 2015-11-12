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
    
    
    @IBOutlet weak var homeButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var friendButton: UIBarButtonItem!
    @IBOutlet weak var logOutButton: UIBarButtonItem!
    
    var pic:AnyObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //NSThread .detachNewThreadSelector("showhud", toTarget: self, withObject: nil)
        
        UtilityClass.setMyViewBorder(img, withBorder: 0, radius: 50)
        self.displayUserImg()
        
        let currentUser = PFUser.currentUser()?.objectForKey("username")
        var currentDepartment = PFUser.currentUser()?.objectForKey("department")
        self.usernameLabel.text = currentUser as? String
        self.departmentLabel.text = currentDepartment as? String
    }
    
    /*
     * Retrieve user's profile pic and display it.  Allows user to change img
     */
    func displayUserImg(){
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
                        self.img.image = Image
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
        
    } // END of displayUserImg()
    
    

    //==========================================================================================================================
    
    // MARK: Actions
    
    //==========================================================================================================================
    
    @IBAction func homeButton(sender: AnyObject) {
        let homeVC = self.storyboard?.instantiateViewControllerWithIdentifier("HomeViewController") as? HomeViewController
        self.navigationController?.pushViewController(homeVC!, animated: true)
    }
    
    @IBAction func editButton(sender: AnyObject) {
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
