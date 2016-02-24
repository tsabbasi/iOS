//
//  SignUpViewController.swift
//  Meet A Muslim
//
//  Created by Taha Abbasi on 1/26/16.
//  Copyright © 2016 TahaAbbasi. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController {

    
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var meetAMuslim: UISwitch!
    
    @IBOutlet var signUpButton: UIImageView!
    func signUpComplete(sender : AnyObject) {
        
        var isMuslim = true
        
        if meetAMuslim.on == true {
            
            isMuslim = false
            
        }
        
        PFUser.currentUser()?["meetAMuslim"] = meetAMuslim.on
        PFUser.currentUser()?["isMuslim"] = isMuslim
        

        PFUser.currentUser()?.save()

        
        print(meetAMuslim)
        
        self.performSegueWithIdentifier("signUpCompleteSegue", sender: self)
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let gesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("signUpComplete:"))
        signUpButton.addGestureRecognizer(gesture)

        // Getting users information from facebook
        // Graph request is what is used to get information from a facebook Graph which has users informaiton. This can only be done for a user that is logged in using facebook on our app.
        
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, gender, email, link"])
        graphRequest.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
            
            if error != nil {
                
                print(error)
                
            } else if let result = result {
                
                print(result)
                
                
                
                PFUser.currentUser()?["gender"] = result["gender"]
                PFUser.currentUser()?["name"] = result["name"]
                PFUser.currentUser()?["email"] = result["email"]
                PFUser.currentUser()?["facebookId"] = result["id"] as! String
                

                PFUser.currentUser()?.save()
                
                
                
                let userID = result["id"] as! String
                
                let facebookProfilePictureUrl = "https://graph.facebook.com/" + userID + "/picture?type=large"
                
                if let fbpicUrl = NSURL(string: facebookProfilePictureUrl) {
                    
                    if let data = NSData(contentsOfURL: fbpicUrl) {
                        
                        self.userImage.image = UIImage(data: data)
                        
                        let imageFile : PFFile = PFFile(data: data)
                        
                        PFUser.currentUser()?["image"] = imageFile
                        
                        
                        PFUser.currentUser()?.save()
                        
                        
                    }
                    
                }
                
            }
        }
    }
    
}
