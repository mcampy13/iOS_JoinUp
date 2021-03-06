//
//  LoginViewController.swift
//  SalesGame_swift
//
//  Created by Akuma on 9/11/15.
//  Copyright (c) 2015 Akuma. All rights reserved.
//

import UIKit
import LocalAuthentication

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtPassWord: UITextField!
    
    @IBOutlet var btnSignUp : UIButton!
    @IBOutlet var btnLogin : UIButton!
    @IBOutlet weak var btnResetPassword: UIButton!
    
    @IBOutlet weak var lblAuthResult: UILabel!
    
    
    var currentUser: PFUser!
    
//==========================================================================================================================
    
// MARK: Life Cycle methods
    
//==========================================================================================================================
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtUserName.delegate = self
        txtPassWord.delegate = self
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("dismissKeyboard")))
        
        currentUser = PFUser.currentUser()
        if((currentUser) != nil) {
            
            let str =  currentUser?.objectId
            NSUserDefaults .standardUserDefaults().setObject(str, forKey: kLoggedInUserId)
            let strUsername = currentUser?.username
            NSUserDefaults.standardUserDefaults().setObject(strUsername, forKey: kLoggedInUserName)
            
            //self.isAdmin()
            
//            var homeVC : HomeViewController?
//            homeVC = self.storyboard?.instantiateViewControllerWithIdentifier("HomeViewController") as? HomeViewController
//            self.navigationController!.pushViewController(homeVC!, animated: true)
        }
        
    }
    
    func dismissKeyboard() {
        txtUserName.resignFirstResponder()
        txtPassWord.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        txtUserName.resignFirstResponder()
        txtPassWord.resignFirstResponder()
        return true
    }
    
    func isAdmin() {
        let roleACL = PFACL()
        roleACL.setPublicReadAccess(true)
        roleACL.setPublicWriteAccess(false)
        
        let role = PFRole(name: "Admin", acl: roleACL)
        
        let user = PFQuery.getUserObjectWithId("AU98WHZZBa")
        role.users.addObject(user!)
        role.saveInBackgroundWithBlock{ (success, error) -> Void in
            if error == nil {
                print("Admin is \(user) with role title :\(role)")
            } else{
                print("Error saving role: \(error)")
            }
        }
    }
    
    func writeOutAuthResult(authError:NSError?) {
        dispatch_async(dispatch_get_main_queue(), {() in
            if let possibleError = authError {
                self.lblAuthResult.textColor = UIColor.redColor()
                self.lblAuthResult.text = possibleError.localizedDescription
            }
            else {
                self.lblAuthResult.textColor = UIColor.greenColor()
                self.lblAuthResult.text = "Authentication successful."
            }
        })
    }
    
    func loadData(){
        print("data is loading")
        
    }
    
    
//==========================================================================================================================
    
// MARK: Navigation
    
//==========================================================================================================================
    
    
    
 //==========================================================================================================================
 
 // MARK: Actions
 
 //==========================================================================================================================
   
    @IBAction func beginTouchIDAuthCheck(sender: AnyObject) {
        let authContext:LAContext = LAContext()
        var error:NSError?
        
        // Is Touch ID hardware available & configured?
        if(authContext.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error:&error)) {
            //Perform Touch ID auth
            authContext.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: "Login with Touch ID", reply: {(successful:Bool, error:NSError?) in
                
                if(successful) {
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        self.loadData()
//                        let homeVC = self.storyboard!.instantiateViewControllerWithIdentifier("HomeViewController") as! HomeViewController
//                        self.navigationController!.pushViewController(homeVC, animated: true)

                    })
                } else {
                    //There are a few reasons why it can fail, we'll write them out to the user in the label
                    
                    self.writeOutAuthResult(error)
                }
            })
        } else {
            //Missing the hardware or Touch ID isn't configured
            self.writeOutAuthResult(error)
        }
    }

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
                    
//                    var homeVC : HomeViewController?
//                    homeVC = self.storyboard?.instantiateViewControllerWithIdentifier("HomeViewController") as? HomeViewController
                    
                    let str11 =  currentUser?.objectId
                    NSUserDefaults .standardUserDefaults().setObject(str11, forKey: kLoggedInUserId)
                    let strUsername = currentUser?.username
                    NSUserDefaults.standardUserDefaults().setObject(strUsername, forKey: kLoggedInUserName)

                    //self.navigationController!.pushViewController(homeVC!, animated: true)
                }
                else {
                    let loginVC = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
                    self.navigationController?.pushViewController(loginVC, animated: true)
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
