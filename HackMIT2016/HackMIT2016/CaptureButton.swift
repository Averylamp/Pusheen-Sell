//
//  CaptureButton.swift
//  HackMIT2016
//
//  Created by Nathan Gitter on 9/17/16.
//  Copyright © 2016 Nathan Gitter. All rights reserved.
//

import UIKit

class CaptureButton: UIButton {
    
    private var icon: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    func setup() {
        
        self.backgroundColor = UIColor.red
        
        self.icon = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        self.icon.backgroundColor = UIColor.blue
        self.icon.center = self.center
        self.icon.image = UIImage(named: "camera")
        
        self.addSubview(self.icon)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = self.frame.width / 2
        
    }
    
}
