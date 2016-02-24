//
//  TableViewController.swift
//  Moments
//
//  Created by Taha Abbasi on 10/28/15.
//  Copyright © 2015 TahaAbbasi. All rights reserved.
//

import UIKit
import Parse

class TableViewController: UITableViewController {
    
    
    // Creating arrays to store the usernames, userIds, and follower information retrieved from the Parse database locally in an array, so they can be used in the app.
    
    var usernames = [""]
    var userIds = [""]
    var isFollowing = ["":false]
    
    //MARK: Pull To Refresh var and function Declarations
    var refresher : UIRefreshControl!
    
    func refresh() {
        
        //MARK: - Query Users on Parse
        
        var query = PFUser.query()
        
        query?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            
            // Checking if any objects were retrieved
            
            if let users = objects {
                
                // Clearing the previously stored data in the array to avoid duplicates and inaccuracy
                
                self.usernames.removeAll(keepCapacity: true)
                self.userIds.removeAll(keepCapacity: true)
                self.isFollowing.removeAll(keepCapacity: true)
                
                
                // Adding the users retrieved from the Parse data base to the usernames and userIds array
                
                for object in users {
                    
                    if let user = object as? PFUser {
                        
                        // This line of code is to check if the user object is the same is the user that is logged in, if so we are not adding that user to the usernames and userIds array because we don't want to display our selves in the userList or friendsList in the app.
                        
                        if user.objectId != PFUser.currentUser()?.objectId {
                            
                            if let username = user.username {
                                
                                self.usernames.append(user.username!)
                                
                                if let userId = user.objectId {
                                    
                                    self.userIds.append(user.objectId!)
                                    
                                    
                                    // Cheacking if the users follower information to display in userlist
                                    
                                    // Querying the follower table in Parse
                                    var query = PFQuery(className: "followers")
                                    
                                    // Looking for information where the follower is the current user and the following is the object id of the user that was just retrieved. If this is the case, we will store these users in an Dictionary so that we can display check marks for these users in the UserList as already following users.
                                    
                                    query.whereKey("follower", equalTo: (PFUser.currentUser()!.objectId)!)
                                    query.whereKey("following", equalTo: user.objectId!)
                                    
                                    query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                                        
                                        
                                        if let objects = objects {
                                            
                                            if objects.count > 0 {
                                                
                                                self.isFollowing[user.objectId!] = true
                                                
                                            } else {
                                                
                                                self.isFollowing[user.objectId!] = false
                                                
                                            }
                                            
                                        }
                                        
                                        //MARK: Table Reload Data Important Note
                                        // This check is to make sure that the table is not updated until we have all the follower information.
                                        // Since we are setting the usernames before checking follower data, we are running a check below to see when the isFollowing array count matches teh usernames Array count. This will indicate that all the users follower data has been retrieved.
                                        // After this point we will reload the table data.
                                        
                                        if self.isFollowing.count == self.usernames.count {
                                            
                                            self.tableView.reloadData()
                                            
                                            self.refresher.endRefreshing()
                                            
                                        }
                                        
                                    })
                                    
                                }
                                
                            }
                            
                        }
                    }
                    
                }
                
            }
            
            
            
        })
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK:- Pull To Refresh setup
        refresher = UIRefreshControl()
        
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        
        self.tableView.addSubview(refresher)
        
        refresh()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return usernames.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        cell.textLabel?.text = usernames.sort()[indexPath.row]
        
        
        // here we are checking if the user we are putting in the user list is one of the people that is someone we are following, if so we are adding a check mark next to them in the user list.
        
        let followedObjectId = userIds[indexPath.row]
        
        if isFollowing[followedObjectId] == true {
            
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            
        }

        return cell
    }


    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //MARK: - Following Methodology
        var cell : UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        
        let followedObjectId = userIds[indexPath.row]
        
        // checking if already following the user selected or not to determine which actions should be taken with Parse.
        if isFollowing[followedObjectId] == false {
            
            //MARK: Updating the cell with checkmarks
            
            isFollowing[followedObjectId] = true
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            
            //MARK: follow parse code
            
            var following = PFObject(className: "followers")
            following["following"] = userIds[indexPath.row]
            following["follower"] = PFUser.currentUser()?.objectId
            
            following.saveInBackground()
            
        } else {
            
            //MARK: Updating the cell with checkmarks
            
            isFollowing[followedObjectId] = false
            cell.accessoryType = UITableViewCellAccessoryType.None
            
            //MARK: unfollow parse code
            var query = PFQuery(className: "followers")
            
            // Looking for information where the follower is the current user and the following is the object id of the user that was just retrieved. If this is the case, we will store these users in an Dictionary so that we can display check marks for these users in the UserList as already following users.
            
            query.whereKey("follower", equalTo: (PFUser.currentUser()!.objectId)!)
            query.whereKey("following", equalTo: userIds[indexPath.row])
            
            query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                
                
                if let objects = objects {
                    
                    for object in objects {
                        
                        object.deleteInBackground()
                        
                    }
                }
                
            })
            
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
