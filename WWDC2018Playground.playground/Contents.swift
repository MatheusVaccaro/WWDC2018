class IntroductionView: TowerOfHanoiView {
    
    let numberOfDisks = 3
    let numberOfPegs = 3
    
    let moves: [Movement] = [
        .moveTopDisk(from: 0, to: 2),
        .moveTopDisk(from: 0, to: 1),
        .moveTopDisk(from: 2, to: 1),
        .moveTopDisk(from: 0, to: 2),
        .moveTopDisk(from: 1, to: 0),
        .moveTopDisk(from: 1, to: 2),
        .moveTopDisk(from: 0, to: 2)
    ]
    
    
    override func numberOfDisksForTower() -> Int {
        return numberOfDisks
    }
    
    override func numberOfPegsForTower() -> Int {
        return numberOfPegs
    }
    
    override func setup() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            MovementSequencer.shared.execute(movements: self.moves)
        }
    }
}



import Foundation
import PlaygroundSupport
import SceneKit

let rect = CGRect(x: 0, y: 0, width: 500, height: 600)
let towerOfHanoiView = IntroductionView(frame: rect)
PlaygroundSupport.PlaygroundPage.current.liveView = towerOfHanoiView
