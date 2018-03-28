//
//  Disk.swift
//  Hanoi
//
//  Created by Matheus Vaccaro on 20/03/18.
//  Copyright © 2018 Matheus Vaccaro. All rights reserved.
//

import Foundation
import SceneKit

class Disk {
    let node: SCNNode
    let outerRadius: CGFloat
    let innerRadius: CGFloat = Disk.innerRadius
    let color: UIColor
    let height: CGFloat = Disk.height
    
    var isSelected: Bool {
        didSet {
            if oldValue != isSelected {
                isSelected ? addParticles() : removeParticles()
            }
        }
    }
    
    static let height: CGFloat = 1
    static let innerRadius: CGFloat = Peg.outerRadius
    
    var relativeMaxY: Float {
        return node.position.y + Float(height / 2)
    }
    var relativeMinY: Float {
        return node.position.y - Float(height / 2)
    }
    
    init(outerRadius: CGFloat) {
        self.isSelected = false
        self.outerRadius = outerRadius
        
        let colorAndDiffuse = Disk.generateDiskColorAndDiffuse(forOuterRadius: outerRadius)
        let color = colorAndDiffuse.0
        let diffuse = colorAndDiffuse.1
        
        self.color = color
        
        let disk = SCNTube(innerRadius: Disk.innerRadius, outerRadius: outerRadius, height: height)
        disk.firstMaterial?.diffuse.contents = diffuse
        
        self.node = SCNNode(geometry: disk)
    }
    
    private static func generateDiskColorAndDiffuse(forOuterRadius radius: CGFloat) -> (UIColor, Any) {
        let path = "art.scnassets/"
        switch radius.truncatingRemainder(dividingBy: 7) {
        case 0...1:
            return (UIColor.red, path + "redWoodTexture.png")
        case 1...2:
            return (UIColor.orange, path + "orangeWoodTexture.png")
        case 2...3:
            return (UIColor.yellow, path + "yellowWoodTexture.png")
        case 3...4:
            return (UIColor.green, path + "greenWoodTexture.png")
        case 4...5:
            return (UIColor.cyan, path + "cyanWoodTexture.png")
        case 5...6:
            return (UIColor.blue, path + "blueWoodTexture.png")
        case 6...7:
            return (UIColor.magenta, path + "pinkWoodTexture.png")
        default:
            let random = UIColor.random()
            return (random, random)
        }
    }

    
    private func addParticles() {
        let particleSystemName = "SmokeParticleSystem.scnp"
        let bokehParticleSystem = SCNParticleSystem(named: particleSystemName, inDirectory: nil)
        bokehParticleSystem?.particleColor = self.color
        bokehParticleSystem?.emitterShape = self.node.geometry
        
        if let emitter = bokehParticleSystem {
            self.node.addParticleSystem(emitter)
        }
    }
    
    private func removeParticles() {
        self.node.removeAllParticleSystems()
    }
}
