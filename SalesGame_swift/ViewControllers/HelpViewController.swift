//
//  HelpViewController.swift
//  SalesGame_swift
//
//  Created by Robert Rock on 10/20/15.
//  Copyright © 2015 Akshay. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {

    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var composeButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: Actions
    
    @IBAction func cancelButton(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func composeButton(sender: AnyObject) {
        UtilityClass.showAlert("Ask for Help!")
    }
}
