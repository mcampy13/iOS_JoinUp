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
    @IBOutlet weak var homeButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var friendButton: UIBarButtonItem!
    @IBOutlet weak var logOutButton: UIBarButtonItem!
    
    var pic:AnyObject?
    
    //@IBOutlet weak var friendTableView: UITableView!
    //var friend: AnyObject?
    //var finalFriends: NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //NSThread .detachNewThreadSelector("showhud", toTarget: self, withObject: nil)
        
        UtilityClass.setMyViewBorder(img, withBorder: 0, radius: 50)
        self.displayUserImg()
        //queryFriends()
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
    
    
//    func queryFriends(){
//        let user = PFUser.currentUser()
//        let queryFriend = PFQuery(className: "Friend")
//        queryFriend.whereKey("from", equalTo: user!)
//        queryFriend.limit = 10
//        queryFriend.findObjectsInBackgroundWithBlock {
//            (friendObject, error) -> Void in
//            if error == nil {
//                print("friends = \(friendObject)")
//                self.friend = friendObject
//                // query user to match with friend query
//                for var i = 0;  i < friendObject!.count; i++ {
//                    let obj:PFObject = (self.friend as! Array)[i];
//                    self.finalFriends .addObject(obj)
//                }
//                
//                print("finalFriends",self.finalFriends as NSMutableArray)
//                self.friendTableView!.reloadData()
//                hideHud(self.view)
//            } else {
//                print("Error \(error)")
//            }
//        }
//    } // END of queryFriends()


    //==========================================================================================================================
    
    // MARK: Table datasource and delegate methods
    
    //==========================================================================================================================
    
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if self.finalFriends.count == 0 {
//            return 0
//        } else {
//            return self.finalFriends.count
//        }
//    }
//    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell:ProfileTableViewCell = friendTableView!.dequeueReusableCellWithIdentifier("cell") as! ProfileTableViewCell
//        cell.Friend?.text = self.finalFriends.objectAtIndex(indexPath.row).valueForKey("to") as? String
//        return cell
//    }
    
    //==========================================================================================================================
    
    // MARK: Actions
    
    //==========================================================================================================================
    
    @IBAction func homeButton(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func editButton(sender: AnyObject) {
        let editProfileVC = self.storyboard?.instantiateViewControllerWithIdentifier("EditProfileViewController") as? EditProfileViewController
        self.navigationController?.pushViewController(editProfileVC!, animated: true)
    }
    
    @IBAction func friendButton(sender: AnyObject) {
        UtilityClass.showAlert("Would go to Friend page")
//        let friendVC = self.storyboard?.instantiateViewControllerWithIdentifier("FriendViewController") as? FriendViewController
//        self.navigationController?.pushViewController(friendVC!, animated: true)
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
