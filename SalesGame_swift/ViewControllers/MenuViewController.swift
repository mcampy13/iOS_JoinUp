//
//  MenuViewController.swift
//  SalesGame_swift
//
//  Created by Robert Rock on 11/22/15.
//  Copyright © 2015 Akshay. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var menuTableView: UITableView!
    
    var menuItemsArray: NSMutableArray! = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //NSThread .detachNewThreadSelector("showhud", toTarget: self, withObject: nil)
        
        self.navigationBar.title = "Menu"
    
        self.menuItemsArray.addObject("Badges")
        self.menuItemsArray.addObject("Submit Questions")
        self.menuItemsArray.addObject("Settings")
        self.menuItemsArray.addObject("Help")
        
        self.menuTableView.reloadData()
    }
    
    
    
    //==========================================================================================================================
    
    // MARK: table datasource & delegate
    
    //==========================================================================================================================
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuItemsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.menuTableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! MenuTableViewCell
        
        cell.menuItemTitleLabel.text = self.menuItemsArray.objectAtIndex(indexPath.row) as? String
        
        return cell
    }
   
//    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
//        <#code#>
//    }

    
    
    //==========================================================================================================================
    
    // MARK: Actions
    
    //==========================================================================================================================
    
    @IBAction func homeButtonTap(sender: AnyObject) {
        let homeVC = self.storyboard?.instantiateViewControllerWithIdentifier("HomeViewController") as? HomeViewController
        self.navigationController?.pushViewController(homeVC!, animated: true)
    }
    
    
    //==========================================================================================================================
    
    // MARK: Progress hud display methods
    
    //==========================================================================================================================
    
    func showhud() {
        showHud(self.view)
    }

}
