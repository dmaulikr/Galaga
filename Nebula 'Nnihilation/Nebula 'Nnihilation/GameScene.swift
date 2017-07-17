import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var foreground: SKNode!
    var background: SKNode!
    var player: SKSpriteNode!
    var navcircle: SKSpriteNode!
    var backgroundImage1: SKSpriteNode!
    var backgroundImage2: SKSpriteNode!
    var enemyWaveTemplate: SKSpriteNode!
    var bulletLayer: SKNode!
    var scoreLabel: SKLabelNode!
    
    var moving = false
    var navcircleTouch: UITouch? = nil
    var lastTouchPosition: CGPoint? = nil
    let gameWidth = CGFloat(850)
    let gameHeight = CGFloat(1334)
    var frameCount = 0
    var playerWeapon1: PlayerWeapon = PlayerWeapon()
    var playerWeapon2: PlayerWeapon = PlayerWeapon()
    var score: Int {
        get {
            return Int(scoreLabel.text!)!
        }
        set (newValue) {
            scoreLabel.text = String(newValue)
        }
    }
    
    override func didMove(to view: SKView) {
        isUserInteractionEnabled = true
        foreground = childNode(withName: "Foreground")!
        background = childNode(withName: "Background")!
        player = foreground.childNode(withName: "Player") as! SKSpriteNode
        navcircle = player.childNode(withName: "Navcircle") as! SKSpriteNode
        backgroundImage1 = background.childNode(withName: "Background1") as! SKSpriteNode
        backgroundImage2 = background.childNode(withName: "Background2") as! SKSpriteNode
        let wave1 = SKScene(fileNamed: "Wave1")
        enemyWaveTemplate = wave1!.childNode(withName: "Overlay") as! SKSpriteNode
        bulletLayer = foreground.childNode(withName: "Bullets")!
        scoreLabel = childNode(withName: "Score") as! SKLabelNode
        physicsWorld.contactDelegate = self as SKPhysicsContactDelegate
        playerWeapon1.position = CGPoint(x: 35, y: 5)
        playerWeapon2.position = CGPoint(x: -35, y: 5)
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
        if (frameCount % playerWeapon1.fireRate == 0) {
            let bullet: SKEmitterNode = SKEmitterNode(fileNamed: playerWeapon1.filename)!
            bullet.position = CGPoint(x: player.position.x + playerWeapon1.position.x,
                                      y: player.position.y + playerWeapon1.position.y)
            bullet.name = playerWeapon1.bulletName
            bullet.physicsBody = SKPhysicsBody(circleOfRadius: 1)
            bullet.physicsBody?.affectedByGravity = false
            bullet.physicsBody?.categoryBitMask = UInt32(playerWeapon1.categoryMask)
            bullet.physicsBody?.contactTestBitMask = UInt32(playerWeapon1.contactMask)
            let bullet2 = bullet.copy() as! SKEmitterNode
            bullet2.position = CGPoint(x: player.position.x + playerWeapon2.position.x,
                                       y: player.position.y + playerWeapon2.position.y)
            bulletLayer.addChild(bullet)
            bulletLayer.addChild(bullet2)
            bullet.physicsBody?.applyImpulse(CGVector(dx: 0, dy: playerWeapon1.force))
            bullet2.physicsBody?.applyImpulse(CGVector(dx: 0, dy: playerWeapon1.force))
        }
        let waveSpawnInterval = 10 //seconds
        if (frameCount % (60 * waveSpawnInterval) == 0) {
            let tempNode = enemyWaveTemplate.copy() as! SKSpriteNode
            let moveDownwardsAction = SKAction.move(by: CGVector(dx: 0, dy: gameHeight * -2), duration: 20)
            let moveThenDelete = SKAction.sequence([moveDownwardsAction, SKAction.removeFromParent()])
            tempNode.run(moveThenDelete)
            foreground.addChild(tempNode)
        }
        backgroundImage1.position.y -= 3
        backgroundImage2.position.y -= 3
        if (backgroundImage1.position.y < gameHeight * -1) {
            backgroundImage1.position.y = backgroundImage2.position.y + gameHeight
        }
        if (backgroundImage2.position.y < gameHeight * -1) {
            backgroundImage2.position.y = backgroundImage1.position.y + gameHeight
        }
        frameCount += 1
    }
    func didBegin(_ contact: SKPhysicsContact) {
        if let body1 = contact.bodyA.node {
            if let body2 = contact.bodyB.node {
                if (body1.name == "Player" && body2.name == "Enemy"
                    || body2.name == "Player" && body1.name == "Enemy") {
                    restart()
                }
                if (body1.name == "PlayerBullet" && body2.name == "Barrier") {
                    body1.removeFromParent()
                } else if (body2.name == "PlayerBullet" && body1.name == "Barrier") {
                    body2.removeFromParent()
                }
                if (body1.name == "PlayerBullet" && body2.name == "Enemy") {
                    var health = body2.userData?.value(forKey: "health") as! Int
                    health -= playerWeapon1.damage
                    body2.userData?.setValue(health, forKey: "health")
                    if (health <= 0) {
                        body2.removeFromParent()
                    }
                    body1.removeFromParent()
                    score += playerWeapon1.damage
                } else if (body2.name == "PlayerBullet" && body1.name == "Enemy") {
                    var health = body1.userData?.value(forKey: "health") as! Int
                    health -= playerWeapon1.damage
                    body1.userData?.setValue(health, forKey: "health")
                    if (health <= 0) {
                        body1.removeFromParent()
                    }
                    body2.removeFromParent()
                    score += playerWeapon1.damage
                }
            }
        }
    }
    func restart() {
        player.position.x = 0
        player.position.y = -300
        foreground.removeAllChildren()
        bulletLayer.removeAllChildren()
        foreground.addChild(player)
        foreground.addChild(bulletLayer)
        score = 0
        navcircleTouch = nil
        moving = false
    }
}
