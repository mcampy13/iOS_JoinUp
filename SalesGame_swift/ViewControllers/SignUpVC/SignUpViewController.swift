//
//  SignUpViewController.swift
//  SalesGame_swift
//
//  Created by Akuma on 9/11/15.
//  Copyright (c) 2015 Akuma. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtUsreName: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var sex: UITextField!
    @IBOutlet weak var phone: UITextField!
    
    @IBOutlet var btnSignUp : UIButton!
    @IBOutlet var btnCancel : UIButton!

//==========================================================================================================================

// MARK: Life Cycle methods

//==========================================================================================================================
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        UtilityClass .setMyViewBorder(btnSignUp, withBorder: 2, radius: 15)
//        UtilityClass .setMyViewBorder(btnCancel, withBorder: 2, radius: 15)

    }
//==========================================================================================================================

// MARK: buttons IBAction methods

//==========================================================================================================================
    
    @IBAction func btnCancel(sender: UIButton) {
            self.navigationController!  .popViewControllerAnimated(true)
    }

    @IBAction func btnSignUp(sender: UIButton) {
        if !txtEmail.text!.isEmpty {
            if UtilityClass .Emailvalidate(txtEmail.text) == true {
                if !txtUsreName.text!.isEmpty {
                    if !txtPassword.text!.isEmpty {
                        NSThread .detachNewThreadSelector("showhud", toTarget: self, withObject: nil)
                        var email = txtEmail.text
                        let password = txtPassword.text
                        let username = txtUsreName.text
                        let fname = self.firstName.text
                        let lname = self.lastName.text
                        let sex = self.sex.text
                        let phone = self.phone.text
                        
                        // Ensure username is lowercase
                        email = email!.lowercaseString
                        
                        if username!.utf16.count < 3 || password!.utf16.count < 3 {
                            let alert = UIAlertView(title: "Invalid", message: "username must be greater than 4 characters and password must be greater than 4 characters", delegate: self, cancelButtonTitle: "OK")
                            alert.show()
//                            let alert: UIAlertController = UIAlertController()
//                            alert.title = "Error"
                            
                        } else if email!.utf16.count < 8 {
                            let alert = UIAlertView(title: "Invalid", message: "Please enter a valid email address", delegate: self, cancelButtonTitle: "OK")
                            alert.show()
                            
                        } else {
                            let newUser = PFUser()
                            newUser.username = username
                            newUser.password = password
                            newUser.email = email
                            newUser["firstName"] = fname
                            newUser["lastName"] = lname
                            newUser["sex"] = sex
                            newUser["phone"] = phone
                            
                            /* newUser emailedVerified does not need setting.  It is automatically false.
                             *   Verification link is sent to user's email, after successful completion,
                             *   the value is changed automatically to true.
                             */
                            
//                            let teamMemberACL = PFACL()
//                            teamMemberACL.setPublicReadAccess(true)
//                            teamMemberACL.setWriteAccess(true, forRoleWithName: "Admin")
//                            teamMemberACL.setReadAccess(true, forRoleWithName: "Admin")
//                            
//                            let teamMember = PFRole(name: "TeamMember", acl: teamMemberACL)
//                            teamMember.saveInBackground()
                            
                            if newUser.signUp() {
                                hideHud(self.view)
                                
                                let newUserProfileVC = self.storyboard?.instantiateViewControllerWithIdentifier("NewUserProfileViewController") as? NewUserProfileViewController
                                self.navigationController!.pushViewController(newUserProfileVC!, animated:true)
                            } else {
                                UtilityClass .showAlert("Please try again.")
                            }
                        }
                    }
                }
            }
        }
    } // END of btnSignUp()

//==========================================================================================================================

// MARK: userd for show Indication

//==========================================================================================================================

    func showhud() {
        showHud(self.view)
    }
}
