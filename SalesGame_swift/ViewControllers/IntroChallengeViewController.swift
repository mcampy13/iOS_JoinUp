//
//  IntroChallengeViewController.swift
//  SalesGame_swift
//
//  Created by Robert Rock on 12/3/15.
//  Copyright © 2015 Akshay. All rights reserved.
//

import UIKit

class IntroChallengeViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.barTintColor = UIColor.orangeColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        
    }
    
    
    // MARK: Navigation
    
    
    
    // MARK: Actions
    
    @IBAction func cancelButtonTap(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
}
