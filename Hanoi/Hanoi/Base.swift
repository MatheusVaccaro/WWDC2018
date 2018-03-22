//
//  Base.swift
//  Hanoi
//
//  Created by Matheus Vaccaro on 21/03/18.
//  Copyright © 2018 Matheus Vaccaro. All rights reserved.
//

import Foundation
import SceneKit

class Base {
    let node: SCNNode
    let width: CGFloat
    let height: CGFloat
    let length: CGFloat
    
    var relativeMaxY: Float {
        return node.position.y + Float(height / 2)
    }
    var relativeMinY: Float {
        return node.position.y - Float(height / 2)
    }
    
    static let defaultHeight: CGFloat = 1
    
    init(forNumberOfDisks nDisks: Int, numberOfPegs nPegs: Int) {
        self.width = (CGFloat(nDisks * 2) + Disk.innerRadius) * CGFloat(nPegs)
        self.height = Base.defaultHeight
        self.length = (CGFloat(nDisks * 2) + Disk.innerRadius)
        
        let base = SCNBox(width: width, height: height, length: length, chamferRadius: 0)
//        base.firstMaterial?.diffuse.contents = UIColor.brown
        base.firstMaterial?.diffuse.contents = "art.scnassets/woodTexture1"
        self.node = SCNNode(geometry: base)
    }
    
    func positionForPegs(numberOfPegs nPegs: Int, numberOfDisks nDisks: Int) -> [SCNVector3] {
        let pegSectionWidth = CGFloat(nDisks * 2) + Disk.innerRadius
        let pegSectionInitialX = -width / 2 + pegSectionWidth / 2
        
        var positionVectors: [SCNVector3] = []
        
        for index in 0..<nPegs {
            let positionVector = SCNVector3(pegSectionInitialX + pegSectionWidth * CGFloat(index), 0, 0)
            positionVectors.append(positionVector)
        }
        
        return positionVectors
        
    }
}
