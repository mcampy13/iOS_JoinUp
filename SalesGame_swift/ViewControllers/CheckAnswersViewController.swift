//
//  CheckAnswersViewController.swift
//  SalesGame_swift
//
//  Created by Robert Rock on 12/20/15.
//  Copyright © 2015 Akshay. All rights reserved.
//

import UIKit

class CheckAnswersViewController: UIViewController, UINavigationControllerDelegate {

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
        queryGameFromLocal.whereKey("player", equalTo: PFUser.currentUser()!.objectId!)
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
        query.whereKey("player", equalTo: PFUser.currentUser()!.objectId!)
        query.addAscendingOrder("createdAt")
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
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
  
    
    

    

}
