//
//  ChallengeViewController.swift
//  SalesGame_swift
//
//  Created by Robert Rock on 10/21/15.
//  Copyright © 2015 Akshay. All rights reserved.
//

import UIKit

class ChallengeViewController: UIViewController{

    @IBOutlet weak var titleLabel: UILabel!
    
    var friendArray:AnyObject?
    var finalArray : NSMutableArray = []
    
    var friendUserArray: AnyObject?
    var to: AnyObject?
    var finalTo: NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSThread .detachNewThreadSelector("showhud", toTarget: self, withObject: nil)
        
        queryFriend()
        
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
    
    // MARK: Actions
    
    //==========================================================================================================================
    
    @IBAction func btnBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    
    //==========================================================================================================================
    
    // MARK: Progress hud display methods
    
    //==========================================================================================================================
    func showhud() {
        showHud(self.view)
    }
    

}
