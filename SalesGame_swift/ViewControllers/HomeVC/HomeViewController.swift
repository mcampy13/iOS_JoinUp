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
    @IBOutlet var btnScore : UIButton!
    @IBOutlet var btnLogout : UIButton!
    @IBOutlet weak var helpBtn: UIButton!
    
    @IBOutlet weak var profilePic: UIImageView!
    
//==========================================================================================================================

// MARK: Life Cycle methods

//==========================================================================================================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //UtilityClass .setMyViewBorder(btnPlay, withBorder: 2, radius: 25)
        //UtilityClass .setMyViewBorder(btnSetting, withBorder: 2, radius: 25)
        //UtilityClass .setMyViewBorder(btnScore, withBorder: 2, radius: 25)
        //UtilityClass .setMyViewBorder(btnLogout, withBorder: 2, radius: 25)
        
        UtilityClass.setMyViewBorder(profilePic, withBorder: 0, radius: 50)
    }

//==========================================================================================================================

// MARK: IBAction methods

//==========================================================================================================================

    @IBAction func btnPlay(sender: UIButton) {
        let categoryVC = self.storyboard?.instantiateViewControllerWithIdentifier("AllCategoryViewController") as? AllCategoryViewController
        self.navigationController!.pushViewController(categoryVC!, animated: true)
    }
    
    @IBAction func btnProfile(sender: UIButton) {
       let settingVC = self.storyboard?.instantiateViewControllerWithIdentifier("SettingViewController") as? SettingViewController
        self.navigationController!.pushViewController(settingVC!, animated: true)
    }
    
    @IBAction func btnLeader(sender: UIButton) {
       let highScoreVC = self.storyboard?.instantiateViewControllerWithIdentifier("HighScoreViewController") as? HighScoreViewController
        self.navigationController!.pushViewController(highScoreVC!, animated: true)
    }
    
    @IBAction func helpBtn(sender: UIButton) {
        let helpVC = self.storyboard?.instantiateViewControllerWithIdentifier("HelpViewController") as? HelpViewController
        self.navigationController!.pushViewController(helpVC!, animated: true)
    }
    
    @IBAction func btnLogout(sender: UIButton) {
        PFUser .logOutInBackground()
        self.navigationController!.popToRootViewControllerAnimated(true)
    }
}
