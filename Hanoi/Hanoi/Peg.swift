//
//  Peg.swift
//  Hanoi
//
//  Created by Matheus Vaccaro on 20/03/18.
//  Copyright © 2018 Matheus Vaccaro. All rights reserved.
//

import Foundation
import SceneKit

class Peg {
    let node: SCNNode
    let height: CGFloat
    private let expectedMaxNumberOfDisks: Int
    var diskStack: Stack<Disk>
    
    static let heightModifier: CGFloat = 1
    static let innerRadius: CGFloat = 0
    static let outerRadius: CGFloat = 0.5
    
    var relativeMaxY: Float {
        return node.position.y + Float(height / 2)
    }
    var relativeMinY: Float {
        return node.position.y - Float(height / 2)
    }
    
    init(forNumberOfDisks nDisks: Int, base: Base, index: Int) {
        self.expectedMaxNumberOfDisks = nDisks
        self.height = CGFloat(nDisks) + Peg.heightModifier
        self.diskStack = Stack()
        
        let tube = SCNTube(innerRadius: Peg.innerRadius, outerRadius: Peg.outerRadius, height: height)
//        tube.firstMaterial?.diffuse.contents = UIColor.brown
        tube.firstMaterial?.diffuse.contents = "art.scnassets/woodTexture1"
        self.node = SCNNode(geometry: tube)
        
        positionAt(base: base, index: index)
    }
    
    
    func moveTopDisk(to destination: Peg, duration: TimeInterval, completionHandler: (() -> Void)? = nil) {
        guard destination != self else { return }

        guard let topDisk = diskStack.peek() else {
            print("Error. Could not get top disk.")
            return
        }
        
        if let destinationTopDisk = destination.diskStack.peek() {
            if topDisk.outerRadius > destinationTopDisk.outerRadius {
                print("Error. Destination's top disk is smaller than source's top disk.")
                return
            }
        }
        
        let moveAction = createActionToMove(disk: topDisk, to: destination, duration: duration)
        topDisk.node.runAction(moveAction, completionHandler: completionHandler)
        
    }
 
    func createActionToMove(disk: Disk, to destination: Peg, duration: TimeInterval) -> SCNAction {
        let heightOffset: Float = 2
        let liftUpVector = SCNVector3(node.position.x, relativeMaxY + heightOffset, node.position.z)
        let liftUpAction = SCNAction.move(to: liftUpVector, duration: duration / 3)
        
        let moveVector = SCNVector3(destination.node.position.x, destination.relativeMaxY + heightOffset, destination.node.position.z)
        let moveAction = SCNAction.move(to: moveVector, duration: duration / 3)
        
        let liftDownVector: SCNVector3
        let diskOffset = Float(disk.height / 2)
        if destination.diskStack.isEmpty {
            liftDownVector = SCNVector3(destination.node.position.x, destination.relativeMinY + diskOffset , destination.node.position.z)
        } else {
            let destinationTopDisk = destination.diskStack.peek()!
            liftDownVector = SCNVector3(destination.node.position.x, destinationTopDisk.relativeMaxY + diskOffset, destination.node.position.z)
        }
        let liftDownAction = SCNAction.move(to: liftDownVector, duration: duration / 3)
        
        
        let removeDiskFromSourceAndAddToDestinationAction = SCNAction.run { _ in
            let disk = self.diskStack.pop()!
            destination.diskStack.push(disk)
        }
        
        let actionSequence = SCNAction.sequence([liftUpAction, moveAction, liftDownAction, removeDiskFromSourceAndAddToDestinationAction])
    
        return actionSequence
    }
    
    private func positionAt(base: Base, index: Int) {
        let pegSectionWidth = CGFloat(expectedMaxNumberOfDisks * 2) + Disk.innerRadius
        let pegSectionInitialX = -base.width / 2 + pegSectionWidth / 2
    
        let positionVector = SCNVector3(pegSectionInitialX + pegSectionWidth * CGFloat(index), CGFloat(base.relativeMaxY) + (height / 2), CGFloat(0))
        node.position = positionVector
    }
}

extension Peg: Equatable {
    static func ==(lhs: Peg, rhs: Peg) -> Bool {
        return lhs === rhs
    }
}

