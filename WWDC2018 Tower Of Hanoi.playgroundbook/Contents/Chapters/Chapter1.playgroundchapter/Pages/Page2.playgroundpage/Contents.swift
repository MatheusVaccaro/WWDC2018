/*:
 # Play Time!
 
 Congratulations! 🎉 Now that you know everything about the Tower of Hanoi, it's time to play!
 
 You can use this page to create your own versions of the puzzle with any number of rods and disk stack sizes you want!
 
 - Important:
 The greater the number of disks in a stack, the harder the puzzle gets.
 \
The greater the number of rods, the easier the puzzle gets.
 
 Just remember, if you build the tower with 3 rods, the minimal number of moves required to solve it is given by the equation
 
 * Callout(Equation):
 `Minimal Number of Moves = 2ˆ(Number of Disks) - 1`
 
 So... considering that, if you set the number of disks in the stack to 7, you'll be making at least 127 moves...
 
 **Have Fun!** 😁
 
 Ahh! And one more thing! If you are wondering what are the moves to solve the Tower of Hanoi, I have compiled some solutions for you in the **Solutions Chapter**. 😉
*/
//#-hidden-code
var _movementSequencerMoves: [Movement] = []

func moveTopDisk(fromRod sourceRod: Int, toRod targetRod: Int) {
    let move: Movement = Movement.moveTopDisk(from: sourceRod, to: targetRod)
    _movementSequencerMoves.append(move)
}

var numberOfRods = 3
var numberOfDisks = 3

//#-end-hidden-code
//#-code-completion(everything, hide)
// The number of rods the puzzle will have.
// Choose a number greater than 3, or the puzzle won't be solvable.
numberOfRods = /*#-editable-code*/3/*#-end-editable-code*/

// Determines how many disks will be stacked on the first rod.
// For best results, choose a number between 3 and 7.
numberOfDisks = /*#-editable-code*/3/*#-end-editable-code*/

//#-code-completion(description, show, "moveTopDisk(fromRod: Int, toRod: Int)")
// Here you can type the commands you want the tower to make, just remember that you can always interact with the puzzle by touching the rods.
//#-editable-code Tap to enter movement sequence

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


