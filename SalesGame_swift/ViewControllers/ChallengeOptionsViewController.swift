//
//  ChallengeOptionsViewController.swift
//  SalesGame_swift
//
//  Created by Robert Rock on 12/17/15.
//  Copyright © 2015 Akshay. All rights reserved.
//

import UIKit

class ChallengeOptionsViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var challengeFriendButton: UIButton!
    @IBOutlet weak var challengeRandomButton: UIButton!
    @IBOutlet weak var challengeStatsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor.orangeColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        

    }

   
    

   

}
