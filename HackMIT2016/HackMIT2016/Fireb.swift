//
//  Fireb.swift
//  HackMIT2016
//
//  Created by Atman Patel on 18/09/16.
//  Copyright © 2016 Nathan Gitter. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class Fireb: NSObject {

    static func save(childUrl : String){
        Fireba.rootRef.child(childUrl).setValue(["username": "hackmit"])
    }
    
    
    static func addItem(withTitle title: String, desciption desc : String, Price price:String, Count count : String){
        Fireba.rootRef.child("Items").childByAutoId().setValue(["title" : title, "description" : desc,"price" : price])
    }
    
    static func getAllitem(callback: @escaping ([Item]) -> Void){
        Fireba.rootRef.child("Items").observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot.childrenCount)
            var Items : [Item] = [Item]()
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? FIRDataSnapshot {
                print(rest.value)
                let item : [String : String] = ["title" : (rest.childSnapshot(forPath: "title").value as? String)!,
                                                "description" : (rest.childSnapshot(forPath: "description").value as? String)!,
                                                "price" : (rest.childSnapshot(forPath: "price").value as? String)!]
                Items.append(Item.init(dic: item))
                callback(Items)
            }
            print(Items)
        }) { (error) in
            print(error.localizedDescription)
            callback([])
        }
        
    }
    
    static func childAdded(){
        Fireba.rootRef.observe(.childAdded, with: { (snapshot) -> Void in
            
        })
    }
    
    static func uploadFileToServer(fileName : String, data : NSData){
        let storage = FIRStorage.storage()
        // Create a storage reference from our storage service
        let storageRef = storage.reference(forURL: "gs://hackmit2016-31521.appspot.com")
        // Create a reference to "mountains.jpg"
        let mountainsRef = storageRef.child(fileName + ".jpg")
        let uploadTask = mountainsRef.put(data as Data, metadata: nil) { metadata, error in
            if (error != nil) {
                // Uh-oh, an error occurred!
            } else {
                // Metadata contains file metadata such as size, content-type, and download URL.
                let downloadURL = metadata!.downloadURL
            }
        }
        

    }
    
    static func downloadFileFromServer(fileName : String){
        let storage = FIRStorage.storage()
        // Create a storage reference from our storage service
        let storageRef = storage.reference(forURL: "gs://hackmit2016-31521.appspot.com")
        // Create a reference to "mountains.jpg"
        let mountainsRef = storageRef.child(fileName + ".jpg")
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        mountainsRef.data(withMaxSize: 10 * 1024 * 1024) { (data, error) -> Void in
            if (error != nil) {
                // Uh-oh, an error occurred!
            } else {
                // Data for "images/island.jpg" is returned
                // ... let islandImage: UIImage! = UIImage(data: data!)
            }
        }
    }
    
}
