//#-hidden-code
import PlaygroundSupport

let page = PlaygroundPage.current
let proxy = page.liveView as? PlaygroundRemoteLiveViewProxy

var numberOfRods = 4
var numberOfDisks = 4

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
updateTower()
executeMoves()
//#-end-hidden-code


