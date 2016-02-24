//
//  FeedTableViewController.swift
//  Moments
//
//  Created by Taha Abbasi on 10/29/15.
//  Copyright © 2015 TahaAbbasi. All rights reserved.
//

import UIKit
import Parse


class FeedTableViewController: UITableViewController {
    
    //MARK: - Local Storage Info
    // Creating the messages, usernames and imageFiles array to store all the users retrived from Parse in a query below. Additionally creating the "users" dictionary which will hold the userName and userId so that we can use these to look up one or the other later.
    
    var messages = [String]()
    var usernames = [String]()
    var imageFiles = [PFFile]()
    var users = [String : String]()

    
    //MARK: - Logout
    @IBAction func logout(sender: AnyObject) {
        
        var alert = UIAlertController(title: "Logout", message: "Would you like to logout?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            
        }))
        
        alert.addAction(UIAlertAction(title: "Logout", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            
            PFUser.logOut()
            let viewController = self.storyboard?.instantiateInitialViewController() as UIViewController!
            self.presentViewController(viewController, animated: true, completion: nil)
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)

        
        
    }
    
    //Mark: -
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        //MARK: - Querying all the Users on parse
        
        var query = PFUser.query()
        
        query?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            
            // Checking if any objects were retrieved
            
            if let users = objects {
                
                // Clearing the previously stored data in the array to avoid duplicates and inaccuracy
                
                self.users.removeAll(keepCapacity: true)
                self.usernames.removeAll(keepCapacity: true)
                self.messages.removeAll(keepCapacity: true)
                self.imageFiles.removeAll(keepCapacity: true)
                
                
                // Adding the users retrieved from the Parse data base to the users dictionary with key of objectId/userId and value of username
                
                for object in users {
                    
                    
                    if let user = object as? PFUser {
                        
                        self.users[user.objectId!] = user.username!
                        
                    }
                }
            }
            
            // MARK: - Finding Out Who This User Follows
            // Once we know the list of people the user follows we can download their images and show them to the user in the feed.
            
            var getFollowedUsersQuery = PFQuery(className: "followers")
            
                
            // Querying the followers class where the follower collumn equals to the current user
            getFollowedUsersQuery.whereKey("follower", equalTo: PFUser.currentUser()!.objectId!)
            getFollowedUsersQuery.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
                
                // The objects returned as a result of this query are all the users followed by the current user.
                // checking if any objects were returned
                if let objects = objects {
                    
                    
                    // Looping through the objects returned to retrieve relevent data
                    for object in objects {
                        
                        
                        // getting the objectId of the person being followed so we can retrieve their posts using this id
                        var followedUser = object["following"] as! String
                        
                        
                        // getting the followed users posts by querying the Post class and getting all the posts where the userId equals the followed users' id
                        var query = PFQuery(className: "Post")
                        query.whereKey("userId", equalTo: followedUser)
                        query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                            
                            // The objects returned as a result of this query are all the posts by this user.
                            // checking if any objects were returned
                            if let objects = objects {
                                
                                // Looping through the objects returned to retrieve relevent data
                                for object in objects {
                                    
                                    // from each post adding the message to the messages local array
                                    self.messages.append(object["message"] as! String)
                                    
                                    
                                    // from each post adding the imageFile to the imageFiles local array
                                    self.imageFiles.append(object["imageFile"] as! PFFile)
                                    
                                    // from each post adding the username to the messages local array
                                    // This is a bit tricky, because to look up the username, we have to query the local "users" dictionary which has objectIds/userIds and user names.
                                    // We query this dictionary with the key of the objectId of the current object i.e. object id associated with this post, and that will tell us the corresponding username in that users dictionary. Which we then add the the usernames local array for this post.
                                    self.usernames.append(self.users[object["userId"] as! String]!)
                                    
                                    
                                    
                                    var query = PFQuery(className: "Post")
                                    query.whereKey("userId", equalTo: PFUser.currentUser()!.objectId!)
                                    query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                                        
                                        // The objects returned as a result of this query are all the posts by this user.
                                        // checking if any objects were returned
                                        if let objects = objects {
                                            
                                            // Looping through the objects returned to retrieve relevent data
                                            for object in objects {
                                                
                                                // from each post adding the message to the messages local array
                                                self.messages.append(object["message"] as! String)
                                                
                                                
                                                // from each post adding the imageFile to the imageFiles local array
                                                self.imageFiles.append(object["imageFile"] as! PFFile)
                                                
                                                // from each post adding the username to the messages local array
                                                // This is a bit tricky, because to look up the username, we have to query the local "users" dictionary which has objectIds/userIds and user names.
                                                // We query this dictionary with the key of the objectId of the current object i.e. object id associated with this post, and that will tell us the corresponding username in that users dictionary. Which we then add the the usernames local array for this post.
                                                self.usernames.append(self.users[PFUser.currentUser()!.objectId!]! as String)
                                                
                                                
                                                // Reloading the table data several times to populate the table with these results before we download the image. We'll do that seperate that way we have something to display, as the image download can take  a while.
                                                self.tableView.reloadData()
                                                
                                            }
                                            
                                        }
                                        
                                        
                                    })
                                    
                                    
                                    // Reloading the table data several times to populate the table with these results before we download the image. We'll do that seperate that way we have something to display, as the image download can take  a while.
                                    self.tableView.reloadData()
                                    
                                }
                                
                            }
                            
                            
                        })
                        
                    }
                    
                }
                
            }
        
        })
        
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
        let myCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! Cell

        // Configure the cell...
        
        imageFiles[indexPath.row].getDataInBackgroundWithBlock { (data, error) -> Void in
            
            if let downloadedImage = UIImage(data: data!) {
                
                myCell.postedImage.image = downloadedImage
                
            }
            
            
        }
        myCell.username.text = usernames[indexPath.row]
        myCell.message.text = messages[indexPath.row]

        return myCell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
