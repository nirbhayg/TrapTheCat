//
//  ViewController.swift
//  TrapTheCat
//
//  Created by Nirbhay Agarwal on 11/09/14.
//  Copyright (c) 2014 NSRover. All rights reserved.
//

import UIKit

enum Turn:Int {
    case MiceTap = 1
    case MiceMove
    case CatTap
    case CatMove
}

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var v0: Vertex!
    @IBOutlet weak var v1: Vertex!
    @IBOutlet weak var v2: Vertex!
    @IBOutlet weak var v3: Vertex!
    @IBOutlet weak var v4: Vertex!
    @IBOutlet weak var v5: Vertex!
    @IBOutlet weak var v6: Vertex!
    @IBOutlet weak var v7: Vertex!
    @IBOutlet weak var v8: Vertex!
    @IBOutlet weak var v9: Vertex!
    
    let animationDuration = 0.5
    
    //Items
    var vertices:[Vertex] = []
    let cat = Cat()
    let mouse1 = Mouse()
    let mouse2 = Mouse()
    let mouse3 = Mouse()
    var mice:[Mouse] = []

    //Gameplay
    var turn:Turn = Turn.MiceTap
    
    //Game logic
    
    func isVertex(vertexFrom:Vertex, aNeighbourOf vertexTo:Vertex, considerJump:Bool = false) -> (answer:Bool, middleVertex:Vertex?) {
        
        switch vertexFrom {
        case v0 where (vertexTo == v1):
            return (true, nil)
            
        case v0 where considerJump && (vertexTo == v2) && (v1.occupiedBy == OccupiedBy.Mouse):
            return (true, v1)
            
        case v1 where vertexTo == v0 || vertexTo == v3 || vertexTo == v2:
            return (true, nil)
            
        case v1 where considerJump && (vertexTo == v7) && (v3.occupiedBy == OccupiedBy.Mouse):
            return (true, v3)
            
        case v2 where vertexTo == v1:
            return (true, nil)
            
        case v2 where considerJump && (vertexTo == v0) && (v1.occupiedBy == OccupiedBy.Mouse):
            return (true, v1)
            
        case v3 where vertexTo == v1 || vertexTo == v4 || vertexTo == v5 || vertexTo == v7:
            return (true, nil)
            
        case v3 where considerJump && (vertexTo == v9) && (v7.occupiedBy == OccupiedBy.Mouse):
            return (true, v7)
            
        case v4 where vertexTo == v3 || vertexTo == v6:
            return (true, nil)
            
        case v4 where considerJump && (vertexTo == v5) && (v3.occupiedBy == OccupiedBy.Mouse):
            return (true, v3)
            
        case v4 where considerJump && (vertexTo == v9) && (v6.occupiedBy == OccupiedBy.Mouse):
            return (true, v6)
            
        case v5 where vertexTo == v3 || vertexTo == v8:
            return (true, nil)
            
        case v5 where considerJump && (vertexTo == v4) && (v3.occupiedBy == OccupiedBy.Mouse):
            return (true, v3)
            
        case v5 where considerJump && (vertexTo == v9) && (v8.occupiedBy == OccupiedBy.Mouse):
            return (true, v8)
            
        case v6 where vertexTo == v4 || vertexTo == v7 || vertexTo == v9:
            return (true, nil)
            
        case v6 where considerJump && (vertexTo == v8) && (v7.occupiedBy == OccupiedBy.Mouse):
            return (true, v7)
            
        case v7 where vertexTo == v3 || vertexTo == v6 || vertexTo == v8 || vertexTo == v9:
            return (true, nil)
            
        case v7 where considerJump && (vertexTo == v1) && (v3.occupiedBy == OccupiedBy.Mouse):
            return (true, v3)
            
        case v8 where vertexTo == v5 || vertexTo == v7 || vertexTo == v9:
            return (true, nil)
            
        case v8 where considerJump && (vertexTo == v6) && (v7.occupiedBy == OccupiedBy.Mouse):
            return (true, v7)
            
        case v9 where vertexTo == v6 || vertexTo == v8 || vertexTo == v7:
            return (true, nil)
            
        case v9 where considerJump && (vertexTo == v5)
            
            
            || vertexTo == v3 || vertexTo == v4):
            return true
            
        default:
            println("no neighbours for \(vertexFrom)")
        }
        
        return false
    }
    
    func moveCatToVertex(vertex:Vertex) {
        
        if let catsCurrentVetex = cat.currentVertex {
            catsCurrentVetex.occupiedBy = .No_one
            catsCurrentVetex.unhighlight()
        }
        
        UIView.animateWithDuration(animationDuration,
            animations: {
            self.cat.center = vertex.center
            },
            completion: { (value: Bool) in
                vertex.occupiedBy = .Cat
                self.cat.currentVertex = vertex
    
                self.cat.unhighlight()
                self.endTurn()
        })
    }
    
    func moveMouse(mouse:Mouse, toVertex:Vertex) {
        
        if let mousesCurrentVertex = mouse.currentVertex {
            mousesCurrentVertex.occupiedBy = .No_one
            mousesCurrentVertex.unhighlight()
        }
        
        UIView.animateWithDuration(animationDuration,
            animations: {
                mouse.center = toVertex.center
            }, completion: { (value: Bool) in
                toVertex.occupiedBy = .Mouse
                mouse.currentVertex = toVertex
    
                mouse.unhighlight()
                self.endTurn()
        })
    }
    
    func endTurn() {
        switch turn {
        case .MiceTap:
            turn = .MiceMove
        case .MiceMove:
            turn = .CatTap
        case .CatTap:
            turn = .CatMove
        case .CatMove:
            turn = .MiceTap
        }
    }
    
    //User input
    
    func handleTap(recognizer: UITapGestureRecognizer) {
        if CGRectContainsPoint(cat.frame, recognizer.locationInView(self.view)) {
            self.catTapped()
        }
        else if CGRectContainsPoint(mouse1.frame, recognizer.locationInView(self.view)) {
            self.mouseTapped(mouse1)
        }
        else if CGRectContainsPoint(mouse2.frame, recognizer.locationInView(self.view)) {
            self.mouseTapped(mouse2)
        }
        else if CGRectContainsPoint(mouse3.frame, recognizer.locationInView(self.view)) {
            self.mouseTapped(mouse3)
        }
        else {
            for vertex in vertices {
                if CGRectContainsPoint(vertex.frame, recognizer.locationInView(self.view)) {
                    self.vertexTapped(vertex)
                    break
                }
            }
        }
    }
    
    func catTapped() {
        if turn == .CatTap {
            cat.highlight()
            endTurn()
        }
        else if turn == .CatMove {
            println("Select a vertex for cat to move to")
        }
        else {
            println("Its mouse's turn")
        }
    }
    
    func mouseTapped(_mouse: Mouse) {
        if turn == Turn.MiceTap {
            _mouse.highlight()
            endTurn()
        }
        else if turn == Turn.MiceMove {
            println("select a vertex for mouse to move to")
        }
        else {
            println("Its cat's turn")
        }
    }
    
    func vertexTapped(_vertex: Vertex) {
        
        //Check if already occupied
        if _vertex.occupiedBy != OccupiedBy.No_one {
            println("Cannot move there")
            return
        }
        
        //Check if correct piece tapped
        if turn == Turn.MiceMove {
            if let selectedMouse = self.selectedMouse() {
                _vertex.highlight()
                self.moveMouse(selectedMouse, toVertex: _vertex)
            }
            else {
                println("no mouse selected to move")
            }
        }
        else if turn == .MiceTap {
            println("first select a mouse to move")
        }
        else if turn == .CatMove {
            if cat.isSelected {
                
                //Check if neighbour vertex
                if let currentCatVertex = cat.currentVertex {
                    if isVertex(currentCatVertex, aNeighbourOf: _vertex, considerJump: true) {
                        _vertex.highlight()
                        self.moveCatToVertex(_vertex)
                    }
                    else {
                        println("You can only the cat to neighbouring vertex")
                    }
                }
                
            }
            else {
                println("you need to select the cat first")
            }
        }
        else {
            println("first select the cat")
        }
    }
    
    //Helpers
    
    func selectedMouse() -> Mouse? {
        for mouse in mice {
            if mouse.isSelected {
                return mouse
            }
        }
        return nil
    }
    
    //Setup
    
    func initialSetup() {
        //Vertices
        vertices = [v0, v1, v2, v3, v4, v5, v6, v7, v8, v9]
        
        for ii in 0..<vertices.count {
            vertices[ii].ID = ii
        }
        
        //Add cat
        cat.frame = CGRectMake(0, 0, 30, 30);
        cat.backgroundColor = UIColor.yellowColor()
        self.view.addSubview(cat)
        
        //Mice
        mice = [mouse1, mouse2, mouse3]
        
        for mouse in mice {
            mouse.setup()
            self.view.addSubview(mouse)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
        
        let recognizer = UITapGestureRecognizer(target: self, action:Selector("handleTap:"))
        recognizer.delegate = self
        self.view.addGestureRecognizer(recognizer)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
     
//        //Position cat
//        self.moveCatToVertex(v9)
//        
//        //Postition mice
//        self.moveMouse(mouse1, toVertex: v0)
//        self.moveMouse(mouse2, toVertex: v1)
//        self.moveMouse(mouse3, toVertex: v2)
        
        
        //Position cat
        self.moveCatToVertex(v0)
        
        //Postition mice
        self.moveMouse(mouse1, toVertex: v5)
        self.moveMouse(mouse2, toVertex: v6)
        self.moveMouse(mouse3, toVertex: v7)
    }
    
}

