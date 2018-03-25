//
//  Firework.swift
//  Hanoi
//
//  Created by Matheus Vaccaro on 24/03/18.
//  Copyright © 2018 Matheus Vaccaro. All rights reserved.
//

import Foundation
import SceneKit

class Firework {
    let rootNode: SCNNode
    
    let fireworksParticleSystem: SCNParticleSystem
    let node: SCNNode
    let boundingBox: (min: SCNVector3, max: SCNVector3)
    let color: UIColor
    
    init(rootNode: SCNNode, boundingBox: (min: SCNVector3, max: SCNVector3), color: UIColor) {
        self.rootNode = rootNode
        
        self.node = SCNNode()
        self.boundingBox = boundingBox
        self.color = color
        
        let particleSystemName = "FireworksParticleSystem.scnp"
        self.fireworksParticleSystem = SCNParticleSystem(named: particleSystemName, inDirectory: nil)!
    }
    
    
    
    func createFireworkAction() -> SCNAction {
        let randomX = Float(arc4random_uniform(UInt32(boundingBox.max.x - boundingBox.min.x))) + boundingBox.min.x
        let randomY = Float(arc4random_uniform(UInt32(boundingBox.max.y - boundingBox.min.y))) + boundingBox.min.y
        let randomZ = Float(arc4random_uniform(UInt32(boundingBox.max.z - boundingBox.min.z))) + boundingBox.min.z
        node.position = SCNVector3(randomX, randomY, randomZ)
        
        fireworksParticleSystem.particleColor = color

        let addFireworkAction = SCNAction.run { [weak self] _ in
            guard let fireworksParticleSystem = self?.fireworksParticleSystem, let node = self?.node else {
                print("addFireworkAction - RETURNED")
                return
                
            }
            self?.rootNode.addChildNode(node)
            self?.node.addParticleSystem(fireworksParticleSystem)
        }
        
        let lifeSpan = fireworksParticleSystem.particleLifeSpan
        let waitExplosionAction = SCNAction.wait(duration: TimeInterval(lifeSpan))
        
        let removeFireworkAction = SCNAction.run { [weak self] _ in
            guard let node = self?.node else {
                print("removeFireworkAction - RETURNED")
                return
            }
            node.removeAllParticleSystems()
            node.removeFromParentNode()
        }
        
        let actionSequence = SCNAction.sequence([addFireworkAction, waitExplosionAction, removeFireworkAction])
        
        return actionSequence
    }
}

class FireworkPlayer {
    let colors: [UIColor]
    let rootNode: SCNNode
    let boundingBox: (min: SCNVector3, max: SCNVector3)
    let maxSimultaneousFireworks: Int
    
    private(set) var isPlaying: Bool = false
    static let actionKey = "fireworks"
    
    private var currentFireworks: [Firework] = []
    
    init(rootNode: SCNNode, boundingBox: (min: SCNVector3, max: SCNVector3), colors: [UIColor] = [], maxSimultaneousFireworks: Int) {
        self.colors = colors
        self.rootNode = rootNode
        self.boundingBox = boundingBox
        self.maxSimultaneousFireworks = maxSimultaneousFireworks
    }
    
    func play() {
        isPlaying = true
        rootNode.runAction(createFirework(maxAmount: 5), forKey: FireworkPlayer.actionKey) { [weak self] in
            self?.play()
        }
    }
    
    func stop() {
        rootNode.removeAction(forKey: FireworkPlayer.actionKey)
        isPlaying = false
    }
    
    private func createFirework(maxAmount: Int) -> SCNAction {
        currentFireworks = []
        let randomNumber = arc4random_uniform(UInt32(maxAmount)) + 1
        
        var actionArray: [SCNAction] = []
        for _ in 0..<randomNumber {
            let randomWait = CGFloat(arc4random()) / CGFloat(UINT32_MAX)
            let randomColor = colors.isEmpty ? UIColor.random() : colors[Int(arc4random_uniform(UInt32(colors.count)))]
            let currentFirework = Firework(rootNode: rootNode, boundingBox: boundingBox, color: randomColor)
            let waitAction = SCNAction.wait(duration: TimeInterval(randomWait))
            let createFireworkAction = currentFirework.createFireworkAction()
            let sequence = SCNAction.sequence([waitAction, createFireworkAction])
            currentFireworks.append(currentFirework)
            actionArray.append(sequence)
        }
        let actionGroup = SCNAction.group(actionArray)
        return actionGroup
        
    }
}
