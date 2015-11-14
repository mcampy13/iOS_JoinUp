//
//  FriendViewController.swift
//  SalesGame_swift
//
//  Created by Robert Rock on 10/30/15.
//  Copyright © 2015 Akshay. All rights reserved.
//

import UIKit

class FriendViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var friendTableView: UITableView!
    
    
    var finalFriends: NSMutableArray = []
    var dataArray: AnyObject?
    var toUser: AnyObject?
    
    var friendUser: AnyObject?
    var friendUserName: String?
    
    var friendUserArray: AnyObject?
    var finalTo: NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSThread .detachNewThreadSelector("showhud", toTarget: self, withObject: nil)
        
        queryFriends()
        
    }
    
    func queryFriends(){
        //var queryUser = PFUser.query()
        let queryFriend = PFQuery(className: "Friend")
        //queryFriend.whereKey("from", equalTo: user!)
        queryFriend.findObjectsInBackgroundWithBlock { (friendObject, error) -> Void in
            if error == nil {
                //print("friends = \(friendObject)")
                self.dataArray = friendObject
                
                // query user to match with friend query
                for var i = 0;  i < friendObject!.count; i++ {
                    let obj:PFObject = (self.dataArray as! Array)[i];
                    self.finalFriends .addObject(obj)
                    
                    self.toUser = obj.objectForKey("to")
                    self.queryTo()
                }
                
//                self.toUser = self.finalFriends.valueForKey("to").valueForKey("objectId")
//                print("toUser \(self.toUser)")
//                
//                self.friendTableView!.reloadData()
//                hideHud(self.view)

            } else {
                print("Error \(error)")
            }
        }
    } // END of queryFriends()


    func queryTo(){
        let queryFriendUser = PFUser.query()
        queryFriendUser?.whereKey("objectId", equalTo: (self.toUser?.objectId)!)
        queryFriendUser?.findObjectsInBackgroundWithBlock { (friendUserObjArray, error) -> Void in
            if error == nil {
                self.friendUserArray = friendUserObjArray
                
                for var j=0; j < friendUserObjArray!.count; j++ {
                    let userObj: PFObject = (self.friendUserArray as! Array)[j]
                    self.finalTo.addObject(userObj)
                }
                print("finalTo \(self.finalTo)")
                self.friendTableView!.reloadData()
                hideHud(self.view)

            } else {
                print("Error \(error)")
            }
        }
    }
    
//    func queryTo(){
//        let queryFriendUser = PFUser.query()
//        queryFriendUser?.whereKey("objectId", equalTo: (self.to?.objectId)!)
//        queryFriendUser?.findObjectsInBackgroundWithBlock { (friendUserObjArray, error) -> Void in
//            if error == nil {
//                self.friendUserArray = friendUserObjArray
//                
//                for var j=0; j < friendUserObjArray!.count; j++ {
//                    let userObj: PFObject = (self.friendUserArray as! Array)[j]
//                    self.finalTo.addObject(userObj)
//                }
//                print("finalTo \(self.finalTo)")
//                
//            } else {
//                print("Error \(error)")
//            }
//        }
//    }

    
    func displayAlert(title: String, error: String){
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: {action in
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }

    //==========================================================================================================================
    
    // MARK: Table datasource and delegate methods
    
    //==========================================================================================================================
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.finalFriends.count == 0 {
            return 0
        } else {
            return self.finalFriends.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:FriendTableViewCell = friendTableView!.dequeueReusableCellWithIdentifier("cell") as! FriendTableViewCell
        
        let userId = self.finalFriends.objectAtIndex(indexPath.row).valueForKey("to")?.valueForKey("objectId") as? String
        //print("userId: \(userId)")
        let query = PFUser.query()?.whereKey("objectId", equalTo: userId!)
        query?.findObjectsInBackgroundWithBlock{ (success, error) -> Void in
            if error == nil {
                self.friendUser = success
                print("friendUser: \(self.friendUser?.valueForKey("username"))")
                
                //let name = self.friendUser?.valueForKey("username")
                //cell.nameLabel!.text = name as? String

            } else {
                print("Error matching friend to user: \(error)")
            }
        }
        
        cell.nameLabel?.text = self.finalFriends.objectAtIndex(indexPath.row).valueForKey("to")?.valueForKey("objectId") as? String
        return cell
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
