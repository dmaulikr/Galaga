import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    static let gameWidth = CGFloat(850)
    static let gameHeight = CGFloat(1334)
    
    var foreground: SKNode!
    var background: SKNode!
    var player: SKSpriteNode!
    var navcircle: SKSpriteNode!
    var backgroundImage1: SKSpriteNode!
    var backgroundImage2: SKSpriteNode!
    var bulletLayer: SKNode!
    var scoreLabel: SKLabelNode!
    //The waveSequence to step through in update. Set in didMove.
    var currentWaveSequence: WaveSequence?
    
    var moving = false
    var navcircleTouch: UITouch? = nil
    var lastTouchPosition: CGPoint? = nil
    var frameCount = 0
    var playerWeapon1: PlayerWeapon = PlayerWeapon()
    var playerWeapon2: PlayerWeapon = PlayerWeapon()
    var activeWaves: [Wave] = []
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
        bulletLayer = foreground.childNode(withName: "Bullets")!
        scoreLabel = childNode(withName: "Score") as! SKLabelNode
        physicsWorld.contactDelegate = self as SKPhysicsContactDelegate
        playerWeapon1.position = CGPoint(x: 35, y: 5)
        playerWeapon2.position = CGPoint(x: -35, y: 5)
        
        currentWaveSequence = WaveSequence(waves: [
            TimedWave(wave: BasicWave(parent: foreground), duration: 60),
            TimedWave(wave: BasicWave(parent: foreground), duration: 60),
            TimedWave(wave: BasicWave(parent: foreground), duration: 60)
            ], startingFrame: 0)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchPosition = touch.location(in: self)
            let touchPositionInPlayerFrame = convert(touchPosition, to: player)
            if (navcircle.frame.contains(touchPositionInPlayerFrame) && !moving) {
                lastTouchPosition = touchPosition
                navcircleTouch = touch;
                moving = true;
                navcircle.run(SKAction.scale(to: 1.8, duration: 0.1))
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
                navcircle.run(SKAction.scale(to: 1.5, duration: 0.1))
            }
        }
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if (moving && touch.isEqual(navcircleTouch)) {
                navcircleTouch = nil
                moving = false
                navcircle.run(SKAction.scale(to: 1.5, duration: 0.1))
            }
        }
    }
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if (frameCount % playerWeapon1.fireRate == 0) {
            fireWeapon(weapon: playerWeapon1, senderPosition: player.position)
            fireWeapon(weapon: playerWeapon2, senderPosition: player.position)
        }
        backgroundImage1.position.y -= 3
        backgroundImage2.position.y -= 3
        if (backgroundImage1.position.y < GameScene.gameHeight * -1) {
            backgroundImage1.position.y = backgroundImage2.position.y + GameScene.gameHeight
        }
        if (backgroundImage2.position.y < GameScene.gameHeight * -1) {
            backgroundImage2.position.y = backgroundImage1.position.y + GameScene.gameHeight
        }
        frameCount += 1
        
        //Tick the currently active waveSequence
        if (currentWaveSequence != nil) {
            for wave in (currentWaveSequence?.step(frame: frameCount))! {
                activeWaves.append(wave)
            }
            
            //Shouldn't happen in final version, just until I set it so that the game finishes when the wave sequence
            //completes. At some point, the contents of this method should be just ... displayScoreScreen() or startStage2().
            if (currentWaveSequence?.isComplete())! {
                currentWaveSequence = WaveSequence(waves: [
                    TimedWave(wave: BasicWave(startingFrameCount: 0, parent: foreground), duration: 60),
                    TimedWave(wave: BasicWave(startingFrameCount: 60, parent: foreground), duration: 60),
                    TimedWave(wave: BasicWave(startingFrameCount: 120, parent: foreground), duration: 60)
                    ], startingFrame: 0)
            }
        }
        
        //Kill waves with no enemies in them, update the others
        if (!activeWaves.isEmpty) {
            var counter = activeWaves.count - 1
            for var i in 0...counter {
                if (activeWaves.count > i) {
                    let wave = activeWaves[i]
                    if (wave.enemies.count == 0) {
                        activeWaves.remove(at: i)
                        i -= 1
                        counter -= 1
                    } else {
                        activeWaves[i].update(frameCount: frameCount)
                    }
                }
            }
        }
    }
    func fireWeapon(weapon: Weapon, senderPosition: CGPoint) {
        let bullet: SKEmitterNode = SKEmitterNode(fileNamed: weapon.filename)!
        bullet.position = CGPoint(x: weapon.position.x + senderPosition.x,
                                  y: weapon.position.y + senderPosition.y)
        bullet.name = weapon.bulletName
        bullet.physicsBody = SKPhysicsBody(circleOfRadius: 1)
        bullet.physicsBody?.affectedByGravity = false
        bullet.physicsBody?.categoryBitMask = UInt32(weapon.categoryMask)
        bullet.physicsBody?.contactTestBitMask = UInt32(weapon.contactMask)
        bulletLayer.addChild(bullet)
        bullet.physicsBody?.applyImpulse(CGVector(dx: 0, dy: weapon.force))
    }
    func didBegin(_ contact: SKPhysicsContact) {
        if let body1 = contact.bodyA.node {
            if let body2 = contact.bodyB.node {
                if (body1.name == "PlayerHitbox" && body2.name == "Enemy"
                    || body2.name == "PlayerHitbox" && body1.name == "Enemy") {
                    restart()
                }
                if (body1.name == "PlayerBullet" && body2.name == "Barrier") {
                    body1.removeFromParent()
                } else if (body2.name == "PlayerBullet" && body1.name == "Barrier") {
                    body2.removeFromParent()
                }
                //WEAPONS
                if (body1.name == "EnemyBullet" && body2.name == "Barrier") {
                    body1.removeFromParent()
                } else if (body2.name == "EnemyBullet" && body1.name == "Barrier") {
                    body2.removeFromParent()
                }
                if (body1.name == "PlayerHitbox" && body2.name == "EnemyBullet"
                    || body2.name == "PlayerHitbox" && body1.name == "EnemyBullet") {
                    restart()
                }
                //END WEAPONS
                if (body1.name == "PlayerBullet" && body2.name == "Enemy") {
                    if let enemy = body2 as? Enemy {
                        enemy.collision(withBody: body2)
                    }
                    body1.removeFromParent()
                    score += playerWeapon1.damage
                } else if (body2.name == "PlayerBullet" && body1.name == "Enemy") {
                    if let enemy = body1 as? Enemy {
                        enemy.collision(withBody: body2)
                    }
                    body2.removeFromParent()
                    score += playerWeapon1.damage
                }
                if (body1.name == "Enemy" && body2.name == "Barrier") {
                    if let enemy = body1 as? Enemy {
                        if (enemy.enteredScene) {
                            enemy.destroy()
                        }
                    }
                } else if (body2.name == "Enemy" && body1.name == "Barrier") {
                    if let enemy = body2 as? Enemy {
                        if (enemy.enteredScene) {
                            enemy.destroy()
                        }
                    }
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
        navcircle.run(SKAction.scale(to: 1.5, duration: 0.1))
    }
}
