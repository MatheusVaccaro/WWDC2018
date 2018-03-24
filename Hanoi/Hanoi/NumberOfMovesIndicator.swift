//
//  NumberOfMovesIndicator.swift
//  Hanoi
//
//  Created by Matheus Vaccaro on 23/03/18.
//  Copyright © 2018 Matheus Vaccaro. All rights reserved.
//

import Foundation
import SceneKit

class NumberOfMovesIndicator {
    private let frontMoveIndicator: SCNNode
//    private let backMoveIndicator: SCNNode
    private var textGeometry: SCNText
    
    
    var numberOfMoves: Int = 0 {
        didSet {
            let sequence = SCNAction.sequence([
                SCNAction.scale(by: 1.1, duration: 0.2),
                SCNAction.run( { [unowned self] node in
                    self.textGeometry.string = "Number of Moves: \(self.numberOfMoves)"
                }),
                SCNAction.scale(by: 1 / 1.1, duration: 0.2)
                ])
            sequence.timingMode = .easeInEaseOut
            
            frontMoveIndicator.runAction(sequence)
        }
    }
    
    init(towerOfHanoi: TowerOfHanoi) {
        let towerBase = towerOfHanoi.base
        self.textGeometry = SCNText(string: "Number of Moves: \(numberOfMoves)", extrusionDepth: 0.25)
        self.textGeometry.font = UIFont(name: "HelveticaNeue-Bold", size: 1)
        
        let positionOffset: Float = 1
        
        self.frontMoveIndicator = SCNNode(geometry: textGeometry)
        self.frontMoveIndicator.position = SCNVector3(Float(towerBase.width / -2), towerBase.node.position.y, towerBase.node.position.z + Float(towerBase.length / 2) + positionOffset)
        self.frontMoveIndicator.rotation = SCNVector4(x: -1, y: 0, z: 0, w: Float.pi / 4)
        towerOfHanoi.node.addChildNode(frontMoveIndicator)
        
//        self.backMoveIndicator = SCNNode(geometry: textGeometry)
//        self.backMoveIndicator.position = SCNVector3(Float(towerBase.width / -2), towerBase.node.position.y, towerBase.node.position.z + Float(towerBase.length / -2) - positionOffset)
//        self.backMoveIndicator.rotation = SCNVector4(x: 1, y: 0.5, z: 0, w: Float.pi / 4)
//        towerOfHanoi.node.addChildNode(backMoveIndicator)
    }
}

