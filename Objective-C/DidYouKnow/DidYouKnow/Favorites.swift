//
//  Favorites.swift
//  DidYouKnow
//
//  Created by Taha Abbasi on 1/22/16.
//  Copyright © 2016 TahaAbbasi. All rights reserved.
//

import Foundation

// MARK: Properties

struct FactsKey {
    static let favoriteFactsKey = "favoriteFacts"
}

class Favorites: NSObject, NSCoding {
    
    var favoriteFacts = Array<String>()
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("storedFacts")

    
    
    init?(favoriteFacts: Array<String>) {
        // Initialize stored properties.
        self.favoriteFacts = favoriteFacts
       
        
        super.init()
        
        // Initialization should fail if there is no name or if the rating is negative.
        if favoriteFacts.count == 0 {
            return nil
        }
    }
    
    // MARK: NSCoding
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.favoriteFacts, forKey: FactsKey.favoriteFactsKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        let favoriteFacts = aDecoder.decodeObjectForKey(FactsKey.favoriteFactsKey) as! Array<String>
        
        
        self.init(favoriteFacts: favoriteFacts)
        
    }

    
}