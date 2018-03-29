//#-hidden-code
var _movementSequencerMoves: [Movement] = []

func moveTopDisk(fromRod sourceRod: Int, toRod targetRod: Int) {
    let move: Movement = Movement.moveTopDisk(from: sourceRod, to: targetRod)
    _movementSequencerMoves.append(move)
}

var numberOfRods = 4
var numberOfDisks = 4

//#-end-hidden-code
/*:
 # Solutions
 
 In this page you'll learn the moves you need to make in order to solve the Tower of Hanoi puzzle with **4 rods** and a **stack of 4 disks**.
 
 - Note:
 There can be more than one solution for the puzzle based on its configuration.
 
 Tap "Run My Code" to see what the solution looks like.
*/
// Sequence of moves to solve the puzzle
moveTopDisk(fromRod: 0, toRod: 2)
moveTopDisk(fromRod: 0, toRod: 1)
moveTopDisk(fromRod: 2, toRod: 1)
moveTopDisk(fromRod: 0, toRod: 2)
moveTopDisk(fromRod: 0, toRod: 3)
moveTopDisk(fromRod: 2, toRod: 3)
moveTopDisk(fromRod: 1, toRod: 2)
moveTopDisk(fromRod: 1, toRod: 3)
moveTopDisk(fromRod: 2, toRod: 3)

//#-hidden-code
class IntroductionView: TowerOfHanoiView {
    
    override func numberOfDisksForTower() -> Int {
        return numberOfDisks
    }
    
    override func numberOfPegsForTower() -> Int {
        return numberOfRods
    }
    
    override func setup() {
        if _movementSequencerMoves.count != 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                MovementSequencer.shared.execute(movements: _movementSequencerMoves)
            }
        }
    }
}

import Foundation
import PlaygroundSupport
import SceneKit

let rect = CGRect(x: 0, y: 0, width: 500, height: 600)
let towerOfHanoiView = IntroductionView(frame: rect)
PlaygroundSupport.PlaygroundPage.current.liveView = towerOfHanoiView
//#-end-hidden-code


