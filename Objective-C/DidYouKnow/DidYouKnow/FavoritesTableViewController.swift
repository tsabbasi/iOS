//
//  FavoritesTableViewController.swift
//  DidYouKnow
//
//  Created by Taha Abbasi on 1/21/16.
//  Copyright © 2016 TahaAbbasi. All rights reserved.
//

import UIKit

class FavoritesTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var factBook : FactBookSwift = FactBookSwift()
    var favoriteFacts = Array<String>()
    
    @IBOutlet var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        table.estimatedRowHeight = 44.0
        table.rowHeight = UITableViewAutomaticDimension
        
//        self.table.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        if let storedFacts = factBook.loadStoredFacts() {
            
            favoriteFacts = storedFacts
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func toasting(title: String, message: String, duration: NSTimeInterval, imageName: String) {
        
        self.view.makeToast(message, duration: duration, position: .Bottom, title: title, image: UIImage(named: imageName), style:nil) { (didTap: Bool) -> Void in
            if didTap {
                //                print("completion from tap")
            } else {
                //                print("completion without tap")
            }
            
        }
    }
    
    // MARK: Segues
    
    @IBAction func goHome(sender: AnyObject) {
        
        let topviewController = UIApplication.sharedApplication().keyWindow?.rootViewController
        
        topviewController?.dismissViewControllerAnimated(true, completion: nil)
        
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return favoriteFacts.count
    }


    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! FavoriteCell
        
        

        cell.backgroundColor = UIColor(red: 90/255.0, green: 187/255.0, blue: 181/255.0, alpha: 1.0)
        cell.favoriteLabel.textColor = UIColor.whiteColor()
        cell.favoriteLabel?.font = UIFont(name: "Lato", size: 22)
        cell.favoriteLabel?.text = favoriteFacts[indexPath.row]
        cell.favoriteLabel?.numberOfLines = 0
        

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        selectedCell.contentView.backgroundColor = UIColor(red: 66/255.0, green: 139/255.0, blue: 135/255.0, alpha: 0.9)

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
            
            favoriteFacts.removeAtIndex(indexPath.row)
            let deleteFavoriteResult = factBook.updateFacts(favoriteFacts)
            
            switch deleteFavoriteResult {
            case "Deleted":
                toasting("Deleted!", message: "You can always add the fact back to your favorites by clicking the Star Icon in each fact category view.", duration: 5.0, imageName: "minion-success.png")
                
            case "Failed To Save":
                toasting("Oh No!", message: "Looks like someone's been sleeping on the job...We couldn't save your fact. Please try again.", duration: 3.0, imageName: "minion-fail.png")
                
            default:
                toasting("Umm..", message: "Something went wrong, lets try that again", duration: 3.0, imageName: "minion-fail.png")
            }
        }
        
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    }


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
