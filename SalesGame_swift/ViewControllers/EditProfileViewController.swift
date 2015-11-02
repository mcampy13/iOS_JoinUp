//
//  EditProfileViewController.swift
//  SalesGame_swift
//
//  Created by Robert Rock on 10/20/15.
//  Copyright © 2015 Akshay. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var imgUpload: UIImageView!
    @IBOutlet weak var imgUploadText: UIButton!
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var editDepartmentLabel: UILabel!
    
    
    var pic: AnyObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //NSThread .detachNewThreadSelector("showhud", toTarget: self, withObject: nil)

        UtilityClass.setMyViewBorder(imgUpload, withBorder: 0, radius: 50)
        //self.displayUserImg()
        let currentUser = PFUser.currentUser()
        self.usernameLabel.text = currentUser?.objectForKey("username") as? String
        
        self.editDepartmentLabel.text = currentUser?.objectForKey("department") as? String
        
    }
    
    /*
    * Retrieve user's profile pic and display it.  Allows user to change img
    */
//    func displayUserImg(){
//        let queryUserPhoto = PFQuery(className: "UserPhotos")
//        queryUserPhoto.whereKey("user", equalTo: PFUser.currentUser()!)
//        queryUserPhoto.addDescendingOrder("createdAt")
//        queryUserPhoto.findObjectsInBackgroundWithBlock { (imgObjectArray, error) -> Void in
//            if error == nil {
//                self.pic = imgObjectArray
//                print("pic \(self.pic)")
//                
//                let picObject:PFObject = (self.pic as! Array)[0];
//                print("Most Recent picObject \(picObject)")
//                
//                let file: PFFile = picObject["userImg"] as! PFFile
//                print("file \(file)")
//                file.getDataInBackgroundWithBlock({
//                    (imageData, error) -> Void in
//                    if error == nil {
//                        let Image: UIImage = UIImage(data: imageData!)!
//                        print("Image \(Image)")
//                        self.imgUpload.image = Image
//                        hideHud(self.view)
//                    } else {
//                        print("Error \(error)")
//                    }
//                })
//            } else {
//                print("Error: \(error)")
//                UtilityClass.showAlert("Error: \(error)")
//            }
//        }
//        
//    } // END of displayUserImg()
//    
    
    //=======================================================================================================
    // MARK: Actions
    

    @IBAction func imgUploadFromSource(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePicker.allowsEditing = false
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        //imgUpload.image = image
        self.dismissViewControllerAnimated(true, completion: nil)
        self.imgUpload.image = image
    }
    
    /*
     *  Bug: It will only save the image that it already currently is or maybe the one that is displayed on profileVC. 
     *     Kinda odd so there must be a reason it can only be that specific one.  Newest thought, it looks like even with
     * no images loaded it will still literally ONLY load ONE image of a specific waterfall. Why?
     */
    @IBAction func btnSaveChanges(sender: AnyObject) {
        if self.imgUpload.image == nil {
            UtilityClass.showAlert("Error, image not saved.")
            print("Error: img not saved")
        } else {
            let userPhotos = PFObject(className: "UserPhotos")
            userPhotos["user"] = PFUser.currentUser()
            userPhotos.saveInBackgroundWithBlock { (success, error) -> Void in
                if error == nil {
                    let imgData = UIImagePNGRepresentation(self.imgUpload.image!)
                    let parseImg = PFFile(name: "userImg.png", data: imgData!)
                    userPhotos["userImg"] = parseImg
                    userPhotos.saveInBackgroundWithBlock { (success, error) -> Void in
                        if error == nil {
                            hideHud(self.view)
                            print("Image successfully saved")
                            UtilityClass.showAlert("Image successfully saved!")
                            self.navigationController!.popViewControllerAnimated(true)
                        } else {
                            UtilityClass.showAlert("Error: \(error)")
                            print("Error \(error)")
                        }
                    }
                } else {
                    UtilityClass.showAlert("Error \(error)")
                    print("Error \(error)")
                }
            }
        }
    } // END of btnSaveChanges()
    
    @IBAction func btnCancel(sender: AnyObject) {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    func showhud() {
        showHud(self.view)
    }
    
    
    
}
