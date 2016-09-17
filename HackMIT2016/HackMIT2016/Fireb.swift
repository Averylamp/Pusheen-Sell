//
//  Fireb.swift
//  HackMIT2016
//
//  Created by Atman Patel on 18/09/16.
//  Copyright © 2016 Nathan Gitter. All rights reserved.
//

import UIKit
import Firebase

class Fireb: NSObject {

    static func save(childUrl : String){
        Fireba.rootRef.child(childUrl).setValue(["username": "hackmit"])
    }
    
    
    static func addItem(withTitle title: String, desciption desc : String, Price price:String, Count count : String){
        Fireba.rootRef.child("Items").child(count).setValue(["title" : title, "description" : desc,"price" : price])
    }
    
    static func getAllitem(childUrl : String){
        Fireba.rootRef.child("Items").observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot.childrenCount)
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? FIRDataSnapshot {
                print(rest.value)
            }
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    static func childAdded(){
        Fireba.rootRef.observe(.childAdded, with: { (snapshot) -> Void in
            
        })
    }
    
}
