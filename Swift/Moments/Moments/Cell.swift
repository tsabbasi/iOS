//
//  Cell.swift
//  Moments
//
//  Created by Taha Abbasi on 10/29/15.
//  Copyright © 2015 TahaAbbasi. All rights reserved.
//

import UIKit

class Cell: UITableViewCell {
    
    
    //MARK: - Feed Cell Info
    
    /* 
    
    This class is designed to control the Image, the username and the message field in the prototype cell of the Your Feed View controller. Because there will be an unknown amount of cells, and each cell will have a different set of data, we cannot do this through traditional outlet methods, hence we created a class to tackle it.
    
    */
    
    //MARK: -

    //MARK: - Outlets
    
    @IBOutlet var postedImage: UIImageView!
    @IBOutlet var username: UILabel!
    @IBOutlet var message: UILabel!
    

}
