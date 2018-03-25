class IntroductionView: TowerOfHanoiView {
    override func numberOfDisks() -> Int {
        return 3
    }
    
    override func numberOfPegs() -> Int {
        return 3
    }
    
    override func setup() {
        let moves: [Movement] = [
            .moveTopDisk(from: 0, to: 2),
            .moveTopDisk(from: 0, to: 1),
            .moveTopDisk(from: 2, to: 1),
            .moveTopDisk(from: 0, to: 2),
            .moveTopDisk(from: 1, to: 0),
            .moveTopDisk(from: 1, to: 2),
            .moveTopDisk(from: 0, to: 2)
        ]
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [unowned self] in
            self._execute(movements: movements)
        }
    }
}



import Foundation
import PlaygroundSupport
import SceneKit

let rect = CGRect(x: 0, y: 0, width: 500, height: 600)
let towerOfHanoiView = IntroductionView(frame: rect)
PlaygroundSupport.PlaygroundPage.current.liveView = towerOfHanoiView
