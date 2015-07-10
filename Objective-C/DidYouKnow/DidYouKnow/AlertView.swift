//
//  AlertView.swift
//  DidYouKnow
//
//  Created by Taha Abbasi on 6/25/15.
//  Copyright (c) 2015 TahaAbbasi. All rights reserved.
//

import Foundation

@objc
class AlertView: UIAlertView {
    
    func alert(#alertTitle: String, alertMessage: String) -> UIAlertController {
        
        var alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .Alert)
        
        var okButton = UIAlertAction(title: "OK", style: .Default) { (_) -> Void in
        
            let topViewController = UIApplication.sharedApplication().keyWindow?.rootViewController
            
            topViewController?.dismissViewControllerAnimated(true, completion: nil)
        
        }
        
        alertController.addAction(okButton)
        
        return alertController
        
    }
    
    
    func settingsAlert(#alertTitle: String, alertMessage: String) -> UIAlertController {
        
        var alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .Alert)
        
        var okButton = UIAlertAction(title: "OK", style: .Default, handler: nil)
        
        var settingsButton = UIAlertAction(title: "Settings", style: .Default) { (_) -> Void in
            let settingsUrl = NSURL(string: UIApplicationOpenSettingsURLString)
            if let url = settingsUrl {
                UIApplication.sharedApplication().openURL(url)
            }
        }
        
        alertController.addAction(okButton)
        alertController.addAction(settingsButton)
        
        return alertController
        
    }
    
}