//
//  TowerOfHanoiView.swift
//  Hanoi
//
//  Created by Matheus Vaccaro on 23/03/18.
//  Copyright © 2018 Matheus Vaccaro. All rights reserved.
//

import Foundation
import SceneKit

class TowerOfHanoiView: SCNView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override init(frame: CGRect, options: [String : Any]? = nil) {
        super.init(frame: frame, options: options)
        setup()
    }
    
    init(frame: CGRect, rods: Int, disks: Int) {
        self.numberOfDisks = disks
        self.numberOfRods = rods
        super.init(frame: frame, options: nil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var scnScene: SCNScene!
    var cameraNode: SCNNode!
    var numberOfMovesIndicator: NumberOfMovesIndicator!
    
    var towerOfHanoi: TowerOfHanoi!
    var towerOfHanoiChecker: TowerOfHanoiChecker!
    var didCompleteTowerOfHanoi: Bool = false
    
    var sourcePeg: Peg?
    var targetPeg: Peg?
    
    var fireworks: FireworkPlayer!
    
    var numberOfDisks: Int! = 3
    var numberOfRods: Int! = 3
    
    private func setup() {
        setupView()
        setupScene()
        setupTowerOfHanoi(numberOfDisks: numberOfDisks, numberOfPegs: numberOfRods)
        setupTowerOfHanoiChecker()
        setupCamera()
        setupNumberOfMovesIndicator()
        setupTapRecognizer()
        setupFireworks()
        
        
        MovementSequencer.shared.delegate = self
        MovementSequencer.shared.towerOfHanoi = towerOfHanoi
        
        let moves: [Movement] = [
            .moveTopDisk(from: 0, to: 0)
        ]
        
        MovementSequencer.shared.execute(movements: moves)
    }
    
    private func setupView() {
        showsStatistics = true
        allowsCameraControl = true
        autoenablesDefaultLighting = true
        isPlaying = true
    }
    
    private func setupScene() {
        scnScene = SCNScene(named: "art.scnassets/SkyScene.scn")
        scene = scnScene
    }
    
    private func setupNumberOfMovesIndicator() {
        self.numberOfMovesIndicator = NumberOfMovesIndicator(towerOfHanoi: self.towerOfHanoi)
    }
    
    private func setupTowerOfHanoi(numberOfDisks nDisks: Int, numberOfPegs nPegs: Int) {
        self.towerOfHanoi = TowerOfHanoi(numberOfDisks: nDisks, numberOfPegs: nPegs)
        towerOfHanoi.isPlayingBGM = true
        scnScene.rootNode.addChildNode(towerOfHanoi.node)
    }
    
    private func setupTowerOfHanoiChecker() {
        self.towerOfHanoiChecker = TowerOfHanoiChecker(towerOfHanoi: self.towerOfHanoi)
    }
    
    private func setupCamera() {
        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = cameraPositionToSeeObject(withWidth: towerOfHanoi.base.width)
        
        cameraNode.eulerAngles = SCNVector3(x: -Float.pi / 4, y: 0, z: 0)
        scnScene.rootNode.addChildNode(cameraNode)
    }
    
    private func cameraPositionToSeeObject(withWidth width: CGFloat) -> SCNVector3 {
        let optimalHeightAndWidth: CGFloat = 9
        let optimalObjectWidth: CGFloat = 19.5
        
        let targetHeightAndWidth = optimalHeightAndWidth * width / optimalObjectWidth
        return SCNVector3(0, targetHeightAndWidth + 2, targetHeightAndWidth - 1)
    }
    
    private func setupTapRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        addGestureRecognizer(tapGesture)
    }
    
    private func setupFireworks() {
        let basePosition = towerOfHanoi.base.node.position
        let boundingBoxMin = SCNVector3(basePosition.x - Float(towerOfHanoi.base.width / 2),
                                        basePosition.y + Float(towerOfHanoi.base.height + towerOfHanoi.pegs[0].height),
                                        basePosition.z - Float(towerOfHanoi.base.length / 2))
        let boundingBoxMax = SCNVector3(basePosition.x + Float(towerOfHanoi.base.width / 2),
                                        basePosition.y + Float((towerOfHanoi.base.height + towerOfHanoi.pegs[0].height) * 2),
                                        basePosition.z + Float(towerOfHanoi.base.length / 2))
        self.fireworks = FireworkPlayer(rootNode: scnScene.rootNode, boundingBox: (min: boundingBoxMin, max: boundingBoxMax), maxSimultaneousFireworks: 5, maxFireworkRadius: CGFloat(0.3 * Float(towerOfHanoi.numberOfDisks)))
    }
    
    private func updateManipulatablePegs(touchedHitbox hitbox: Hitbox) {
        guard let selectedPeg = hitbox.associatedObject as? Peg else { return }
        if let sourcePeg = self.sourcePeg {
            if selectedPeg === sourcePeg {
                //print("Unselecting source peg \(selectedPeg.index)")
                self.sourcePeg?.isSelected = false
                self.sourcePeg?.playDeselectedSound()
                self.sourcePeg = nil
                return
            }
            self.targetPeg = selectedPeg
            //print("Setting peg \(selectedPeg.index) as target peg")
            
            let movement: [Movement] = [.moveTopDisk(from: self.sourcePeg!.index, to: self.targetPeg!.index)]
            MovementSequencer.shared.execute(movements: movement)
            self.sourcePeg?.isSelected = false
            self.sourcePeg = nil
            self.targetPeg?.isSelected = false
            self.targetPeg = selectedPeg
            //print("Setting source and target pegs to nil")
        } else {
            if !selectedPeg.diskStack.isEmpty {
                self.sourcePeg = selectedPeg
                self.sourcePeg?.isSelected = true
                self.sourcePeg?.playSelectedSound()
                //print("Setting peg \(selectedPeg.index) as source peg")
            }
        }
    }
    
    @objc
    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        // check what nodes are tapped
        let p = gestureRecognize.location(in: self)
        let hitResults = hitTest(p, options: [:])
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            // retrieved the first clicked object
            guard let hitbox = hitResults[0].node as? Hitbox, !MovementSequencer.shared.isExecuting else { return }
            updateManipulatablePegs(touchedHitbox: hitbox)
        }
    }
}

extension TowerOfHanoiView: MovementSequencerDelegate {
    func didExecuteMovement(_ movement: Movement) {
        let check = towerOfHanoiChecker.check()
        if check && !didCompleteTowerOfHanoi {
            numberOfMovesIndicator.didCompleteTowerOfHanoi = check
            towerOfHanoi.playVictorySound()
            fireworks.play()
        }
        didCompleteTowerOfHanoi = check
    }
    
    func willExecuteMovement(_ movement: Movement) {
        if !numberOfMovesIndicator.didCompleteTowerOfHanoi {
            numberOfMovesIndicator.numberOfMoves += 1
        }
    }
}
