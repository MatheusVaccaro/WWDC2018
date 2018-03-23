//
//  TowerOfHanoiChecker.swift
//  Hanoi
//
//  Created by Matheus Vaccaro on 23/03/18.
//  Copyright © 2018 Matheus Vaccaro. All rights reserved.
//

import Foundation

class TowerOfHanoiChecker {
    private var numberOfDisks: Int
    private var initialPegIndex: Int
    private var pegs: [Peg]
    
    init(towerOfHanoi: TowerOfHanoi) {
        self.numberOfDisks = towerOfHanoi.numberOfDisks
        self.initialPegIndex = towerOfHanoi.initialPegIndex
        self.pegs = towerOfHanoi.pegs
    }
    
    func check() -> Bool {
        let otherPegs = pegs.filter {
            if $0 !== pegs[initialPegIndex] {
                return true
            } else {
                return false
            }
        }
        
        var didCompleteTowerOfHanoi = false
        otherPegs.forEach( {
            if $0.diskStack.count == numberOfDisks {
                didCompleteTowerOfHanoi = true
                return
            }
        })
        
        return didCompleteTowerOfHanoi
    }
}
