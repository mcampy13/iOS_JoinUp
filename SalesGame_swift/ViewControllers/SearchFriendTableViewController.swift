//
//  SearchFriendTableViewController.swift
//  SalesGame_swift
//
//  Created by Robert Rock on 11/28/15.
//  Copyright © 2015 Akshay. All rights reserved.
//

import UIKit

class SearchFriendTableViewController: UITableViewController, UISearchResultsUpdating {
    
    /* BUG: with an array of strings like 'fixed', all names display when search view loads.
     *      Currenlty & after debugging, we can only see all the names if we click in the searchBar
     *      then click Cancel or click out of the view, then all the names will appear.
     *    Searching specific user will display name, but the image that displays is whomever's is the 
     *  'first' row in the table.
     *
     * NOTE: All searching does in fact work
     */

    let fixed = ["Red Fish", "Blue Fish", "Green Fish", "Gold fish"]

    var friends: NSMutableArray = []
    var holder: AnyObject?
    var ids = [String!]()
    var images = [UIImage]()
    var filteredFriends = [String]()
    var resultSearchController = UISearchController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor.orangeColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        queryFriends()
        
        self.resultSearchController = UISearchController(searchResultsController: nil)
        self.resultSearchController.searchResultsUpdater = self
        self.resultSearchController.dimsBackgroundDuringPresentation = false
        self.resultSearchController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = self.resultSearchController.searchBar
        
        self.tableView.reloadData()
        
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
                    
                    self.ids.append(obj.valueForKey("to")!.objectId)
                    print("User id: \(self.ids)")
                    
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

    
    //==========================================================================================================================
    
    // MARK: Table DataSource & Delegate
    
    //==========================================================================================================================

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.resultSearchController.active {
            return self.filteredFriends.count
        } else{
            return self.friends.count
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as? SearchFriendTableViewCell
        
        if self.resultSearchController.active {
            cell!.usernameLabel?.text = self.filteredFriends[indexPath.row]
            cell!.userImg?.image = self.images[indexPath.row]
        } else{
            cell!.usernameLabel?.text = self.friends[indexPath.row] as? String
            cell!.userImg?.image = self.images[indexPath.row]
        }
        
        return cell!
        
    }
    

    func updateSearchResultsForSearchController(searchController: UISearchController) {
        self.filteredFriends.removeAll(keepCapacity: false)
        
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        
        let array = (self.friends as NSArray).filteredArrayUsingPredicate(searchPredicate)
        self.filteredFriends = array as! [String]
        
        tableView.reloadData()
    }

    
}
