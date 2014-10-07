//
//  Vertex.swift
//  TrapTheCat
//
//  Created by Nirbhay Agarwal on 11/09/14.
//  Copyright (c) 2014 NSRover. All rights reserved.
//

import UIKit

enum OccupiedBy:Int {
    case Mouse = 1
    case Cat
    case No_one
}

class Vertex: UIView {

    var ID:Int = -1
    var occupiedBy:OccupiedBy = OccupiedBy.No_one
    
    var imageView:UIImageView!
    
    func setup() {
        self.backgroundColor = UIColor.clearColor()
        imageView = UIImageView(frame: self.bounds)
        imageView.image = UIImage(named: "vertex.png")
        self.addSubview(imageView)
    }
    
    func highlight() {
        self.backgroundColor = UIColor.greenColor()
    }
    
    func unhighlight() {
        self.backgroundColor = UIColor.clearColor()
    }
//
//    init(ID:Int) {
//        self.ID = ID
//        super.init()
//    }
//
//    required init(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }

    
//    required init(coder aDecoder: NSCoder) {
//        ID = -1
//        super.init(coder: aDecoder)
//    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect)
    {
        // Drawing code
    }
    */

}
