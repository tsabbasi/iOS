//
//  ViewController.swift
//  Meet A Muslim
//
//  Created by Taha Abbasi on 1/26/16.
//  Copyright © 2016 TahaAbbasi. All rights reserved.
//

import UIKit
import Parse
import FBSDKCoreKit



class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if let username = PFUser.currentUser()?.username {
            
            if let meetAMuslim = PFUser.currentUser()?["meetAMuslim"] {
                
                self.performSegueWithIdentifier("logInSegue", sender: self)
                
            } else {
                
                self.performSegueWithIdentifier("signUpSegue", sender: self)
                
            }
            
        } else {
            
            let image = UIImage(named: "minion-muslim.png")
            let imageView = UIImageView(image: image)
            
            let width = (self.view.bounds.width / 3) + ((self.view.bounds.width / 3) / 2)
            let height = (self.view.bounds.height / 4) + (self.view.bounds.height / 4) / 2
            
            let xOffset = self.view.bounds.width / 4
            let yOffset = (self.view.bounds.height - ((self.view.bounds.height / 4) * 3)) / 4
            
            imageView.frame = CGRectMake(xOffset, yOffset,
                width,
                height)
            
            imageView.backgroundColor = UIColor.whiteColor()
            view.addSubview(imageView)
            
            let wrapperView = UIView()
            
            let wrapperOffsetX = (self.view.bounds.width * (20/100)) / 2
            let wrapperOffsetY = imageView.frame.height + yOffset + 20
            let wrapperWidth = self.view.bounds.width * (80/100)
            var wrapperHeight = imageView.frame.height
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
            titleLabel.text = "Welcome! Salam!"
            titleLabel.font = UIFont(name: "Helvetica Neue", size: 28)
            
            
            let messageLabelOffsetX : CGFloat = (wrapperView.bounds.width - wrapperView.bounds.width * (80/100)) / 2
            let messageLabelOffsetY : CGFloat = titleLabelOffsetY + titleLabelHeight + 8
            
            let messageLabelWidth : CGFloat = wrapperView.bounds.width * (80/100)
            let messageLabelHeight : CGFloat = wrapperHeight - titleLabelHeight - messageLabelOffsetY - 10
            
            let messageLabel = UILabel(frame: CGRectMake(messageLabelOffsetX, messageLabelOffsetY, messageLabelWidth, messageLabelHeight))
            
            messageLabel.textAlignment = NSTextAlignment.Center
            messageLabel.textColor = UIColor.whiteColor()
            messageLabel.numberOfLines = 0
            messageLabel.text = "We want to show the world what muslims living around you are really like.\n\nSign up and you'll get a chance to talk and meet with muslims around you."
            messageLabel.font = UIFont(name: "Helvetica Neue", size: 17)
            
            if wrapperWidth < 300.0 {
                messageLabel.adjustsFontSizeToFitWidth = true
            }
            
            wrapperHeight = messageLabelOffsetY + messageLabelHeight + 20
//            
//            print("message: \(wrapperWidth)")
//            print("message: \(messageLabelHeight)")
            
            wrapperView.frame = CGRectMake(wrapperOffsetX, wrapperOffsetY, wrapperWidth, wrapperHeight)
            
            let loginButton = UIButton()
            loginButton.setImage(UIImage(named: "facebookLoginButton"), forState: .Normal)
            
            let loginButtonWidth : CGFloat = wrapperWidth * (70/100)
            let loginButtonHeight : CGFloat = loginButtonWidth / 5.12
            let loginOffsetX : CGFloat = (self.view.bounds.width / 2) - (loginButtonWidth / 2)
            let loginOffsetY : CGFloat = wrapperOffsetY + wrapperHeight + 20
            
            
            loginButton.frame = CGRectMake(loginOffsetX, loginOffsetY, loginButtonWidth, loginButtonHeight)
            
            loginButton.addTarget(self, action: "signInUp", forControlEvents:.TouchUpInside)
            
            
            self.view.addSubview(loginButton)
            wrapperView.addSubview(titleLabel)
            wrapperView.addSubview(messageLabel)
            self.view.addSubview(wrapperView)
            
            
            
        }
    }
    
    func signInUp() {
        
        // Log in
        let permissions = ["public_profile", "email"]
        
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions) { (user : PFUser?, error : NSError?) -> Void in
            
            if let error = error {
                
                print(error)
                
            } else {
                
                if let user = user {
                    
                    if let meetAMuslim = user["meetAMuslim"] {
                        
                        self.performSegueWithIdentifier("logInSegue", sender: self)
                        
                    } else {
                        
                        self.performSegueWithIdentifier("signUpSegue", sender: self)
                        
                    }
                    
                }
                
            }
            
        }

    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}