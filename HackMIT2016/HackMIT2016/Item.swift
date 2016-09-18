//
//  Item.swift
//  HackMIT2016
//
//  Created by Nathan Gitter on 9/17/16.
//  Copyright © 2016 Nathan Gitter. All rights reserved.
//

import Foundation

/// An Item that a user can sell, browse, or purchase.
struct Item {
    
    /// The name of the item.
    var name: String
    
    /// A paragraph description of the item.
    var description: String
    
    /// The price of the item
    var price : String
    
    /// The seller id
    var sellerId : String
    
}
