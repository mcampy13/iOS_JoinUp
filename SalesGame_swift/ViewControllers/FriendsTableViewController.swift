//
//  FriendsTableViewController.swift
//  SalesGame_swift
//
//  Created by Robert Rock on 12/21/15.
//  Copyright © 2015 Akshay. All rights reserved.
//

import UIKit


extension FriendsTableViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

class FriendsTableViewController: UITableViewController, UINavigationControllerDelegate {

    // MARK: Properties
    var friends = [Friend]()
    var filteredFriends = [Friend]()
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor.orangeColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        friends = [
            Friend(name: "Ben Bugher"),
            Friend(name: "Cassy Galon"),
            Friend(name: "Chris Bubel"),
            Friend(name: "Noah Andrews"),
            Friend(name: "Matt Campy"),
            Friend(name: "Akuma Johny"),
            Friend(name: "Jackie Kramer"),
            Friend(name: "John Royer"),
            Friend(name: "Shannon Spoulsen")
        ]

        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    // MARK: SearchResultsUpdating & Filtering
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredFriends = friends.filter { friend in
            return friend.name.lowercaseString.containsString(searchText.lowercaseString)
        }
        tableView.reloadData()
    }
    
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return filteredFriends.count
        } else {
            return friends.count
        }
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

        var friend = friends[indexPath.row]
        
        if searchController.active && searchController.searchBar.text != "" {
            friend = filteredFriends[indexPath.row]
        } else {
            friend = friends[indexPath.row]
        }
        
        cell.textLabel?.text = friend.name

        return cell
    }
    

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueUserProfile" {
            if let indexPath = tableView.indexPathForSelectedRow {
                
                let friend: Friend
                
                if searchController.active && searchController.searchBar.text != "" {
                    friend = filteredFriends[indexPath.row]
                } else {
                    friend = friends[indexPath.row]
                }
                
                let userProfile = segue.destinationViewController as! UserProfileViewController
                userProfile.user = friend
            }
        }
    }
    
    
    
    
    
    
    

}
