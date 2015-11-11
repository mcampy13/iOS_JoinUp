//
//  ChallengeViewController.swift
//  SalesGame_swift
//
//  Created by Robert Rock on 10/21/15.
//  Copyright © 2015 Akshay. All rights reserved.
//

import UIKit

class ChallengeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var challengeTable: UITableView!
    
    var friendArray:AnyObject?
    var finalArray : NSMutableArray = []
    
    var friendUserArray: AnyObject?
    var to: AnyObject?
    var finalTo: NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSThread .detachNewThreadSelector("showhud", toTarget: self, withObject: nil)
        
//        queryFriend()
        let query = PFUser.query()
        query?.findObjectsInBackgroundWithBlock { (success, error) -> Void in
            if error == nil {
                self.friendArray = success
                for var i=0; i < success!.count; i++ {
                    let userPFObj: PFObject = (self.friendArray as! Array)[i]
                    self.finalArray.addObject(userPFObj)
                }
                self.challengeTable.reloadData()
                hideHud(self.view)
            } else {
                print("Error in querying for Users \(error)")
            }
        }
        
    }
    
    func queryFriend(){
        let queryFriend = PFQuery(className: "Friend")
        
        queryFriend.findObjectsInBackgroundWithBlock { (objArray, error) -> Void in
            if error == nil {
                self.friendArray = objArray;
                
                for var i = 0;  i < objArray!.count; i++ {
                    let friendObj:PFObject = (self.friendArray as! Array)[i];
                    self.finalArray.addObject(friendObj)
                    
                    self.to = friendObj.objectForKey("to")
                    self.queryTo()
                }
                print("finalArray",self.finalArray as NSMutableArray)
                
                hideHud(self.view)
            } else {
                print("Error \(error)")
            }
        }
    }
    
    func queryTo(){
        let queryFriendUser = PFUser.query()
        queryFriendUser?.whereKey("objectId", equalTo: (self.to?.objectId)!)
        queryFriendUser?.findObjectsInBackgroundWithBlock { (friendUserObjArray, error) -> Void in
            if error == nil {
                self.friendUserArray = friendUserObjArray
                
                for var j=0; j < friendUserObjArray!.count; j++ {
                    let userObj: PFObject = (self.friendUserArray as! Array)[j]
                    self.finalTo.addObject(userObj)
                }
                print("finalTo \(self.finalTo)")
                
            } else {
                print("Error \(error)")
            }
            
        }

    }
    
    
    //==========================================================================================================================
    
    // MARK: Table datasource and delegate methods
    
    //==========================================================================================================================
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.friendArray == nil) {
            return 0
        } else {
            return self.friendArray!.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = challengeTable.dequeueReusableCellWithIdentifier("cell") as? ChallengeTableViewCell
        let obj:PFObject = (self.friendArray as! Array)[indexPath.row];
        cell!.labelUsername!.text = obj.valueForKey("username") as? String
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let challengeCategoryVC = self.storyboard?.instantiateViewControllerWithIdentifier("ChallengeCategoryViewController") as? ChallengeCategoryViewController
        let obj:PFObject = (self.friendArray as! Array)[indexPath.row];
        challengeCategoryVC!.challengeUser = obj.valueForKey("username") as? String
        challengeCategoryVC!.challengeUserId = obj.objectId
        print("Selected: \(obj.valueForKey("username"))")
        self.navigationController!.pushViewController(challengeCategoryVC!, animated:true)
    }

    
    //==========================================================================================================================
    
    // MARK: Actions
    
    //==========================================================================================================================
    
    @IBAction func doneButton(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    //==========================================================================================================================
    
    // MARK: Progress hud display methods
    
    //==========================================================================================================================
    func showhud() {
        showHud(self.view)
    }
    

}
