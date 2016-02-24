//
//  SwipingViewController.swift
//  Meet A Muslim
//
//  Created by Taha Abbasi on 1/27/16.
//  Copyright © 2016 TahaAbbasi. All rights reserved.
//

import UIKit
import Parse

class SwipingViewController: UIViewController {

    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var swipeLabel: UILabel!
    
    @IBAction func logOut(sender: AnyObject) {
        
        PFUser.logOut()
        self.performSegueWithIdentifier("logoutSegue", sender: self)
        
        
    }
    
    // MARK:- Accepting or Rejecting User Logic
    
    var displayedUserId = ""
    let wrapperView = UIView()
    let errorImage = UIImageView()
    
    
    func wasDragged(gesture: UIPanGestureRecognizer) {
        
        // Translation is the chagne in position from the origing, it's just a math term nothing else
        let translation = gesture.translationInView(self.view)
        let image = gesture.view!
        
        image.center = CGPoint(x: (self.view.bounds.width / 2) + translation.x, y: (self.view.bounds.height / 2) + translation.y)
        
        let xFromCenter = image.center.x - self.view.bounds.width / 2
        
        let scale = min(100 / abs(xFromCenter), 1)
        
        var rotation = CGAffineTransformMakeRotation(xFromCenter / 200)
        
        var stretch = CGAffineTransformScale(rotation, scale, scale)
        
        image.transform = stretch
        
        if gesture.state == UIGestureRecognizerState.Ended {
            
            var acceptedOrRejected = ""
            
            if image.center.x < 100 {
                
                acceptedOrRejected = "rejected"
                
            } else if image.center.x > self.view.bounds.width - 100 {
                
                acceptedOrRejected = "accepted"
                
            }
            
            if acceptedOrRejected != "" {
                
                PFUser.currentUser()?.addUniqueObjectsFromArray([displayedUserId], forKey: acceptedOrRejected)
                
                PFUser.currentUser()?.save()
                
            }
            
            rotation = CGAffineTransformMakeRotation(0)
            
            stretch = CGAffineTransformScale(rotation, 1, 1)
            
            image.transform = stretch
            
            image.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)
            
            updateImage()
            
        }
        
    }
    
    // MARK:- Locating Nearby users and updating image
    
    func updateImage() {
        
        wrapperView.hidden = true
        errorImage.hidden = true
        
        let query = PFUser.query()!
        
        if let latitude = PFUser.currentUser()?["location"]?.latitude {
            
            if let longitude = PFUser.currentUser()?["location"]?.longitude {
                
                query.whereKey("location", withinGeoBoxFromSouthwest: PFGeoPoint(latitude: latitude - 50, longitude: longitude - 50), toNortheast: PFGeoPoint(latitude: latitude + 50, longitude: longitude + 50))
                
            }
        }
        
        var meetAMuslim = true
        var isMuslim = true
        
        if PFUser.currentUser()!["isMuslim"]! as! Bool == true {
            
            isMuslim = false
            
        }
        
        
        
        if PFUser.currentUser()!["meetAMuslim"]! as! Bool == true {
            
            meetAMuslim = false
            
            
        }
        
        query.whereKey("isMuslim", equalTo: isMuslim)
        query.whereKey("meetAMuslim", equalTo: meetAMuslim)
        
        
        var ignoredUsers = [(PFUser.currentUser()?.objectId)!]
        
        
        if let acceptedUsers = PFUser.currentUser()?["accepted"] {
            
            ignoredUsers += acceptedUsers as! Array
            
        }
        
        if let rejectedUsers = PFUser.currentUser()?["rejected"] {
            
            ignoredUsers += rejectedUsers as! Array
            
        }
        
//        print(ignoredUsers)
        
        query.whereKey("objectId", notContainedIn: ignoredUsers)
        
        query.limit = 1
        
        query.findObjectsInBackgroundWithBlock({ (objects : [AnyObject]?, error : NSError?) -> Void in
            
            if objects?.count == 0 {
                
                self.wrapper()
                
            }
            
            if error != nil {
                
                print("Swiping VC \(error)")
                
            } else if let objects = objects as? [PFObject] {
                
                for object in objects {
                    
                    self.displayedUserId = object.objectId!
                    
                    let imageFile = object["image"] as! PFFile
                    
                    imageFile.getDataInBackgroundWithBlock({ (imageData : NSData?, error : NSError?) -> Void in
                        
                        if error != nil {
                            
                            print("Swiping VC \(error)")
                            
                        } else if let data = imageData {
                            
                            self.userImage.hidden = false
                            self.swipeLabel.hidden = false
                            self.userImage.image = UIImage(data: data)
                            
                            
                        }
                        
                    })
                    
                }
                
            }
            
        })
        
        
    }
    
    // MARK:- Wrapper
    
    func wrapper() {
        
        swipeLabel.hidden = true
        
        self.userImage.hidden = true
        
        wrapperView.hidden = false
        
        errorImage.hidden = false
        
        errorImage.image = UIImage(named: "minion-butt")
        
        errorImage.contentMode = UIViewContentMode.ScaleAspectFit
        
        
        
//        let width = (self.view.bounds.width / 3) + ((self.view.bounds.width / 3) / 2)
//        let height = (self.view.bounds.height / 4) + (self.view.bounds.height / 4) / 2
        
        var width : CGFloat = 300.0
        var height : CGFloat = 300.0
        
        if self.view.frame.width < 400.0 {
            width = 200.0
            height = 200.0
        }
        let statusBarOffset = navBar.center.y - (navBar.frame.height / 2)
        
        let xOffset = (self.view.bounds.width - width) / 2
        let yOffset = navBar.frame.height + +statusBarOffset + 10
        
//        print("width: \(self.view.bounds.width)\nheight: \(height)\nxOffset: \(xOffset)\nyOffst: \(yOffset)")
        
        errorImage.frame = CGRectMake(xOffset, yOffset,
            width,
            height)
        
        errorImage.backgroundColor = UIColor.whiteColor()
        view.addSubview(errorImage)
        
        
        let wrapperOffsetX = (self.view.bounds.width * (20/100)) / 2
        let wrapperOffsetY = errorImage.frame.height + yOffset + 20
        let wrapperWidth = self.view.bounds.width * (80/100)
        var wrapperHeight = errorImage.frame.height
        let wrapperCornerRadius : CGFloat = 10.0
        
        wrapperView.frame = CGRectMake(wrapperOffsetX, wrapperOffsetY, wrapperWidth, wrapperHeight)
        
        wrapperView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.7)
        wrapperView.layer.cornerRadius = wrapperCornerRadius
        
        let titleLabelOffsetX : CGFloat = 0.0
        let titleLabelOffsetY : CGFloat = 8.0
        
        let titleLabelWidth : CGFloat = wrapperView.bounds.width
        let titleLabelHeight : CGFloat = 38.0
        
        let titleLabel = UILabel(frame: CGRectMake(titleLabelOffsetX, titleLabelOffsetY, titleLabelWidth, titleLabelHeight))
        
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.text = "Whoa! #Haram"
        titleLabel.font = UIFont(name: "Helvetica Neue", size: 28)
        
        
        let messageLabelOffsetX : CGFloat = (wrapperView.bounds.width - wrapperView.bounds.width * (80/100)) / 2
        let messageLabelOffsetY : CGFloat = titleLabelOffsetY + titleLabelHeight + 8
        
        let messageLabelWidth : CGFloat = wrapperView.bounds.width * (80/100)
        let messageLabelHeight : CGFloat = wrapperHeight - titleLabelHeight - messageLabelOffsetY - 10
        
        let messageLabel = UILabel(frame: CGRectMake(messageLabelOffsetX, messageLabelOffsetY, messageLabelWidth, messageLabelHeight))
        
        messageLabel.textAlignment = NSTextAlignment.Center
        messageLabel.textColor = UIColor.whiteColor()
        messageLabel.numberOfLines = 0
        messageLabel.text = "Looks like we've run out of matches for you.\n\nTake a look in the Connections to tab to connect with the people you have been matched with."
        messageLabel.font = UIFont(name: "Helvetica Neue", size: 17)
        
        if wrapperWidth < 400.0 {
            titleLabel.adjustsFontSizeToFitWidth = true
            messageLabel.adjustsFontSizeToFitWidth = true
        }
        
        wrapperHeight = min((messageLabelOffsetY + messageLabelHeight + 20), errorImage.frame.height)
        
        wrapperView.frame = CGRectMake(wrapperOffsetX, wrapperOffsetY, wrapperWidth, wrapperHeight)
        
        
        wrapperView.addSubview(titleLabel)
        wrapperView.addSubview(messageLabel)
        self.view.addSubview(wrapperView)

        
    }
    
    // MARK:-
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        let gesture = UIPanGestureRecognizer(target: self, action: Selector("wasDragged:"))
        userImage.addGestureRecognizer(gesture)
        
        userImage.userInteractionEnabled = true
        
        PFGeoPoint.geoPointForCurrentLocationInBackground { (geoPoint : PFGeoPoint?, error : NSError?) -> Void in
            
            if let geoPoint = geoPoint {
                
                PFUser.currentUser()?["location"] = geoPoint
                PFUser.currentUser()?.save()
                
            }
            
        }
        
        updateImage()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func toasting(title: String, message: String, duration: NSTimeInterval, imageName: String) {
        
        self.view.makeToast(message, duration: duration, position: .Center, title: title, image: UIImage(named: imageName), style:nil) { (didTap: Bool) -> Void in
            if didTap {
                //                print("completion from tap")
            } else {
                //                print("completion without tap")
            }
            
        }
    }
    

    
}
