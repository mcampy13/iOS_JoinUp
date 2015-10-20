//
//  LoginViewController.swift
//  SalesGame_swift
//
//  Created by Akuma on 9/11/15.
//  Copyright (c) 2015 Akuma. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtPassWord: UITextField!
    
    @IBOutlet var btnSignUp : UIButton!
    @IBOutlet var btnLogin : UIButton!
    @IBOutlet weak var btnResetPassword: UIButton!
    
    var currentUser: PFUser!
    
//==========================================================================================================================
    
// MARK: Life Cycle methods
    
//==========================================================================================================================
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UtilityClass .setBorderAndPlaceHolder(txtUserName)
        UtilityClass .setBorderAndPlaceHolder(txtPassWord)
        UtilityClass .setMyViewBorder(btnLogin, withBorder: 2, radius: 15)
        UtilityClass .setMyViewBorder(btnSignUp, withBorder: 2, radius: 15)
        
        currentUser = PFUser.currentUser()
        if((currentUser) != nil) {
            
           let str =  currentUser?.objectId
            NSUserDefaults .standardUserDefaults().setObject(str, forKey: kLoggedInUserId)
            let strUsername = currentUser?.username
            NSUserDefaults.standardUserDefaults().setObject(strUsername, forKey: kLoggedInUserName)
            var homeVC : HomeViewController?
            homeVC = self.storyboard?.instantiateViewControllerWithIdentifier("HomeViewController") as? HomeViewController
            self.navigationController!.pushViewController(homeVC!, animated: true)
        }
    }

 //==========================================================================================================================
 
 // MARK: buttons IBAction methods
 
 //==========================================================================================================================
    
    @IBAction func btnSignUp(sender: UIButton) {
        let signUpVC = self.storyboard?.instantiateViewControllerWithIdentifier("SignUpViewController") as! SignUpViewController
        self.navigationController!.pushViewController(signUpVC, animated: true)
    }
    
    @IBAction func btnLogin(sender: AnyObject) {
        if !txtUserName.text!.isEmpty {
            if !txtPassWord.text!.isEmpty {
                NSThread .detachNewThreadSelector("showhud", toTarget: self, withObject: nil)
                
                let  user =  PFUser.logInWithUsername(txtUserName.text!, password: txtPassWord.text!)
                if user != nil {
                    hideHud(self.view)
                    let str =  currentUser?.objectId
                    NSUserDefaults .standardUserDefaults().setObject(str, forKey: kLoggedInUserId)
                    var homeVC : HomeViewController?
                    homeVC = self.storyboard?.instantiateViewControllerWithIdentifier("HomeViewController") as? HomeViewController
                    let str11 =  currentUser?.objectId
                    NSUserDefaults .standardUserDefaults().setObject(str11, forKey: kLoggedInUserId)
                    let strUsername = currentUser?.username
                    NSUserDefaults.standardUserDefaults().setObject(strUsername, forKey: kLoggedInUserName)

                    self.navigationController!.pushViewController(homeVC!, animated: true)
                }
                else {
                    NSLog("Incorrect username or password, please try again.")
                }
            }
            else {
                UtilityClass .showAlert("Please insert your password")
            }
        } else {
            UtilityClass .showAlert("Please insert your username")
        }
    }

    @IBAction func btnResetPassword(sender: UIButton) {
        let resetPasswordVC = self.storyboard?.instantiateViewControllerWithIdentifier("ResetPasswordViewController") as? ResetPasswordViewController
            self.navigationController!.pushViewController(resetPasswordVC!, animated:true)
    }
//==========================================================================================================================

// MARK: userd for show Indication

//==========================================================================================================================
    
    
 func showhud() {
    showHud(self.view)
 }

}
