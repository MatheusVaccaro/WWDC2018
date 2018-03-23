//
//  MovementQueue.swift
//  Hanoi
//
//  Created by Matheus Vaccaro on 21/03/18.
//  Copyright © 2018 Matheus Vaccaro. All rights reserved.
//

import Foundation
import SceneKit

protocol MovementSequencerDelegate {
    func didExecuteMovement(_ movement: Movement)
}

class MovementSequencer {
    static let shared = MovementSequencer()
    var towerOfHanoi: TowerOfHanoi?
    var movementQueue: [Movement]
    var delegate: MovementSequencerDelegate?
    
    private(set) var isExecuting: Bool
    
    private var completionHandler: (() -> Void)?
    
    private init() {
        self.movementQueue = []
        self.isExecuting = false
    }
    
    func execute(movements: [Movement], completionHandler: (() -> Void)? = nil) {
        self.isExecuting = true
        self.completionHandler = completionHandler
        _execute(movements: movements)
        
    }
    
    
    private func _execute(movements: [Movement]) {
        self.movementQueue = movements
        guard let movement = movements.first, let towerOfHanoi = self.towerOfHanoi else {
            isExecuting = false
            self.completionHandler?()
            return
        }
        self.movementQueue.remove(at: 0)
        switch movement {
        case let .moveTopDisk(from: sourcePeg,to: targetPeg):
            towerOfHanoi.moveTopDisk(fromPeg: sourcePeg,
                                     toPeg: targetPeg,
                                     completionHandler: { [unowned self] in
                                        self.delegate?.didExecuteMovement(.moveTopDisk(from: sourcePeg, to: targetPeg))
                                        self._execute(movements: self.movementQueue)
            })
            
        }
    }
}

enum Movement {
    case moveTopDisk(from: Int, to: Int)
}
