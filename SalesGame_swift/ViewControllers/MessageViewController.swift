//
//  MessageViewController.swift
//  SalesGame_swift
//
//  Created by Robert Rock on 11/26/15.
//  Copyright © 2015 Akshay. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor.orangeColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        menuButton.target = self.revealViewController()
        menuButton.action = Selector("revealToggle:")
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        
    }

    

}
