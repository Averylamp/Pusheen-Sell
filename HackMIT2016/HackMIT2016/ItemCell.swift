//
//  ItemCell.swift
//  HackMIT2016
//
//  Created by Nathan Gitter on 9/17/16.
//  Copyright © 2016 Nathan Gitter. All rights reserved.
//

import UIKit

class ItemCell: UICollectionViewCell {
    
    var item: Item?
    
    override func layoutSubviews() {
        self.backgroundColor = UIColor.orange
    }
    
}
