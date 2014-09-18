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
    
    func setup() {
        self.frame = CGRectMake(0, 0, 25, 25)
        self.backgroundColor = UIColor .blackColor()
    }
    
    func highlight() {
        self.backgroundColor = UIColor.redColor()
        isSelected = true
    }
    
    func unhighlight() {
        self.backgroundColor = UIColor.blackColor()
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
