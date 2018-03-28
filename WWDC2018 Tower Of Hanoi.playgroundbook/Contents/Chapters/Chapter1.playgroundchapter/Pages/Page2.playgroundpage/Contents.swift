/*:
 In the previous page, you played with the classical Tower of Hanoi puzzle, which consists of 3 rods and a stack of 3 disks. 
 
 
 
 
 
 
 
 
 
 - Important:
 The greater the number of disks in a stack, the harder the puzzle gets.
 \
 The greater the number of rods, the easier the puzzle gets.
 
 # Tower of Hanoi
 
 Wait a minute... Tower of Who? Who is Hanoi? Why does he have a tower? Don't worry, we'll learn about that in this playground!
 
 **Tower of Hanoi** is a puzzle invented by a French mathematician called Édouard Lucas in 1883, which consists of a **number of rods** and a **stack of disks** in ascending order.
 
 * Callout(Story Time):
 Legends say this puzzle was inspired from a story about a temple in Hanoi (Vietnam) which contains a large room with 3 time-worn rods surrounded by 64 golden disk. The monks of the temple have been moving these disk according to an ancient prophecy and, when the last move of the puzzle is made, the world will end.😱
 
 Now that's what I call a nice backstory!😎
 
 # Objective and Rules
 
 In order to solve Tower of Hanoi, your goal is to move the disk stack from the initial rod to any of the other rods in the least amount of steps possible, respecting the following rules:
 
 1. Only one disk can be moved at a time.
 2. Only the top disk of a stack can be moved.
 3. Larger disks can not be placed on top of smaller disks.
 4. Disks can be placed on empty rods.
 
 Don't worry, neither will your iPad stop working nor will the world end when you move the last piece!😅
 
 # Interacting with the Puzzle
 
 In order to move a disk from a rod to another, all you need to do is:
 1. Press the rod you want to move the disk from. The top disk will glow indicating it's selected.
 2. Press the rod you want to move the disk to.
 
 *If you want to unselect the disk, just press the rod again.*
 
 Since the classic configuration of this puzzle is 3 rods with a stack of 3 disks, that's what we are going to use. Try pressing "Run my Code" to see what the puzzle looks like.
 */
//#-hidden-code
var movementSequencerMoves: [Movement] = []

func moveTopDisk(fromRod sourceRod: Int, toRod targetRod: Int) {
    let move: Movement = Movement.moveTopDisk(from: sourceRod, to: targetRod)
    movementSequencerMoves.append(move)
}
//#-end-hidden-code
let numberOfDisks = /*#-editable-code*/3/*#-end-editable-code*/
let numberOfRods = /*#-editable-code*/3/*#-end-editable-code*/
//#-code-completion(everything, hide)
//#-code-completion(description, show, "moveTopDisk(fromRod: Int, toRod: Int)")
//#-editable-code Tap to enter code

//#-end-editable-code


//#-hidden-code
class IntroductionView: TowerOfHanoiView {
    
    override func numberOfDisksForTower() -> Int {
        return numberOfDisks
    }
    
    override func numberOfPegsForTower() -> Int {
        return numberOfRods
    }
    
    override func setup() {
        if movementSequencerMoves.count != 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                MovementSequencer.shared.execute(movements: movementSequencerMoves)
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

