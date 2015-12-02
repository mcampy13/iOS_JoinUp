//
//  EditProfileViewController.swift
//  SalesGame_swift
//
//  Created by Robert Rock on 10/20/15.
//  Copyright © 2015 Akshay. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    
    @IBOutlet weak var imgUpload: UIImageView!
    @IBOutlet weak var imgUploadText: UIButton!
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var editDepartmentLabel: UILabel!
    @IBOutlet weak var departmentTextField: UITextField!
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var newDept: String?
    var newProfilePFImage: PFFile?
    
    let imagePicker = UIImagePickerController()

    var pic: AnyObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //NSThread .detachNewThreadSelector("showhud", toTarget: self, withObject: nil)
        
        // Handle user input in text field through delegates
        departmentTextField.delegate = self
        
        // Enable save button IFF (if & only if) text field has valid department name
        checkValidDepartmentName()
        
        self.navigationController?.navigationBar.barTintColor = UIColor.orangeColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]

        UtilityClass.setMyViewBorder(imgUpload, withBorder: 0, radius: 75)
        let currentUser = PFUser.currentUser()
        self.usernameLabel.text = currentUser?.objectForKey("username") as? String
        
        let currentDepartment = PFUser.currentUser()!.objectForKey("department")
        self.editDepartmentLabel.text = currentDepartment as? String
        imagePicker.delegate = self

        displayUserImg()
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
                self.imgUpload.image = Image
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
    
    
    //=======================================================================================================
    
    // MARK: Navigation
    
    //=======================================================================================================
    
    
    // Configure View before it's presented
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveButton === sender {
            
            // set global department variable for use in unwindToProfile in ProfileVC
            let newDepartment = self.departmentTextField.text ?? ""
            self.newDept = newDepartment
            
            let newImgData = UIImagePNGRepresentation(self.imgUpload.image!)
            let parseImg = PFFile(name: "profilePNG.png", data: newImgData!)
            
            self.newProfilePFImage = parseImg
            
        }
    }
    
    @IBAction func cancelButton(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //==========================================================================================================================
    
    // MARK: UITextFieldDelegate
    
    //==========================================================================================================================
    
    func textFieldDidBeginEditing(textField: UITextField) {
        saveButton.enabled = false
    }
    
    func checkValidDepartmentName() {
        let text = departmentTextField.text ?? ""
        saveButton.enabled = !text.isEmpty
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        checkValidDepartmentName()
    }
    
    //=======================================================================================================
    
    // MARK: Actions
    
    //=======================================================================================================

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
    
        self.dismissViewControllerAnimated(true, completion: nil)
        self.imgUpload.image = image
    }
    
//    @IBAction func saveButton(sender: AnyObject) {
//        if self.departmentTextField != nil {
//            let dept = self.departmentTextField.text
//            let user = PFUser.currentUser()
//            user!["department"] = dept
//            user?.saveInBackgroundWithBlock { (successObject, error) -> Void in
//                if error == nil {
//                    user!["department"] = dept
//                    print("Department changed to \(dept)")
//                    let profileVC = self.storyboard?.instantiateViewControllerWithIdentifier("ProfileViewController") as? ProfileViewController
//                    self.navigationController?.pushViewController(profileVC!, animated: true)
//                } else{
//                    print("Error saving department: \(error)")
//                }
//            
//            }
//        }
//        if self.imgUpload!.image == nil {
//            //UtilityClass.showAlert("Error, image not saved.")
//            print("No img chosen")
//        } else {
//
//            let user = PFUser.currentUser()
//            let imgData = UIImagePNGRepresentation(self.imgUpload.image!)
//            let parseImg = PFFile(name: "profilePNG.png", data: imgData!)
//            user!["profilePic"] = parseImg
//            user?.saveInBackgroundWithBlock { (success, error) -> Void in
//                if error == nil {
//                    print("Profile pic successfully saved")
//                    hideHud(self.view)
//                    let profileVC = self.storyboard?.instantiateViewControllerWithIdentifier("ProfileViewController") as? ProfileViewController
//                    self.navigationController?.pushViewController(profileVC!, animated: true)
//                } else {
//                    print("Error saving profilePic: \(error)")
//                    self.displayAlert("Error Uploading", error: "Image was not saved")
//                }
//            }
//        }
//    } // END of saveButton()
    
    
    //==========================================================================================================================
    
    // MARK: Progress hud display methods
    
    //==========================================================================================================================
    
    func showhud() {
        showHud(self.view)
    }
    
    
}
