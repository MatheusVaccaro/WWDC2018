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
        let rect = self.view.frame
        self.view = TowerOfHanoiView(frame: rect, options: nil)
//        self.view = TowerOfHanoiARView(frame: rect, options: nil)
    }
    
}
