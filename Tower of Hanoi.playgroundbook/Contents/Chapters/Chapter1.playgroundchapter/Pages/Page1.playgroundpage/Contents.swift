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
 # Tower of Hanoi
 
 Wait a minute... Tower of Who? Who is Hanoi? Why does he have a tower? Don't worry, we'll learn about that in this playground!
     
 **Tower of Hanoi** is a [puzzle](glossary://puzzle) invented by a French mathematician called Édouard Lucas in 1883, which consists of a **number of rods** and a **stack of disks** in [descending order](glossary://descending_order).
 
 * Callout(Story Time):
 Legends say this puzzle was inspired from a story about a temple in Hanoi (Vietnam) which contains a large room with 3 time-worn rods surrounded by 64 golden disks. The monks of the temple have been moving these disks according to an ancient prophecy and, when the last move of the puzzle is made, the world will end. 😱
     
 Now that's what I call a nice backstory! 😎
 
---
 
 # Objective and Rules
 
 In order to solve the **Tower of Hanoi**, your **goal** is:
 
 Move the disk stack from the [**initial rod**](glossary://initial_rod) to **any of the other rods** in the least amount of steps possible, respecting the following **rules**:
 
 1. Only the top disk of a stack can be moved.
 2. Only one disk can be moved at a time.
 3. Larger disks cannot be placed on top of smaller disks.
 4. Disks can be placed on empty rods.
 
 Don't worry, neither will your iPad stop working nor will the world end when you move the last piece! 😅
 
---
 
 # Interacting with the Puzzle
 
 In order to move a disk from a rod to another, all you need to do is:
 1. **Tap** the rod you want to move the disk from. The top disk will glow indicating it's selected.
 2. **Tap** the rod you want to move the disk to.
 * Callout(Tip):
 To deselect a disk, **tap** the rod again.
 
\
 Or you can **type** [commands](glossary://command) at the end of this page to move the disks.
 
 - Callout(Example): *Moving disks between rods.*\
This example shows the command you can use to move the disk at the top of the **first rod** to the **third rod**. \
 \
 `moveTopDisk(fromRod: 0, toRod: 2)`
 
 Try playing with the puzzle. After you're done, go to the [next page](@next) to build your own version of Tower of Hanoi!
 
*/
//#-code-completion(everything, hide)
//#-code-completion(description, show, "moveTopDisk(fromRod: Int, toRod: Int)")
//#-editable-code Tap to enter code
//#-end-editable-code


//#-hidden-code
updateTower()
executeMoves()
//#-end-hidden-code

