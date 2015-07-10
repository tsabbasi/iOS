//
//  RandomGeneratorSwift.swift
//  DidYouKnow
//
//  Created by Taha Abbasi on 6/25/15.
//  Copyright (c) 2015 TahaAbbasi. All rights reserved.
//

import Foundation

@objc
class RandomGenerator: NSObject {
    
    var previousRandomNumberArray = [Int]()
    var random = 0
    
    func getRandomObjectFromArray(dictionary: NSMutableDictionary, completionDialogTitle: NSString, completionDialogMessage: NSString) -> AnyObject {
        
        if (previousRandomNumberArray.count == dictionary.count) {
            let alert = AlertView()
            let alertController : UIAlertController = alert.alert(alertTitle: completionDialogTitle as String, alertMessage: completionDialogMessage as String)
            previousRandomNumberArray.removeAll(keepCapacity: false)
            
            var topViewController = UIApplication.sharedApplication().keyWindow?.rootViewController
            
            topViewController?.presentViewController(alertController, animated: true, completion: nil)
            
        }
        
        
        random = Int(arc4random_uniform(UInt32(dictionary.count)))
        
        while (contains(previousRandomNumberArray, random)) {
            random = Int(arc4random_uniform(UInt32(dictionary.count)))
        }
        
        previousRandomNumberArray.append(random)
        
        if let dictionaryObject : AnyObject = dictionary["\(random)"] {
            return dictionaryObject
        } else {
         
            let alert = AlertView()
            let alertController : UIAlertController = alert.alert(alertTitle: "Ooops!", alertMessage: "Looks like someone messed up our facts file. Don't worry We'll fix it right away. If this issue continues, please contact tahaabbasi@me.com")
            previousRandomNumberArray.removeAll(keepCapacity: false)
            
            var topViewController = UIApplication.sharedApplication().keyWindow?.rootViewController
            
            topViewController?.presentViewController(alertController, animated: true, completion: nil)
            
            return ""
            
        }
    }
    
    
    func getRandomObjectFromArray(dictionary: NSMutableDictionary, completionDialogTitle: NSString, completionDialogMessage: NSString, viewController : UIViewController) -> AnyObject {
        
        if (previousRandomNumberArray.count == dictionary.count) {
            let alert = AlertView()
            let alertController : UIAlertController = alert.alert(alertTitle: completionDialogTitle as String, alertMessage: completionDialogMessage as String)
            previousRandomNumberArray.removeAll(keepCapacity: false)
            
            viewController.presentViewController(alertController, animated: true, completion: nil)
            
            
        }
        
        
        random = Int(arc4random_uniform(UInt32(dictionary.count)))
        
        while (contains(previousRandomNumberArray, random)) {
            random = Int(arc4random_uniform(UInt32(dictionary.count)))
        }
        
        previousRandomNumberArray.append(random)
        
        if let dictionaryObject : AnyObject = dictionary["\(random)"] {
            return dictionaryObject
        } else {
            
            let alert = AlertView()
            let alertController : UIAlertController = alert.alert(alertTitle: "Ooops!", alertMessage: "Looks like someone messed up our facts file. Don't worry We'll fix it right away. If this issue continues, please contact tahaabbasi@me.com")
            previousRandomNumberArray.removeAll(keepCapacity: false)
            
            viewController.presentViewController(alertController, animated: true, completion: nil)
            
            return "Ooops! Looks like someone messed up our facts file. Don't worry We'll fix it right away. If this issue continues, please contact tahaabbasi@me.com"
            
        }
    }
    
    func getRandomObjectFromArray(objectArray: [UIColor]) -> UIColor {
        
        if (previousRandomNumberArray.count == objectArray.count) {
            previousRandomNumberArray.removeAll(keepCapacity: false)
        }
        
        random = Int(arc4random_uniform(UInt32(objectArray.count)))
        
        while (contains(previousRandomNumberArray, random)) {
            random = Int(arc4random_uniform(UInt32(objectArray.count)))
        }
        
        previousRandomNumberArray.append(random)
        
        return objectArray[random]
        
    }
}