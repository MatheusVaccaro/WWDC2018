//
//  MovementQueue.swift
//  Hanoi
//
//  Created by Matheus Vaccaro on 21/03/18.
//  Copyright © 2018 Matheus Vaccaro. All rights reserved.
//

import Foundation
import SceneKit

class MovementSequencer {
    static let shared = MovementSequencer()
    var towerOfHanoi: TowerOfHanoi?
    var movementQueue: [Movement]
    
    private init() {
        self.movementQueue = []
    }
    
    func execute(movements: [Movement]) {
        self.movementQueue = movements
        guard let movement = movements.first, let towerOfHanoi = self.towerOfHanoi else { return }
        self.movementQueue.remove(at: 0)
        switch movement {
        case let .moveTopDisk(from: sourcePeg,to: targetPeg):
            towerOfHanoi.moveTopDisk(fromPeg: sourcePeg,
                                     toPeg: targetPeg,
                                     duration: 1.0,
                                     completionHandler: { [unowned self] in
                                        self.execute(movements: self.movementQueue)
            })
            
        }
    }
}

enum Movement {
    case moveTopDisk(from: Int, to: Int)
}
