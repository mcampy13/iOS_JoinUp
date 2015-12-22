//
//  RankingsViewController.swift
//  SalesGame_swift
//
//  Created by Robert Rock on 12/9/15.
//  Copyright © 2015 Akshay. All rights reserved.
//

import UIKit

class RankingsViewController: UIViewController, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var rankingsTableView: UITableView!
    @IBOutlet weak var homeButton: UIButton!
    
    var PFCategory: PFObject!
    var PFSubCategory: PFObject!
    
    var finalArray: NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.barTintColor = UIColor.orangeColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        queryRankings()
    }
    
    
    func queryRankings() {
        let queryGame = PFQuery(className: "Game")
        queryGame.whereKey("subCategory", equalTo: PFSubCategory)
        queryGame.includeKey("category")
        queryGame.includeKey("player")
        queryGame.addDescendingOrder("score")
        queryGame.findObjectsInBackgroundWithBlock{ (success, error) -> Void in
            if error == nil {
                for var i=0; i < success!.count; i++ {
                    print("succes[i]: \(success![i])")
                    
                    let PFobj: PFObject = (success as! Array)[i]
                    self.finalArray.addObject(PFobj)
                }
                self.rankingsTableView.reloadData()
            } else {
                print("Error in queryRankings: \(error)")
            }
        }
    }

    
    //==========================================================================================================================
    
    // MARK: Navigation
    
    //==========================================================================================================================
  
    
    //==========================================================================================================================
    
    // MARK: TableDataSource & Delegate
    
    //==========================================================================================================================
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.finalArray.count == 0 {
            return 0
        } else {
            return self.finalArray.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = rankingsTableView!.dequeueReusableCellWithIdentifier("cell") as! RankingsTableViewCell
        
        cell.rankLabel?.text = String(stringInterpolationSegment: indexPath.row + 1)
        
        let score = self.finalArray.objectAtIndex(indexPath.row).valueForKey("score") as? Int!
        cell.scoreLabel?.text = String(stringInterpolationSegment: score!)
        
        cell.usernameLabel?.text = self.finalArray.objectAtIndex(indexPath.row).objectForKey("player")?.valueForKey("username") as? String
        if self.finalArray.objectAtIndex(indexPath.row).objectForKey("player")?.valueForKey("username") as? String == PFUser.currentUser()!.valueForKey("username") as? String {
        
        }
        
        return cell
    }
    
    
    
    //==========================================================================================================================
    
    // MARK: Actions
    
    //==========================================================================================================================
    
    @IBAction func homeButtonTap(sender: AnyObject) {
        let homeVC = self.storyboard?.instantiateViewControllerWithIdentifier("HomeViewController") as! HomeViewController
        self.navigationController?.pushViewController(homeVC, animated: true)
    }
    

    //==========================================================================================================================
    
    // MARK: Hud
    
    //==========================================================================================================================
    
    func showhud() {
        showHud(self.view)
    }
    
}
