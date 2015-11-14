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
    @IBOutlet weak var departmentTextField: UITextField!
    
    let imagePicker = UIImagePickerController()

    var pic: AnyObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //NSThread .detachNewThreadSelector("showhud", toTarget: self, withObject: nil)

        UtilityClass.setMyViewBorder(imgUpload, withBorder: 0, radius: 75)
        let currentUser = PFUser.currentUser()
        self.usernameLabel.text = currentUser?.objectForKey("username") as? String
        
        self.editDepartmentLabel.text = currentUser?.objectForKey("department") as? String
        imagePicker.delegate = self

        displayUserImg()
    }
    
    /*
    * Retrieve user's profile pic and display it.  Allows user to change img
    */
    func displayUserImg(){
        var query = PFQuery.getUserObjectWithId(PFUser.currentUser()!.objectId!)
        
        let file: PFFile = query?.valueForKey("profilePic") as! PFFile
        print("file \(file)")
        file.getDataInBackgroundWithBlock({
            (imageData, error) -> Void in
            if error == nil {
                let Image: UIImage = UIImage(data: imageData!)!
                print("Image \(Image)")
                self.imgUpload.image = Image
                hideHud(self.view)
            } else {
                print("Error \(error)")
            }
        })

    } // END of displayUserImg()
    
    
    
    func displayAlert(title: String, error: String){
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: {action in
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //=======================================================================================================
    
    // MARK: Actions
    
    //=======================================================================================================

    /*
     *  Bug:  ONLY load ONE image of a specific waterfall. Why?
     */
    @IBAction func imgUploadFromSource(sender: AnyObject) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
//    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
//        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
//            imgUpload.contentMode = .ScaleAspectFill
//            imgUpload.image = pickedImage
//        }
//        dismissViewControllerAnimated(true, completion: nil)
//    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
//        imgUpload.image = image
        self.dismissViewControllerAnimated(true, completion: nil)
        self.imgUpload.image = image
    }
    
    @IBAction func cancelButton(sender: AnyObject) {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    
    @IBAction func saveButton(sender: AnyObject) {
        if self.departmentTextField != nil {
            var dept = self.departmentTextField.text
            var user = PFUser.currentUser()
            user!["department"] = dept
            user?.saveInBackgroundWithBlock { (successObject, error) -> Void in
                if error == nil {
                    user!["department"] = dept
                    print("Department changed to \(dept)")
                    let profileVC = self.storyboard?.instantiateViewControllerWithIdentifier("ProfileViewController") as? ProfileViewController
                    self.navigationController?.pushViewController(profileVC!, animated: true)
                } else{
                    print("Error saving department: \(error)")
                }
            
            }
        }
        if self.imgUpload!.image == nil {
            //UtilityClass.showAlert("Error, image not saved.")
            print("No img chosen")
        } else {
//            let userPhotos = PFObject(className: "UserPhotos")
//            userPhotos["user"] = PFUser.currentUser()
//            userPhotos.saveInBackgroundWithBlock { (success, error) -> Void in
//                if error == nil {
//                    let imgData = UIImagePNGRepresentation(self.imgUpload.image!)
//                    let parseImg = PFFile(name: "userImg.png", data: imgData!)
//                    userPhotos["userImg"] = parseImg
//                    userPhotos.saveInBackgroundWithBlock { (success, error) -> Void in
//                        if error == nil {
//                            print("Image successfully saved")
//                            UtilityClass.showAlert("Image successfully saved!")
//                            
//                            //hideHud(self.view)
//                            //self.navigationController!.popViewControllerAnimated(true)
//                        } else {
//                            UtilityClass.showAlert("Error: \(error)")
//                            print("Error \(error)")
//                        }
//                    }
//                } else {
//                    UtilityClass.showAlert("Error \(error)")
//                    print("Error \(error)")
//                }
//            }
            
            let user = PFUser.currentUser()
            let imgData = UIImagePNGRepresentation(self.imgUpload.image!)
            let parseImg = PFFile(name: "profilePNG.png", data: imgData!)
            user!["profilePic"] = parseImg
            user?.saveInBackgroundWithBlock { (success, error) -> Void in
                if error == nil {
                    print("Profile pic successfully saved")
                    hideHud(self.view)
                    let profileVC = self.storyboard?.instantiateViewControllerWithIdentifier("ProfileViewController") as? ProfileViewController
                    self.navigationController?.pushViewController(profileVC!, animated: true)
                } else {
                    print("Error saving profilePic: \(error)")
                    self.displayAlert("Error Uploading", error: "Image was not saved")
                }
            
            }
        }
    } // END of saveButton()
    
    
    func showhud() {
        showHud(self.view)
    }
    
    
    
    
}
