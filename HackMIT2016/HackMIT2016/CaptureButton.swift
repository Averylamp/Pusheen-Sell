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
    
    private let iconSize = CGSize(width: 40, height: 40)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    func setup() {
        
        self.backgroundColor = Color.pink
        
        self.icon = UIImageView(frame: CGRect(x: 10, y: 10, width: self.iconSize.width, height: self.iconSize.height))
        self.icon.image = UIImage(named: "camera")
        
        self.addSubview(self.icon)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = self.frame.width / 2
        
        let shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.bounds.width / 2)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowOpacity = 0.2
        self.layer.shadowPath = shadowPath.cgPath
        self.layer.shadowRadius = 5
        
    }
    
}
