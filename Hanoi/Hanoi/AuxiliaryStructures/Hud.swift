//
//  Hud.swift
//  Hanoi
//
//  Created by Matheus Vaccaro on 23/03/18.
//  Copyright © 2018 Matheus Vaccaro. All rights reserved.
//

import Foundation
import SpriteKit
import SceneKit

class Hud: SKScene {
    
    let numberOfMovesLabel: SKLabelNode
    
    var numberOfMoves: Int = 0 {
        didSet {
            let sequence = SKAction.sequence([
                SKAction.scale(by: 1.1, duration: 0.2),
                SKAction.run { [unowned self] in self.numberOfMovesLabel.text = "Number of moves: \(self.numberOfMoves)" },
                SKAction.scale(by: 1 / 1.1, duration: 0.2)
                ])
            sequence.timingMode = .easeInEaseOut
            numberOfMovesLabel.run(sequence)
        }
    }
    
    override init(size: CGSize) {
        self.numberOfMovesLabel = SKLabelNode(fontNamed: "HelveticaNeue-Bold")
        self.numberOfMovesLabel.text = "Number of moves: \(numberOfMoves)"
        self.numberOfMovesLabel.fontSize = size.width * 0.09
        
        super.init(size: size)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.numberOfMovesLabel.position = CGPoint(x: self.numberOfMovesLabel.position.x, y: size.height / 2 * 0.9)
        addChild(self.numberOfMovesLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//let node: SCNNode
//let skScene: SKScene
//let numberOfMovesLabel: SKLabelNode
//var numberOfMoves: Int = 0
//
//init() {
//    self.skScene = SKScene(size: CGSize(width: 1000, height: 100))
//    skScene.backgroundColor = UIColor(white: 0.0, alpha: 1.0)
//
//    numberOfMovesLabel = SKLabelNode(fontNamed: "Menlo-Bold")
//    numberOfMovesLabel.fontSize = 48
//    numberOfMovesLabel.position.y = 50
//    numberOfMovesLabel.position.x = 250
//
//    numberOfMovesLabel.text = "Number of moves: \(numberOfMoves)"
//
//    skScene.addChild(numberOfMovesLabel)
//
//    let plane = SCNPlane(width: 5, height: 1)
//    let material = SCNMaterial()
//    material.lightingModel = SCNMaterial.LightingModel.constant
//    material.isDoubleSided = true
//    material.diffuse.contents = skScene
//    plane.materials = [material]
//
//    node = SCNNode(geometry: plane)
//    node.rotation = SCNVector4(x: 1, y: 0, z: 0, w: 3.14159265)
//}
//
//func update(numberOfMoves: Int) {
//    numberOfMovesLabel.text = "Number of moves: \(numberOfMoves)"
//}

