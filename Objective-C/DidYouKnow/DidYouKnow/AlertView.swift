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
    
    func alert(alertTitle alertTitle: String, alertMessage: String) -> UIAlertController {
        
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .Alert)
        
        let okButton = UIAlertAction(title: "OK", style: .Default) { (_) -> Void in
        
            let topViewController = UIApplication.sharedApplication().keyWindow?.rootViewController
            
            topViewController?.dismissViewControllerAnimated(true, completion: nil)
        
        }
        
        alertController.addAction(okButton)
        
        return alertController
        
    }
    
    
    func settingsAlert(alertTitle alertTitle: String, alertMessage: String) -> UIAlertController {
        
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .Alert)
        
        let okButton = UIAlertAction(title: "OK", style: .Default, handler: nil)
        
        let settingsButton = UIAlertAction(title: "Settings", style: .Default) { (_) -> Void in
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