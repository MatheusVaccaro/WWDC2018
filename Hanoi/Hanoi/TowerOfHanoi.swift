//
//  TowerOfHanoi.swift
//  Hanoi
//
//  Created by Matheus Vaccaro on 19/03/18.
//  Copyright © 2018 Matheus Vaccaro. All rights reserved.
//

import Foundation
import SceneKit

class TowerOfHanoi {
    let node: SCNNode
    let pegs: [Peg]
    
    init(numberOfDisks nDisks: Int, numberOfPegs nPegs: Int, initialPeg: Int = 1) {
        self.node = SCNNode()
        
        let base = Base(forNumberOfDisks: nDisks, numberOfPegs: nPegs)
        node.addChildNode(base.node)
        
        var pegs: [Peg] = []
        for index in 0..<nPegs {
            let peg = Peg(forNumberOfDisks: nDisks, base: base, index: index)
            node.addChildNode(peg.node)
            pegs.append(peg)
        }
        self.pegs = pegs
        
        place(numberOfDisks: nDisks, atPeg: initialPeg)
    
    }
    
    func moveTopDisk(fromPeg sourcePegIndex: Int, toPeg targetPegIndex: Int, duration: TimeInterval = 1.0, completionHandler: (() -> Void)? = nil) {
        let sourcePeg = pegs[sourcePegIndex - 1]
        let targetPeg = pegs[targetPegIndex - 1]
        
        sourcePeg.moveTopDisk(to: targetPeg, duration: duration) {
            completionHandler?()
        }
    }
    
    private func place(numberOfDisks nDisks: Int, atPeg pegIndex: Int) {
        let peg = pegs[pegIndex - 1]
        let range = (1...nDisks).reversed()
        for diskNumber in range {
            let disk = Disk(outerRadius: CGFloat(diskNumber))
            let positionVector: SCNVector3
            if peg.diskStack.isEmpty {
                positionVector = SCNVector3(peg.node.position.x, peg.relativeMinY + Float(disk.height / 2), peg.node.position.z)
            } else {
                positionVector = SCNVector3(peg.node.position.x, peg.diskStack.peek()!.relativeMaxY + Float(disk.height / 2), peg.node.position.z)
            }
            disk.node.position = positionVector
            node.addChildNode(disk.node)
            peg.diskStack.push(disk)
        }
    }
    
}


