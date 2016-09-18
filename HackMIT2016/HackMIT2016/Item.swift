//
//  Item.swift
//  HackMIT2016
//
//  Created by Nathan Gitter on 9/17/16.
//  Copyright © 2016 Nathan Gitter. All rights reserved.
//

import Foundation

/// An Item that a user can sell, browse, or purchase.
public struct Item {
    
    /// The name of the item.
    public var name: String
    
    /// A paragraph description of the item.
    public var description: String
    
    /// The price of the item
    public var price : String
    
    /// The price of the item
    public var key : String

    
    public init(dic : [String : String]){
        if let name = dic["title"]{
            self.name = name
        }else{
            self.name = ""
        }
        
        if let description = dic["description"]{
            self.description = description
        }else{
            self.description = ""
        }
        
        if let price = dic["price"]{
            self.price = price
        }else{
            self.price = ""
        }
        
        if let key = dic["key"]{
            self.key = key
        }else{
            self.key = ""
        }
        
    }
}
