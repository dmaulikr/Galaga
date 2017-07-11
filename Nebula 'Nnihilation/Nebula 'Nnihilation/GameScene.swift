import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var foreground: SKNode!
    var background: SKNode!
    var player: SKSpriteNode!
    var navcircle: SKSpriteNode!
    var backgroundImage1: SKSpriteNode!
    var backgroundImage2: SKSpriteNode!
    
    var moving = false
    var navcircleTouch: UITouch? = nil
    var lastTouchPosition: CGPoint? = nil
    let gameWidth = CGFloat(850)
    let gameHeight = CGFloat(1334)
    
    override func didMove(to view: SKView) {
        isUserInteractionEnabled = true
        foreground = childNode(withName: "Foreground")!
        background = childNode(withName: "Background")!
        player = foreground.childNode(withName: "Player") as! SKSpriteNode
        navcircle = player.childNode(withName: "Navcircle") as! SKSpriteNode
        backgroundImage1 = background.childNode(withName: "Background1") as! SKSpriteNode
        backgroundImage2 = background.childNode(withName: "Background2") as! SKSpriteNode
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchPosition = touch.location(in: self)
            let touchPositionInPlayerFrame = convert(touchPosition, to: player)
            if (navcircle.frame.contains(touchPositionInPlayerFrame) && !moving) {
                lastTouchPosition = touchPosition
                navcircleTouch = touch;
                moving = true;
            }
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchPosition = touch.location(in: self)
            if (moving && touch.isEqual(navcircleTouch)) {
                //Move the player by as much as the finger's moved, then reset the baseline
                player.position.x = player.position.x - (lastTouchPosition!.x - touchPosition.x)
                player.position.y = player.position.y - (lastTouchPosition!.y - touchPosition.y)
                lastTouchPosition = touchPosition;
            }
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if (moving && touch.isEqual(navcircleTouch)) {
                navcircleTouch = nil
                moving = false
            }
        }
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if (moving && touch.isEqual(navcircleTouch)) {
                navcircleTouch = nil
                moving = false
            }
        }
    }
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        backgroundImage1.position.y -= 3
        backgroundImage2.position.y -= 3
        if (backgroundImage1.position.y < gameHeight * -1) {
            backgroundImage1.position.y = backgroundImage2.position.y + gameHeight
        }
        if (backgroundImage2.position.y < gameHeight * -1) {
            backgroundImage2.position.y = backgroundImage1.position.y + gameHeight
        }
    }
}
