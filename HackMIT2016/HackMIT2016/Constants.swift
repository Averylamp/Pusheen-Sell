//
//  Constants.swift
//  HackMIT2016
//
//  Created by Atman Patel on 18/09/16.
//  Copyright © 2016 Nathan Gitter. All rights reserved.
//

import UIKit
import FirebaseDatabase

struct Constants{
    var serverUrl : String = "https://hackmit2016-31521.firebaseio.com/"
}

struct Fireba{
    static let rootRef = FIRDatabase.database().reference()
    
}

struct Color {
    
    static let pink = UIColor(hex: 0xffb0cd)
    static let green = UIColor(hex: 0xb8efe3)
    static let yellow = UIColor(hex: 0xfcf0e4)
    static let lightBrown = UIColor(hex: 0xb4a89c)
    static let darkBrown = UIColor(hex: 0x4a280c)
    
}

extension UIColor {
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        let r = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((hex & 0xFF00) >> 8) / 255.0
        let b = CGFloat((hex & 0xFF)) / 255.0
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
}
