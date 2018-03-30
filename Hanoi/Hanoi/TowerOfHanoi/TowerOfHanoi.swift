//
//  TowerOfHanoi.swift
//  Hanoi
//
//  Created by Matheus Vaccaro on 19/03/18.
//  Copyright © 2018 Matheus Vaccaro. All rights reserved.
//

import Foundation
import SceneKit

class TowerOfHanoi {
    let base: Base
    let node: SCNNode
    let pegs: [Peg]
    let initialPegIndex: Int
    let numberOfDisks: Int
    
    var isPlayingBGM: Bool = false {
        didSet {
            isPlayingBGM ? playBGM() : stopBGM()
        }
    }
    
    private static let backgroundMusic: String = "Menu3B.wav"
    private static let bgmKey: String = "bgmKey"
    private static let victorySound: String = "Menu3B.wav"
    
    init(numberOfDisks nDisks: Int, numberOfPegs nPegs: Int, initialPegIndex: Int = 0) {
        self.node = SCNNode()
        self.initialPegIndex = initialPegIndex
        self.numberOfDisks = nDisks
        
        self.base = Base(forNumberOfDisks: nDisks, numberOfPegs: nPegs)
        node.addChildNode(base.node)
        
        var pegs: [Peg] = []
        for index in 0..<nPegs {
            let peg = Peg(forNumberOfDisks: nDisks, base: base, index: index)
            node.addChildNode(peg.node)
            pegs.append(peg)
        }
        self.pegs = pegs
        
        place(numberOfDisks: nDisks, atPeg: initialPegIndex)
    }
    
    func moveTopDisk(fromPeg sourcePegIndex: Int, toPeg targetPegIndex: Int, completionHandler: (() -> Void)? = nil) {
        let sourcePeg = pegs[sourcePegIndex]
        let targetPeg = pegs[targetPegIndex]
        
        sourcePeg.moveTopDisk(to: targetPeg) {
            completionHandler?()
        }
    }
    
    func playVictorySound() {
        let audioSource = SCNAudioSource(fileNamed: TowerOfHanoi.victorySound)!
        let soundAction = SCNAction.playAudio(audioSource, waitForCompletion: false)
        node.runAction(soundAction)
    }
    
    private func place(numberOfDisks nDisks: Int, atPeg pegIndex: Int) {
        let peg = pegs[pegIndex]
        let range = (0..<nDisks).reversed()
        for diskNumber in range {
            let disk = Disk(outerRadius: CGFloat(diskNumber + 1))
            let positionVector: SCNVector3
            if peg.diskStack.isEmpty {
                positionVector = SCNVector3(peg.node.position.x, peg.relativeMinY + Float(disk.height / 2), peg.node.position.z)
            } else {
                positionVector = SCNVector3(peg.node.position.x, peg.diskStack.peek()!.relativeMaxY + Float(disk.height / 2), peg.node.position.z)
            }
            disk.node.position = positionVector
            node.addChildNode(disk.node)
            peg.diskStack.push(disk)
        }
    }
    
    private func playBGM() {
        let audioSource = SCNAudioSource(fileNamed: TowerOfHanoi.backgroundMusic)!
        let audioAction = SCNAction.playAudio(audioSource, waitForCompletion: true)
        let repeatForever = SCNAction.repeatForever(audioAction)
        node.runAction(repeatForever, forKey: TowerOfHanoi.bgmKey)
    }
    
    private func stopBGM() {
        node.removeAction(forKey: TowerOfHanoi.bgmKey)
    }
    
}



