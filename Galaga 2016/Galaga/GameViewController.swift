import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    var skView : SKView = SKView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = StartGameState(size: view.bounds.size)
        scene.parentCtrl = self
        skView = view as! SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .ResizeFill
        scene.parentView = skView
        skView.presentScene(scene)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}