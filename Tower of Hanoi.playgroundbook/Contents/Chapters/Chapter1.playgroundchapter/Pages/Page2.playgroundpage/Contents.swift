//#-hidden-code
import PlaygroundSupport

let page = PlaygroundPage.current
let proxy = page.liveView as? PlaygroundRemoteLiveViewProxy

var numberOfRods = 3
var numberOfDisks = 3

func updateTower() {
    let dict = ["title" : PlaygroundValue.string("towerUpdate"),
                "nRods" : PlaygroundValue.integer(numberOfRods),
                "nDisks": PlaygroundValue.integer(numberOfDisks)]
    proxy?.send(PlaygroundValue.dictionary(dict))
}

func moveTopDisk(fromRod sourceRod: Int, toRod targetRod: Int) {
    let dict = ["title" : PlaygroundValue.string("moves"),
                "sourceRod" : PlaygroundValue.integer(sourceRod),
                "targetRod": PlaygroundValue.integer(targetRod)]
    proxy?.send(PlaygroundValue.dictionary(dict))
}

func executeMoves() {
    let string = PlaygroundValue.string("executeMoves")
    proxy?.send(string)
}

func clearMovementQueue() {
    let string = PlaygroundValue.string("clearMovementQueue")
    proxy?.send(string)
}

clearMovementQueue()
//#-end-hidden-code
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
//#-code-completion(everything, hide)
// The number of rods the puzzle will have.
// Choose a number greater than 3, or the puzzle won't be solvable.
numberOfRods = /*#-editable-code*/3/*#-end-editable-code*/

// Determines how many disks will be stacked on the first rod.
// For best results, choose a number between 3 and 7.
numberOfDisks = /*#-editable-code*/3/*#-end-editable-code*/

//#-code-completion(description, show, "moveTopDisk(fromRod: Int, toRod: Int)")
// Here you can type the commands you want the tower to make, just remember that you can interact with the puzzle by touching the rods too.
//#-editable-code Tap to enter code
//#-end-editable-code


//#-hidden-code
updateTower()
executeMoves()
//#-end-hidden-code


