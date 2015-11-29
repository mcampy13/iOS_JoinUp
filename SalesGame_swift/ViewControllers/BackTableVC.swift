//
//  BackTableVC.swift
//  SalesGame_swift
//
//  Created by Robert Rock on 11/25/15.
//  Copyright © 2015 Akshay. All rights reserved.
//

import Foundation

class BackTableVC: UITableViewController {
    
    var tableArray = [String]()
    
    override func viewDidLoad() {
        
        tableArray = ["Home", "Messages", "Badges", "Help", "Submit Questions", "Settings"]
        
    }
    
    func displayAlert(title: String, error: String){
        let alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: {action in
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(tableArray[indexPath.row], forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel?.text = self.tableArray[indexPath.row]
        
        return cell
    }
    
}