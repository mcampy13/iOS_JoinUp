//
//  Friend.swift
//  SalesGame_swift
//
<<<<<<< HEAD
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
=======
//  Created by Robert Rock on 12/21/15.
//  Copyright © 2015 Akshay. All rights reserved.
//

import Foundation

class Friend {
    var name: String
    
    init(name: String) {
        self.name = name
    }
}
>>>>>>> d6e906b4510cf39f9ffcbdd178848ad1fce0298e
