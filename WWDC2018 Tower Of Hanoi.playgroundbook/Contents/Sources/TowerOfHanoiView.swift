//
//  TowerOfHanoiView.swift
//  Hanoi
//
//  Created by Matheus Vaccaro on 23/03/18.
//  Copyright © 2018 Matheus Vaccaro. All rights reserved.
//

import Foundation
import SceneKit
import PlaygroundSupport

open class TowerOfHanoiView: SCNView {
    public override init(frame: CGRect, options: [String : Any]? = nil) {
        super.init(frame: frame, options: options)
        _setup()
    }
    
    public init(frame: CGRect, numberOfDisks: Int, numberOfRods: Int) {
        self.numberOfDisks = numberOfDisks
        self.numberOfRods = numberOfRods
        super.init(frame: frame, options: nil)
        _setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
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
    
    var soundNode: SCNNode!
    var isPlayingBGM: Bool = false {
        didSet {
            isPlayingBGM ? playBGM() : stopBGM()
        }
    }
    
    private static let backgroundMusic: String = "backgroundMusic.wav"
    private static let bgmKey: String = "bgmKey"
    
    private func _setup() {
        setupView()
        setupScene()
        setupBGM()
        setupTowerOfHanoi(numberOfDisks: numberOfDisks, numberOfPegs: numberOfRods)
        setupTowerOfHanoiChecker()
        setupCamera()
        setupNumberOfMovesIndicator()
        setupTapRecognizer()
        setupMovementSequencer()
        setupFireworks()
    }
    
    fileprivate func setupView() {
        showsStatistics = true
        allowsCameraControl = true
        autoenablesDefaultLighting = true
        isPlaying = true
    }
    
    fileprivate func setupScene() {
        scnScene = SCNScene(named: "SkyScene.scn")
        scene = scnScene
    }
    
    fileprivate func setupBGM() {
        soundNode = SCNNode()
        scnScene.rootNode.addChildNode(soundNode)
        isPlayingBGM = true
    }
    
    fileprivate func setupNumberOfMovesIndicator() {
        self.numberOfMovesIndicator = NumberOfMovesIndicator(towerOfHanoi: self.towerOfHanoi)
    }
    
    fileprivate func setupTowerOfHanoi(numberOfDisks nDisks: Int, numberOfPegs nPegs: Int) {
        self.towerOfHanoi = TowerOfHanoi(numberOfDisks: nDisks, numberOfPegs: nPegs)
        scnScene.rootNode.addChildNode(towerOfHanoi.node)
    }
    
    fileprivate func setupTowerOfHanoiChecker() {
        self.towerOfHanoiChecker = TowerOfHanoiChecker(towerOfHanoi: self.towerOfHanoi)
    }
    
    fileprivate func setupCamera() {
        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = cameraPositionToSeeObject(withWidth: towerOfHanoi.base.width)
        cameraNode.eulerAngles = SCNVector3(x: -Float.pi / 4, y: 0, z: 0)
        scnScene.rootNode.addChildNode(cameraNode)
    }
    
    fileprivate func cameraPositionToSeeObject(withWidth width: CGFloat) -> SCNVector3 {
        let optimalHeightAndWidth: CGFloat = 10
        let optimalObjectWidth: CGFloat = 19.5
        
        let targetHeightAndWidth = optimalHeightAndWidth * width / optimalObjectWidth
        return SCNVector3(0, targetHeightAndWidth + 2, targetHeightAndWidth - 1)
    }
    
    fileprivate func setupTapRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        addGestureRecognizer(tapGesture)
    }
    
    fileprivate func setupMovementSequencer() {
        MovementSequencer.shared.delegate = self
        MovementSequencer.shared.towerOfHanoi = towerOfHanoi
    }
    
    fileprivate func setupFireworks() {
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
    
    private func playBGM() {
        let audioSource = SCNAudioSource(fileNamed: TowerOfHanoiView.backgroundMusic)!
        audioSource.volume = 0.35
        let audioAction = SCNAction.playAudio(audioSource, waitForCompletion: true)
        let repeatForever = SCNAction.repeatForever(audioAction)
        soundNode.runAction(repeatForever, forKey: TowerOfHanoiView.bgmKey)
    }
    
    private func stopBGM() {
        soundNode.removeAction(forKey: TowerOfHanoiView.bgmKey)
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
        guard case let .moveTopDisk(source, target) = movement else { return }
        let sourceRod = towerOfHanoi.pegs[source]
        if !numberOfMovesIndicator.didCompleteTowerOfHanoi && sourceRod.diskStack.count != 0 && source != target {
            numberOfMovesIndicator.numberOfMoves += 1
        }
    }
}

var movementSequence: [Movement] = []
extension TowerOfHanoiView: PlaygroundLiveViewMessageHandler {
    
    public func receive(_ message: PlaygroundValue) {
        switch message {
        case .dictionary:
            guard case let .dictionary(dict) = message else { return }
            guard case let .string(title)? = dict["title"] else { return }
            if title == "moves" {
                guard case let .integer(sourceRod)? = dict["sourceRod"] else { return }
                guard case let .integer(targetRod)? = dict["targetRod"] else { return }
                movementSequence.append(Movement.moveTopDisk(from: sourceRod, to: targetRod))
            } else if title == "towerUpdate" {
                guard case let .integer(nRods)? = dict["nRods"] else { return }
                guard case let .integer(nDisks)? = dict["nDisks"] else { return }
                if nRods != towerOfHanoi.pegs.count || nDisks != towerOfHanoi.numberOfDisks {
                    self.numberOfRods = nRods
                    self.numberOfDisks = nDisks
                    
                    towerOfHanoi.node.removeAllActions()
                    towerOfHanoi.node.removeFromParentNode()
                    towerOfHanoi = nil
                    sourcePeg = nil
                    targetPeg = nil
                    cameraNode.removeFromParentNode()

                    setupTowerOfHanoi(numberOfDisks: numberOfDisks, numberOfPegs: numberOfRods)
                    setupTowerOfHanoiChecker()
                    setupCamera()
                    setupNumberOfMovesIndicator()
                    setupTapRecognizer()
                    setupMovementSequencer()
                    setupFireworks()
                }
            }
            
        case .string:
            guard case let .string(command) = message else { return }
            if command == "executeMoves" {
                towerOfHanoi.node.removeAllActions()
                towerOfHanoi.node.removeFromParentNode()
                towerOfHanoi = nil
                sourcePeg = nil
                targetPeg = nil
                
                setupTowerOfHanoi(numberOfDisks: numberOfDisks, numberOfPegs: numberOfRods)
                setupTowerOfHanoiChecker()
                setupNumberOfMovesIndicator()
                setupTapRecognizer()
                setupMovementSequencer()
                setupFireworks()
                
                MovementSequencer.shared.execute(movements: movementSequence)
                movementSequence = []
            }
        default:
            return
        }
        
    }

}

