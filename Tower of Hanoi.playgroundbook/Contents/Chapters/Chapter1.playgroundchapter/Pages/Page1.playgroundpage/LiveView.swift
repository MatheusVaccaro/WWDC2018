import Foundation
import SceneKit
import PlaygroundSupport


let rect = CGRect(x: 0, y: 0, width: 500, height: 600)
let towerOfHanoiView = TowerOfHanoiView(frame: rect, numberOfDisks: 3, numberOfRods: 3)
let page = PlaygroundPage.current

page.liveView = towerOfHanoiView
