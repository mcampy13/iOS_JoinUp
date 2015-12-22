//
//  UserProfileViewController.swift
//  SalesGame_swift
//
//  Created by Robert Rock on 12/21/15.
//  Copyright © 2015 Akshay. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var addbutton: UIBarButtonItem!
    
    @IBOutlet weak var homeButton: UIButton!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    var user: Friend? {
        didSet {
            configureView()
        }
    }
    
    func configureView() {
        if let user = user {
            if let usernameLabel = usernameLabel {
                usernameLabel.text = user.name
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.barTintColor = UIColor.orangeColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    
        configureView()
    
    }
    
    
    // MARK: Navigation
    
    
    
    // MARK: Actions
    
    @IBAction func homeButtonTapped(sender: AnyObject) {
        let homeVC = self.storyboard?.instantiateViewControllerWithIdentifier("HomeViewController") as! HomeViewController
        self.navigationController?.pushViewController(homeVC, animated: true)
    }
    

}
