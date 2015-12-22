//
//  FriendViewController.swift
//  SalesGame_swift
//
//  Created by Robert Rock on 11/16/15.
//  Copyright © 2015 Akshay. All rights reserved.
//

import UIKit

class FriendViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {

    
    @IBOutlet weak var tblView: UITableView!
    
    var friends: NSMutableArray = []
    var holder: AnyObject?
    var images = [UIImage]()
    var filteredFriends = [String]()
    var resultSearchController = UISearchController()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        queryFriends()
        
        self.resultSearchController = UISearchController(searchResultsController: nil)
        self.resultSearchController.searchResultsUpdater = self
        self.resultSearchController.dimsBackgroundDuringPresentation = false
        self.resultSearchController.searchBar.sizeToFit()
        
        self.tblView.tableHeaderView = self.resultSearchController.searchBar

        self.tblView.reloadData()
    
    }
    
    
    func queryFriends(){
        let query = PFQuery(className: "Friend")
        query.whereKey("from", equalTo: PFUser.currentUser()!)
        query.includeKey("to")
        query.findObjectsInBackgroundWithBlock{ (success, error) -> Void in
            if error == nil {
                self.holder = success
                print("holder: \(self.holder)")
                for var i=0; i < self.holder!.count; i++ {
                    let obj: PFObject = (self.holder as! Array)[i]
                    self.friends.addObject(obj.valueForKey("to")!.valueForKey("username")!)
                    
                    let userObjQuery = PFQuery.getUserObjectWithId(obj.valueForKey("to")!.objectId!!)
                    
                    let file: PFFile = userObjQuery?.valueForKey("profilePic") as! PFFile
                    file.getDataInBackgroundWithBlock({
                        (picData, error) -> Void in
                        if error == nil {
                            let Image: UIImage = UIImage(data: picData!)!
                            self.images.append(Image)
                            print("images \(self.images)")
                        } else{
                            print("Error getting file \(error)")
                        }
                    })
                }
                print("friends: \(self.friends)")
            } else{
                print("Error in query: \(error)")
            }
        }
    } // END of queryFriends()
    
    
    
    
    func displayAlert(title: String, error: String){
        let alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: {action in
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }

    //==========================================================================================================================
    
    // MARK: Table DataSource & Delegate
    
    //==========================================================================================================================
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.resultSearchController.active {
            return self.filteredFriends.count
        } else{
            return self.friends.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as? testTableViewCell

        if self.resultSearchController.active {
            cell!.usernameLabel?.text = self.filteredFriends[indexPath.row]
            cell!.userImg.image = self.images[indexPath.row]
        } else{
            cell!.usernameLabel?.text = self.friends[indexPath.row] as? String
            cell!.userImg.image = self.images[indexPath.row]
        }
        
        return cell!
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        self.filteredFriends.removeAll(keepCapacity: false)
        
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        
        let array = (self.friends as NSArray).filteredArrayUsingPredicate(searchPredicate)
        self.filteredFriends = array as! [String]
        
        self.tblView.reloadData()
    }
    
    
    //==========================================================================================================================
    
    // MARK: Actions
    
    //==========================================================================================================================
    
   
    
    //==========================================================================================================================
    
    // MARK: Progress hud display methods
    
    //==========================================================================================================================
    
    func showhud() {
        showHud(self.view)
    }

    

}
