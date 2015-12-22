//
//  Friend.swift
//  SalesGame_swift
//
//  Created by Robert Rock on 11/28/15.
//  Copyright © 2015 Akshay. All rights reserved.
//

import UIKit

class Friend {
    
    // MARK - Properties
    
    var name: String
    var username: String
    var level: Int
    var photo: UIImage?
    
    
    // MARK - Initialization
    
    init?(name: String, username: String, level: Int, photo: UIImage){
        self.name = name
        self.username = username
        self.level = level
        self.photo = photo
        
        if name.isEmpty || username.isEmpty || level < 0 {
            return nil
        }
        
    }
    
}
