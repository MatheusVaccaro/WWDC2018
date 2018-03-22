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
        
    var scnView: SCNView!
    var scnScene: SCNScene!
    var cameraNode: SCNNode!
    
    var towerOfHanoi: TowerOfHanoi!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupScene()
        setupCamera()
        
        self.towerOfHanoi = TowerOfHanoi(numberOfDisks: 3, numberOfPegs: 3)
        scnScene.rootNode.addChildNode(towerOfHanoi.node)
        
        MovementSequencer.shared.towerOfHanoi = towerOfHanoi
        
        let moves: [Movement] = [
            .moveTopDisk(from: 1, to: 3),
            .moveTopDisk(from: 1, to: 2),
            .moveTopDisk(from: 3, to: 2),
            .moveTopDisk(from: 1, to: 3),
            .moveTopDisk(from: 2, to: 1),
            .moveTopDisk(from: 2, to: 3),
            .moveTopDisk(from: 1, to: 3)
        ]
        
        MovementSequencer.shared.execute(movements: moves)
        
        // MARK: Greatest Gambi Ever Made
        let uselessNode = SCNNode()
        scnScene.rootNode.addChildNode(uselessNode)
        uselessNode.runAction(SCNAction.repeatForever(SCNAction.wait(duration: 1)))
        
        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        scnView.addGestureRecognizer(tapGesture)
        
    }
    
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
    
    private func setupCamera() {
        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 30)
        scnScene.rootNode.addChildNode(cameraNode)
    }
    
    private func setupView() {
        scnView = self.view as! SCNView
        scnView.showsStatistics = true
        scnView.allowsCameraControl = true
        scnView.autoenablesDefaultLighting = true
    }
    
    private func setupScene() {
        scnScene = SCNScene()
        scnView.scene = scnScene
        scnView.backgroundColor = .black
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
            let result = hitResults[0]
            
            // get its material
            let material = result.node.geometry!.firstMaterial!
            
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
        }
    }
}

