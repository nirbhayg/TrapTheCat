//
//  Cat.swift
//  TrapTheCat
//
//  Created by Nirbhay Agarwal on 11/09/14.
//  Copyright (c) 2014 NSRover. All rights reserved.
//

import UIKit

class Cat: UIView {
    
    var currentVertex:Vertex?
    var isSelected = false

    func highlight() {
        self.backgroundColor = UIColor.redColor()
        isSelected = true
    }
    
    func unhighlight() {
        self.backgroundColor = UIColor.yellowColor()
        isSelected = false
    }
}
