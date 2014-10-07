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
    
    var imageView:UIImageView!
    
    override init() {
        let frame = CGRectMake(0, 0, 50, 50)
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
       
        imageView = UIImageView(frame: frame)
        imageView.image = UIImage(named: "cat.png")
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
}
