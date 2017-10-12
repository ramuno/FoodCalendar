//
//  CollectionViewCell.swift
//  FoodCalendar
//
//  Created by Student on 2017/07/16.
//  Copyright © 2017年 Student. All rights reserved.
//

import UIKit

class CalendarCell: UICollectionViewCell {
    
    var textLabel:UILabel!
    var imageView:UIImageView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        self.textLabel = UILabel(frame: CGRect(x: 0,y: 0,width: self.frame.width,height: self.frame.height))
        self.textLabel.font = UIFont(name: "HiraKakuProN-W3", size: 12)
        self.textLabel.textAlignment = NSTextAlignment.center
        self.addSubview(self.textLabel!)
        
        self.imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        self.addSubview(self.imageView)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
}
