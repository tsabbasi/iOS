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
            let alert = Alert()
            alert.alertTitle(completionDialogTitle as String, alertMessage: completionDialogMessage as String)
            previousRandomNumberArray.removeAll(keepCapacity: false)
        }
        
        
        random = Int(arc4random_uniform(UInt32(dictionary.count)))
        
        while (contains(previousRandomNumberArray, random)) {
            random = Int(arc4random_uniform(UInt32(dictionary.count)))
        }
        
        previousRandomNumberArray.append(random)
        
        return dictionary["\(random)"]!
    }
    
    
    func getRandomObjectFromArray(objectArray: NSMutableArray) -> AnyObject {
        
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