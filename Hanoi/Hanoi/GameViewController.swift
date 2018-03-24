//
//  GameViewController.swift
//  Hanoi
//
//  Created by Matheus Vaccaro on 19/03/18.
//  Copyright © 2018 Matheus Vaccaro. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit
   
class GameViewController: UIViewController {
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    
    var scnView: SCNView!
    var scnScene: SCNScene!
    var cameraNode: SCNNode!
    var numberOfMovesIndicator: NumberOfMovesIndicator!
    
    var towerOfHanoi: TowerOfHanoi!
    var towerOfHanoiChecker: TowerOfHanoiChecker!
    var didCompleteTowerOfHanoi: Bool = false
    
    var sourcePeg: Peg?
    var targetPeg: Peg?
    
    private func setup() {
        setupView()
        setupScene()
        setupTowerOfHanoi(numberOfDisks: 3, numberOfPegs: 3)
        setupTowerOfHanoiChecker()
        setupCamera()
        setupNumberOfMovesIndicator()
        setupTapRecognizer()
        
        
        
        MovementSequencer.shared.delegate = self
        MovementSequencer.shared.towerOfHanoi = towerOfHanoi
        
        let moves: [Movement] = [
            .moveTopDisk(from: 0, to: 2),
            .moveTopDisk(from: 0, to: 1),
            .moveTopDisk(from: 2, to: 1),
            .moveTopDisk(from: 0, to: 2),
            .moveTopDisk(from: 1, to: 0),
            .moveTopDisk(from: 1, to: 2),
            .moveTopDisk(from: 0, to: 2)
        ]
        
        //        MovementSequencer.shared.execute(movements: moves)
    }
    
    private func setupView() {
        scnView = self.view as! SCNView
        scnView.showsStatistics = true
        scnView.allowsCameraControl = true
        scnView.autoenablesDefaultLighting = true
        scnView.isPlaying = true
    }
    
    private func setupScene() {
        scnScene = SCNScene()
        scnView.scene = scnScene
        scnView.backgroundColor = .black
    }
    
    private func setupNumberOfMovesIndicator() {
        self.numberOfMovesIndicator = NumberOfMovesIndicator(towerOfHanoi: self.towerOfHanoi)
    }
    
    private func setupTowerOfHanoi(numberOfDisks nDisks: Int, numberOfPegs nPegs: Int) {
        self.towerOfHanoi = TowerOfHanoi(numberOfDisks: nDisks, numberOfPegs: nPegs)
        scnScene.rootNode.addChildNode(towerOfHanoi.node)
    }
    
    private func setupTowerOfHanoiChecker() {
        self.towerOfHanoiChecker = TowerOfHanoiChecker(towerOfHanoi: self.towerOfHanoi)
    }
    
    private func setupCamera() {
        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 10, z: Float(self.towerOfHanoi.base.width / 2))
        cameraNode.eulerAngles = SCNVector3(x: -Float.pi / 4, y: 0, z: 0)
        scnScene.rootNode.addChildNode(cameraNode)
    }
    
    private func setupTapRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        scnView.addGestureRecognizer(tapGesture)
    }
    
    @objc
    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // check what nodes are tapped
        let p = gestureRecognize.location(in: scnView)
        let hitResults = scnView.hitTest(p, options: [:])
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            // retrieved the first clicked object
            guard let result = hitResults[0].node as? Hitbox, !MovementSequencer.shared.isExecuting else { return }
            
            // get its material
            let material = result.geometry!.firstMaterial!
            
            // highlight it
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            
            // on completion - unhighlight
            SCNTransaction.completionBlock = {
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.5
                
                material.emission.contents = UIColor.black
                
                SCNTransaction.commit()
            }
            
            material.emission.contents = UIColor.white
            
            SCNTransaction.commit()
            
            
            
            guard let selectedPeg = result.associatedObject as? Peg else { return }
            
            if let sourcePeg = self.sourcePeg {
                if selectedPeg === sourcePeg {
//                    print("Unselecting source peg \(selectedPeg.index)")
                    self.sourcePeg?.isSelected = false
                    self.sourcePeg = nil
                    return
                }
                
                
                self.targetPeg = selectedPeg
//                print("Setting peg \(selectedPeg.index) as target peg")
                
                
                let movement: [Movement] = [.moveTopDisk(from: self.sourcePeg!.index, to: self.targetPeg!.index)]
                MovementSequencer.shared.execute(movements: movement) 
                self.sourcePeg?.isSelected = false
                self.sourcePeg = nil
                self.targetPeg?.isSelected = false
                self.targetPeg = nil
//                print("Setting source and target pegs to nil")
                
                
                
            } else {
                if !selectedPeg.diskStack.isEmpty {
                    self.sourcePeg = selectedPeg
                    self.sourcePeg?.isSelected = true
//                    print("Setting peg \(selectedPeg.index) as source peg")
                }
            }
            
        }
    }
}

extension GameViewController: MovementSequencerDelegate {
    func didExecuteMovement(_ movement: Movement) {
        let check = towerOfHanoiChecker.check()
        if check && !didCompleteTowerOfHanoi {
            numberOfMovesIndicator.didCompleteTowerOfHanoi = check
        }
        didCompleteTowerOfHanoi = check
    }
    
    func willExecuteMovement(_ movement: Movement) {
        if !numberOfMovesIndicator.didCompleteTowerOfHanoi {
            numberOfMovesIndicator.numberOfMoves += 1
        }
    }
}
