//
//  CheckAnswersViewController.swift
//  SalesGame_swift
//
//  Created by Robert Rock on 12/20/15.
//  Copyright © 2015 Akshay. All rights reserved.
//

import UIKit

class CheckAnswersViewController: UIViewController, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var homeButton: UIButton!
    
    
    
    var gameArray: NSMutableArray = NSMutableArray()
    var wrongAnswers: NSMutableArray = NSMutableArray()
    var correctAnswers: NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor.orangeColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        fetchAllObjectFromLocalDatastore()
        fetchAllObjects()
        

    }
    
    func fetchAllObjectFromLocalDatastore() {
        let queryGameFromLocal = PFQuery(className: "Game")
        queryGameFromLocal.fromLocalDatastore()
        queryGameFromLocal.whereKey("player", equalTo: PFUser.currentUser()!)
        queryGameFromLocal.addAscendingOrder("createdAt")
        queryGameFromLocal.findObjectsInBackgroundWithBlock{ (objects, error) -> Void in
            if error == nil {
                var temp: NSArray = objects! as NSArray
                
                self.gameArray = temp.mutableCopy() as! NSMutableArray
                
            } else {
                print("Error CheckAnswers, fetchAllObjectsFromLocalDatastore() : \(error)")
            }
        }
        print("fetchAllObjectFromLocalDatastore() objects: \(self.gameArray)")
    }
    
    func fetchAllObjects() {
        //PFObject.unpinAllObjectsInBackgroundWithBlock(nil)
        
        let query = PFQuery(className: "Game")
        query.whereKey("player", equalTo: PFUser.currentUser()!)
        query.addAscendingOrder("createdAt")
        query.limit = 5
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                print("fetchAll objects: \(objects)")
                PFObject.pinAllInBackground(objects, block: nil)
                
                self.fetchAllObjectFromLocalDatastore()
                
            } else {
                print("Error CheckAnswers; in fetchAllObjects() : \(error)")
            }
        }
    }
    
    
    
    //==========================================================================================================================
    
    // MARK: Table datasource and delegate methods
    
    //==========================================================================================================================
  
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.gameArray.count == 0 {
            return 0
        } else {
            return self.gameArray.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCellWithIdentifier("cell") as? ReviewTableViewCell
        
        let obj: PFObject = self.gameArray.objectAtIndex(indexPath.row) as! PFObject
                
        return cell!
        
    }
    
    //==========================================================================================================================
    
    // MARK: Actions
    
    //==========================================================================================================================

    @IBAction func homeButtonTapped(sender: AnyObject) {
        let homeVC = self.storyboard?.instantiateViewControllerWithIdentifier("HomeViewController") as? HomeViewController
        self.navigationController?.pushViewController(homeVC!, animated: true)
    }

    

}
