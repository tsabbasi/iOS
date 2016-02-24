//
//  ConnectionsTableViewController.swift
//  Meet A Muslim
//
//  Created by Taha Abbasi on 1/28/16.
//  Copyright © 2016 TahaAbbasi. All rights reserved.
//

import UIKit
import Parse

class ConnectionsTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var objectId = [String]()
    var facebookIds = [String]()
    var names = [String]()
    var emails = [String]()
    var images = [String : UIImage]()
    var currentUserAccepted = [String]()

    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        if let userAceeptedList = PFUser.currentUser()?["accepted"] {
            
            currentUserAccepted += userAceeptedList as! [String]
            
        }
        
        var query = PFUser.query()!
        query.whereKey("accepted", equalTo: PFUser.currentUser()!.objectId!)
        query.whereKey("objectId", containedIn: currentUserAccepted)
        
        query.findObjectsInBackgroundWithBlock { (results : [AnyObject]?, error: NSError?) -> Void in
            
            if error != nil {
                
                print("1Connections VC \(error)")
                
            } else if let results = results {
                
                for result in results as! [PFUser] {
                    
                    self.objectId.append(result.objectId!)
                    self.names.append(result["name"] as! String)
                    self.emails.append(result.email!)
//                    self.facebookIds.append(result["facebookId"] as! String)
                    
                    let imageFile = result["image"] as! PFFile
                    
                    imageFile.getDataInBackgroundWithBlock({ (imageData : NSData?, error : NSError?) -> Void in
                        
                        if error != nil {
                            
                            print("Connections VC \(error)")
                            
                        } else if let data = imageData {
                            
                            let name = result["name"] as! String
                            
                            self.images[name] = (UIImage(data: data)!)
                            self.tableView.reloadData()
                            
                        }
                        
                    })
                    
                }
                
                self.tableView.reloadData()
                
            }
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return names.count
    }


    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        
        if images.count > indexPath.row {
            
            let connectionName = (cell.textLabel?.text)!
        
            cell.imageView?.image = images[connectionName]
            
            let itemSize = CGSizeMake(40, 40)
            UIGraphicsBeginImageContextWithOptions(itemSize, false, UIScreen.mainScreen().scale)
            let imageRect : CGRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height)
            
            cell.imageView?.image?.drawInRect(imageRect)
            cell.imageView?.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
        }
        
        cell.textLabel?.text = names[indexPath.row]

        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
//            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
            var indexOfDeletedUser = 0
            if let _ = currentUserAccepted.indexOf(objectId[indexPath.row]) {
                
                indexOfDeletedUser = currentUserAccepted.indexOf(objectId[indexPath.row])!
                
            }
            
//            print(currentUserAccepted[indexOfDeletedUser])
            
            print(currentUserAccepted)
            
            currentUserAccepted.removeAtIndex(indexOfDeletedUser)
            
            print(currentUserAccepted)
            
            PFUser.currentUser()?["accepted"] = currentUserAccepted
            PFUser.currentUser()?.save()
            
            let connectionName = (tableView.cellForRowAtIndexPath(indexPath)?.textLabel?.text)!
            print(connectionName)
            
            names.removeAtIndex(indexPath.row)
            emails.removeAtIndex(indexPath.row)
            images.removeValueForKey(connectionName)
            
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
            
            
            
            
        }
    }


    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
//        let url = NSURL(string: "mailto:" + emails[indexPath.row])
//        
//        UIApplication.sharedApplication().openURL(url!)
        
//        NSURL *fbURL = [NSURL URLWithString:@"fb-messenger://user-thread/USER_ID"];
//        if ([[UIApplication sharedApplication] canOpenURL: fbURL]) {
//            [[UIApplication sharedApplication] openURL: fbURL];
//        }
//        let fbURL = NSURL(string: "https://facebook.com/messages/nichell.logue")
//        let fbURL = NSURL(string: "fb-messenger://user-thread/\(facebookIds[indexPath.row])")
        let fbURL = NSURL(string: "fb-messenger://user-thread/nichell.logue")
//        let fbURL = NSURL(string: "fb-messenger://user-thread/app_scoped_user_id/1669812473289084/")
        if UIApplication.sharedApplication().canOpenURL(fbURL!) {
            UIApplication.sharedApplication().openURL(fbURL!)
        }
        
//        [FBSDKMessengerSharer openMessenger];
        
//        FBSDKMessengerSharer.openMessenger()
        
//        FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
//        content.contentURL = [NSURL URLWithString:@"https://developers.facebook.com"];
        
//        let content : FBSDKShareLinkContent = FBSDKShareLinkContent()
//        content.contentURL = NSURL(string: "http://mywebnapp.com")
//        
//        FBSDKSendButton *button = [[FBSDKSendButton alloc] init];
//        button.shareContent = content;
//        [self.view addSubview:button];

//        let button : FBSDKSendButton = FBSDKSendButton()
//        button.shareContent = content
//        
//        var buttonX : CGFloat = (self.view.bounds.width / 2) - (button.frame.width / 2)
//        var buttonY : CGFloat = (self.view.bounds.height) - (button.frame.height + 30)
//        
//        button.frame = CGRectMake(buttonX, buttonY, button.frame.width, button.frame.height)
        
//        if (button.isHidden) {
//            NSLog(@"Is hidden");
//        } else {
//            [self.view addSubview:button];
//        }
//        
//        if button.hidden {
//            print("button Hidden")
//        } else {
//            self.view.addSubview(button)
//        }
//        [FBSDKMessageDialog showWithContent:content delegate:nil];
//        FBSDKMessageDialog.showWithContent(content, delegate: nil)
        
    }

}
