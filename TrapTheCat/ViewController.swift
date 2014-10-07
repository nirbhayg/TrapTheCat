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
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageTopDistanceConstraint: NSLayoutConstraint!
    
    let touchArea:CGFloat = 50.0
    let animationDuration = 0.5
    var firstLayoutComplete = false
    
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
            
        case v9 where considerJump && (vertexTo == v5) && (v8.occupiedBy == OccupiedBy.Mouse):
            return (true, v8)
            
        case v9 where considerJump && (vertexTo == v3) && (v7.occupiedBy == OccupiedBy.Mouse):
            return (true, v7)
                
        case v9 where considerJump && (vertexTo == v4) && (v6.occupiedBy == OccupiedBy.Mouse):
            return (true, v6)
            
        default:
            return (false, nil)
        }
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
                vertex.unhighlight()
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
                toVertex.unhighlight()
                self.endTurn()
        })
    }
    
    func endTurn() {
        switch turn {
        case .MiceTap:
            turn = .MiceMove
        case .MiceMove:
            if didMiceWin() {
                showError("Mice won!!!!!!!")
                resetGame()
            }
            else {
                turn = .CatTap
            }
        case .CatTap:
            turn = .CatMove
        case .CatMove:
            turn = .MiceTap
        }
    }
    
    func didMiceWin() -> Bool {
        if let catsCurrentVertex = cat.currentVertex {
            let neighbours = neighboursForVertex(catsCurrentVertex, considerJump: true)
            for neighbour in neighbours {
                if neighbour.occupiedBy == OccupiedBy.No_one {
                    return false
                }
            }
            return true
        }
        return false
    }
    
    func resetGame() {
        resetBoard()
    }
    
    //User input
    
    func handleTap(recognizer: UITapGestureRecognizer) {
        let tappedPoint = recognizer.locationInView(self.view)
        if closeEnough(firstPoint: cat.center, secondPoint: tappedPoint) {
            self.catTapped()
        }
        else if closeEnough(firstPoint: mouse1.center, secondPoint: tappedPoint) {
            self.mouseTapped(mouse1)
        }
        else if closeEnough(firstPoint: mouse2.center, secondPoint: tappedPoint) {
            self.mouseTapped(mouse2)
        }
        else if closeEnough(firstPoint: mouse3.center, secondPoint: tappedPoint) {
            self.mouseTapped(mouse3)
        }
        else {
            for vertex in vertices {
                if closeEnough(firstPoint: vertex.center, secondPoint: tappedPoint) {
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
            showError("Select a vertex for cat to move to")
        }
        else {
            showError("Its mouse's turn")
        }
    }
    
    func mouseTapped(_mouse: Mouse) {
        if turn == Turn.MiceTap {
            _mouse.highlight()
            endTurn()
        }
        else if turn == Turn.MiceMove {
            if let currentlySelectedMouse = selectedMouse() {
                currentlySelectedMouse.unhighlight()
                _mouse.highlight()
            }
            else {
                showError("select a vertex for mouse to move to")
            }
        }
        else {
            showError("Its cat's turn")
        }
    }
    
    func vertexTapped(_vertex: Vertex) {
        
        //Check if already occupied
        if _vertex.occupiedBy != OccupiedBy.No_one {
            showError("Cannot move there")
            return
        }
        
        //Check if correct piece tapped
        if turn == Turn.MiceMove {
            if let selectedMouse = self.selectedMouse() {
                _vertex.highlight()
                self.moveMouse(selectedMouse, toVertex: _vertex)
            }
            else {
                showError("no mouse selected to move")
            }
        }
        else if turn == .MiceTap {
            showError("first select a mouse to move")
        }
        else if turn == .CatMove {
            if cat.isSelected {
                
                //Check if neighbour vertex
                if let currentCatVertex = cat.currentVertex {
                    
                    let (canJump, midVertex) = isVertex(currentCatVertex, aNeighbourOf: _vertex, considerJump: true)
                    if canJump {
                        //Cat jumped over a mouse
                        if let occupiedMidVertex = midVertex {
                            _vertex.highlight()
                            self.moveCatToVertex(_vertex)
                            showError("Cat won!!!!!!!!")
                            resetGame()
                        }
                        //Cat moved a normal turn
                        else {
                            _vertex.highlight()
                            self.moveCatToVertex(_vertex)
                        }
                    }
                    else {
                        showError("You can only move the cat to neighbouring vertex")
                    }
                }
                
            }
            else {
                showError("you need to select the cat first")
            }
        }
        else {
            showError("first select the cat")
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
    
    func closeEnough(#firstPoint:CGPoint, secondPoint:CGPoint) -> Bool {
        if distanceBetween(point: firstPoint, andPoint: secondPoint) < touchArea {
            return true
        }
        return false
    }

    func distanceBetween(point p1:CGPoint, andPoint p2:CGPoint) -> CGFloat {
        return sqrt(pow((p2.x - p1.x), 2) + pow((p2.y - p1.y), 2))
    }
    
    func neighboursForVertex(vertex:Vertex, considerJump:Bool) -> [Vertex] {
        var neighbours:[Vertex] = []
        for potentialNeighbour in vertices {
            let (answer, dummy) = isVertex(vertex, aNeighbourOf: potentialNeighbour, considerJump: considerJump)
            if answer {
                neighbours.append(potentialNeighbour)
            }
        }
        return neighbours
    }
    
    //Setup
    
    func initialSetup() {
        //Vertices
        vertices = [v0, v1, v2, v3, v4, v5, v6, v7, v8, v9]
        
        for ii in 0..<vertices.count {
            vertices[ii].ID = ii
            vertices[ii].setup()
        }
        
        //Add cat
        self.view.addSubview(cat)
        
        //Mice
        mice = [mouse1, mouse2, mouse3]
        
        for mouse in mice {
            self.view.addSubview(mouse)
        }
    }
    
    func resetBoard() {
        //Position cat
        self.moveCatToVertex(v9)
        
        //Postition mice
        self.moveMouse(mouse1, toVertex: v0)
        self.moveMouse(mouse2, toVertex: v1)
        self.moveMouse(mouse3, toVertex: v2)
        
        //            //Position cat
        //            self.moveCatToVertex(v0)
        //
        //            //Postition mice
        //            self.moveMouse(mouse1, toVertex: v5)
        //            self.moveMouse(mouse2, toVertex: v3)
        //            self.moveMouse(mouse3, toVertex: v2)
        
        //Message view
        self.view.bringSubviewToFront(messageView)
        hideError()
        
        connectTheDots()
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
     
        if firstLayoutComplete == false {
            firstLayoutComplete = true
            resetBoard()
        }
    }
    
    //UI Updates
    
    func connectTheDots() {
        
        //Add layer
        for vertex in vertices {
            for neighbour in neighboursForVertex(vertex, considerJump: false) {
                drawPathFrom(point: vertex.center, toPoint: neighbour.center)
            }
        }
    }
    
    func drawPathFrom(#point:CGPoint, toPoint:CGPoint) {
        let path = UIBezierPath()
        path.moveToPoint(point)
        path.addLineToPoint(toPoint)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.CGPath
        
        shapeLayer.strokeColor = UIColor.grayColor().CGColor
        shapeLayer.lineWidth = 2.5
        self.view.layer.insertSublayer(shapeLayer, atIndex: 0)
    }
    
    func showError(message:String) {
        messageLabel.text = message
        self.view.layoutIfNeeded()
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 5, initialSpringVelocity: 5, options:UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.messageTopDistanceConstraint.constant = 100
            self.view.layoutIfNeeded()
            }) { (complete) -> Void in
            self.hideError()
        }
    }
    
    func hideError() {
        self.view.layoutIfNeeded()
        
        UIView.animateWithDuration(0.5, delay: 2.0, usingSpringWithDamping: 5, initialSpringVelocity: 5, options:UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.messageTopDistanceConstraint.constant = -self.messageView.frame.height-20
            self.view.layoutIfNeeded()
        }) { (complete) -> Void in
            
        }
    }
}

