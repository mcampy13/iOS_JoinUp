//
//  RecentViewController.swift
//  SalesGame_swift
//
//  Created by Robert Rock on 12/2/15.
//  Copyright © 2015 Akshay. All rights reserved.
//

import UIKit

class RecentViewController: UIViewController, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var addButton: UIBarButtonItem!

    @IBOutlet weak var questionTextField: UITextView!
    @IBOutlet weak var recentTable: UITableView!

    
    var questionText: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //checkValidQuestion()
        
        self.navigationController?.navigationBar.barTintColor = UIColor.orangeColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]

    }
    
    
    //==========================================================================================================================
    
    // MARK: Navigation
    
    //==========================================================================================================================

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if addButton === sender {
            let newQuestion = self.questionTextField.text
            self.questionText = newQuestion
            
            
        }
    }
    
    
    //==========================================================================================================================
    
    // MARK: UITextFieldDelegate
    
    //==========================================================================================================================

    func textFieldDidBeginEditing(textField: UITextField) {
        addButton.enabled = false
    }
    
    func checkValidQuestion() {
        let text = questionTextField.text ?? "" 
        addButton.enabled = !text.isEmpty
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        checkValidQuestion()
    }
    
    
    
    
}
