//
//  TopRatedViewController.swift
//  SalesGame_swift
//
//  Created by Robert Rock on 12/2/15.
//  Copyright © 2015 Akshay. All rights reserved.
//

import UIKit

class TopRatedViewController: UIViewController, UINavigationControllerDelegate {

    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.barTintColor = UIColor.orangeColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        menuButton.target = self.revealViewController()
        menuButton.action = Selector("revealToggle:")
        
    }


}
