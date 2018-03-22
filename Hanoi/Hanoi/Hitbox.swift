//
//  Hitbox.swift
//  Hanoi
//
//  Created by Matheus Vaccaro on 22/03/18.
//  Copyright © 2018 Matheus Vaccaro. All rights reserved.
//

import UIKit
import SceneKit

class Hitbox: SCNNode {
    let associatedObject: Any
    
    init(width: CGFloat, height: CGFloat, length: CGFloat, associatedObject: Any) {
        self.associatedObject = associatedObject
        let box = SCNBox(width: width, height: height, length: length, chamferRadius: 0)
        box.firstMaterial?.diffuse.contents = UIColor(red: 1, green: 0, blue: 0, alpha: 0.3)
        super.init()
        self.geometry = box
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
