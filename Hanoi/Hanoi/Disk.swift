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
    
    static let height: CGFloat = 1
    static let innerRadius: CGFloat = Peg.outerRadius
    
    var relativeMaxY: Float {
        return node.position.y + Float(height / 2)
    }
    var relativeMinY: Float {
        return node.position.y - Float(height / 2)
    }
    
    init(outerRadius: CGFloat, color: UIColor? = nil) {
        self.outerRadius = outerRadius
        
        if let color = color {
            self.color = color
        } else {
            self.color = Disk.generateDiskColor(forOuterRadius: outerRadius)
        }
        
        let disk = SCNTube(innerRadius: Disk.innerRadius, outerRadius: outerRadius, height: height)
        disk.firstMaterial?.diffuse.contents = self.color
        self.node = SCNNode(geometry: disk)
    }
    
    private static func generateDiskColor(forOuterRadius radius: CGFloat) -> UIColor {
        switch radius {
        case 0...1:
            return UIColor.red
        case 1...2:
            return UIColor.orange
        case 2...3:
            return UIColor.yellow
        case 3...4:
            return UIColor.green
        case 4...5:
            return UIColor.cyan
        case 5...6:
            return UIColor.blue
        case 6...7:
            return UIColor.magenta
        case 7...8:
            return UIColor.brown
        case 8...9:
            return UIColor.gray
        default:
            return UIColor.black
        }
    }
}