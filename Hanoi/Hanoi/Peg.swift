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
    let index: Int
    var diskStack: Stack<Disk>
    
    var isSelected: Bool {
        didSet {
            if oldValue != isSelected {
                if isSelected {
                    activateSelection()
                } else {
                    deactivateSelection()
                }
            }
        }
    }
    
    private var selectedDisk: Disk?
    
    private let expectedMaxNumberOfDisks: Int
    private var pegSectionWidth: CGFloat {
        return CGFloat(expectedMaxNumberOfDisks * 2) + Disk.innerRadius
    }
    
    var hitbox: Hitbox!
    
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
        self.isSelected = false
        self.expectedMaxNumberOfDisks = nDisks
        self.index = index
        self.height = CGFloat(nDisks) + Peg.heightModifier
        self.diskStack = Stack()
        
        let tube = SCNTube(innerRadius: Peg.innerRadius, outerRadius: Peg.outerRadius, height: height)
        tube.firstMaterial?.diffuse.contents = "art.scnassets/woodTexture"
        self.node = SCNNode(geometry: tube)
        
        positionAt(base: base, index: index)
        
        defer {
            self.hitbox = Hitbox(width: pegSectionWidth, height: pegSectionWidth, length: pegSectionWidth, associatedObject: self)
            self.node.addChildNode(hitbox)
        }
    }
    
    func moveTopDisk(to destination: Peg, completionHandler: (() -> Void)? = nil) {
        guard destination != self else { return }

        guard let topDisk = diskStack.peek() else {
            print("Error. Could not get top disk.")
            completionHandler?()
            return
        }
        
        let moveAction: SCNAction
        if let destinationTopDisk = destination.diskStack.peek(), topDisk.outerRadius > destinationTopDisk.outerRadius {
            moveAction = createActionToMoveFailure(disk: topDisk, to: destination)
        } else {
            moveAction = createActionToMoveSuccess(disk: topDisk, to: destination)
        }
        
        let waitAction = SCNAction.wait(duration: 0.2)
        let sequence = SCNAction.sequence([moveAction, waitAction])
        
        topDisk.node.runAction(sequence, completionHandler: completionHandler)
        
    }
 
    private func createActionToMoveSuccess(disk: Disk, to destination: Peg, durationMultiplier: Double = 1) -> SCNAction {
        let defaultDuration: TimeInterval = 0.3
        let duration = defaultDuration * durationMultiplier
        
        let heightOffset: Float = 2
        let liftVector = SCNVector3(node.position.x, relativeMaxY + heightOffset, node.position.z)
        let liftAction = SCNAction.move(to: liftVector, duration: duration)
        
        let moveVector = SCNVector3(destination.node.position.x, destination.relativeMaxY + heightOffset, destination.node.position.z)
        let moveAction = SCNAction.move(to: moveVector, duration: duration)
        
        let lowerVector: SCNVector3
        let diskOffset = Float(disk.height / 2)
        if destination.diskStack.isEmpty {
            lowerVector = SCNVector3(destination.node.position.x, destination.relativeMinY + diskOffset , destination.node.position.z)
        } else {
            let destinationTopDisk = destination.diskStack.peek()!
            lowerVector = SCNVector3(destination.node.position.x, destinationTopDisk.relativeMaxY + diskOffset, destination.node.position.z)
        }
        let lowerAction = SCNAction.move(to: lowerVector, duration: duration)
        
        
        let removeDiskFromSourceAndAddToDestinationAction = SCNAction.run { _ in
            let disk = self.diskStack.pop()!
            destination.diskStack.push(disk)
        }
        
        let actionSequence = SCNAction.sequence([liftAction, moveAction, lowerAction, removeDiskFromSourceAndAddToDestinationAction])
    
        return actionSequence
    }
    
    private func createActionToMoveFailure(disk: Disk, to destination: Peg, durationMultiplier: Double = 1) -> SCNAction {
        let defaultDuration: TimeInterval = 0.3
        let duration = defaultDuration * durationMultiplier
        
        let defaultShakeDuration: TimeInterval = 0.05
        let shakeDuration = defaultShakeDuration * durationMultiplier
        
        
        let heightOffset: Float = 2
        let sourceLiftVector = SCNVector3(node.position.x, relativeMaxY + heightOffset, node.position.z)
        let sourceLiftAction = SCNAction.move(to: sourceLiftVector, duration: duration)
        
        let moveVector = SCNVector3(destination.node.position.x, destination.relativeMaxY + heightOffset, destination.node.position.z)
        let moveAction = SCNAction.move(to: moveVector, duration: duration)
        
        let diskOffset = Float(disk.height / 2)
        let destinationTopDisk = destination.diskStack.peek()!
        let liftDownDestinationVector = SCNVector3(destination.node.position.x, destinationTopDisk.relativeMaxY + diskOffset, destination.node.position.z)
        let liftDownDestinationAction = SCNAction.move(to: liftDownDestinationVector, duration: duration)
        
        let waitAction = SCNAction.wait(duration: duration)
        
        let shakeLeftAction = SCNAction.moveBy(x: -0.5, y: 0, z: 0, duration: shakeDuration)
        let goToMiddle = SCNAction.move(to: SCNVector3(destination.node.position.x, destinationTopDisk.relativeMaxY + diskOffset, destination.node.position.z), duration: shakeDuration)
        let shakeRightAction = SCNAction.moveBy(x: +0.5, y: 0, z: 0, duration: shakeDuration)
        let shakeAction = SCNAction.sequence([shakeLeftAction, goToMiddle, shakeRightAction, goToMiddle, shakeLeftAction, goToMiddle])
        
        let destinationLiftVector = SCNVector3(destination.node.position.x, destination.relativeMaxY + heightOffset, destination.node.position.z)
        let destinationLiftAction = SCNAction.move(to: destinationLiftVector, duration: duration)
        
        // -height because the disk was lifted by it's height
        let initialDiskPosition = SCNVector3(disk.node.position.x, disk.node.position.y - Float(disk.height), disk.node.position.z)
//        let initialDiskPosition = disk.node.position
        let moveBackVector = SCNVector3(initialDiskPosition.x, relativeMaxY + heightOffset, initialDiskPosition.z)
        let moveBackAction = SCNAction.move(to: moveBackVector, duration: duration)
        
        let destinationLowerVector = SCNVector3(initialDiskPosition.x, initialDiskPosition.y, initialDiskPosition.z)
        let destinationLowerAction = SCNAction.move(to: destinationLowerVector, duration: duration)
        
        let actionSequence = SCNAction.sequence([sourceLiftAction, moveAction, liftDownDestinationAction, waitAction, shakeAction, waitAction, destinationLiftAction, moveBackAction, destinationLowerAction])
        
        return actionSequence
    }
    
    private func positionAt(base: Base, index: Int) {
        let pegSectionInitialX = -base.width / 2 + pegSectionWidth / 2
    
        let positionVector = SCNVector3(pegSectionInitialX + pegSectionWidth * CGFloat(index), CGFloat(base.relativeMaxY) + (height / 2), CGFloat(0))
        node.position = positionVector
    }
    
    private func activateSelection() {
        guard let topDisk = diskStack.peek() else { return }
        self.selectedDisk = topDisk
        let defaultDuration: TimeInterval = 0.1
        
        let liftAction = SCNAction.moveBy(x: 0, y: topDisk.height, z: 0, duration: defaultDuration)
        let selectDiskAction = SCNAction.run( { _ in
            topDisk.isSelected = true
        })
        let actionSequence = SCNAction.sequence([selectDiskAction, liftAction])
        topDisk.node.runAction(actionSequence)
    }
    
    private func deactivateSelection() {
        guard let selectedDisk = self.selectedDisk else { return }
        let defaultDuration: TimeInterval = 0.1
        
        let lowerAction = SCNAction.moveBy(x: 0, y: -selectedDisk.height, z: 0, duration: defaultDuration)
        let unselectDiskAction = SCNAction.run( { _ in
            selectedDisk.isSelected = false
        })
        let actionSequence = SCNAction.sequence([lowerAction, unselectDiskAction])
        selectedDisk.node.runAction(actionSequence)
    }
}

extension Peg: Equatable {
    static func ==(lhs: Peg, rhs: Peg) -> Bool {
        return lhs === rhs
    }
}

