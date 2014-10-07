//
//  Mouse.swift
//  TrapTheCat
//
//  Created by Nirbhay Agarwal on 11/09/14.
//  Copyright (c) 2014 NSRover. All rights reserved.
//

import UIKit

class Mouse: UIView {
    
    var isSelected = false
    var currentVertex:Vertex?
    
    var imageView:UIImageView!
    
    override init() {
        super.init(frame: CGRectMake(0, 0, 25, 25))
        self.backgroundColor = UIColor.clearColor()
        
        imageView = UIImageView(frame: frame)
        imageView.image = UIImage(named: "mouse.png")
        self.addSubview(imageView)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func highlight() {
        self.backgroundColor = UIColor.redColor()
        isSelected = true
    }
    
    func unhighlight() {
        self.backgroundColor = UIColor.clearColor()
        isSelected = false
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect)
    {
        // Drawing code
    }
    */

}
