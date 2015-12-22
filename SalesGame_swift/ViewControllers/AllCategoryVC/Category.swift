//
//  Category.swift
//  SalesGame_swift
//
//  Created by Robert Rock on 12/13/15.
//  Copyright © 2015 Akshay. All rights reserved.
//

import Foundation
import Parse

class Category: PFObject, PFSubclassing {
        
    override class func initialize() {
        self.registerSubclass()
    }
    
    static func parseClassName() -> String {
        return "Category"
    }
    
    @NSManaged var categoryName: String?
    @NSManaged var categoryFile: PFFile?
    
    
}

