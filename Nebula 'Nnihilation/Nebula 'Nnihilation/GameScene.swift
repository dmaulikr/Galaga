import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    static let gameWidth = CGFloat(850)
    static let gameHeight = CGFloat(1334)
    
    //Static so that the bullet classes can manipulate and track the bulletLayer and player, and garbage collect themselves
    static var player: SKSpriteNode!
    static var playerHitbox: SKSpriteNode!
    static var bulletLayer: SKNode!
    static var foreground: SKNode!
    var background: SKNode!
    var navcircle: SKSpriteNode!
    var backgroundImage1: SKSpriteNode!
    var backgroundImage2: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    //The waveSequence to step through in update. Set in didMove.
    var currentWaveSequence: WaveSequence?
    
    //Static so other classes can access it's damage. Reevaluate once player bullets subclass Bullet.
    static var playerWeapon1: PlayerWeapon = PlayerWeapon()
    var playerWeapon2: PlayerWeapon = PlayerWeapon()
    
    var moving = false
    var navcircleTouch: UITouch? = nil
    var lastTouchPosition: CGPoint? = nil
    var frameCount = 0
    var activeWaves: [Wave] = []
    var score: Int {
        get {
            return Int(scoreLabel.text!)!
        }
        set (newValue) {
            scoreLabel.text = String(newValue)
        }
    }
    
    var startedWaveSpawning = false
    
    override func didMove(to view: SKView) {
        isUserInteractionEnabled = true
        GameScene.foreground = childNode(withName: "Foreground")!
        background = childNode(withName: "Background")!
        GameScene.player = GameScene.foreground.childNode(withName: "Player") as! SKSpriteNode
        GameScene.playerHitbox = GameScene.player.childNode(withName: "PlayerHitbox") as! SKSpriteNode
        navcircle = GameScene.player.childNode(withName: "Navcircle") as! SKSpriteNode
        backgroundImage1 = background.childNode(withName: "Background1") as! SKSpriteNode
        backgroundImage2 = background.childNode(withName: "Background2") as! SKSpriteNode
        GameScene.bulletLayer = GameScene.foreground.childNode(withName: "Bullets")!
        scoreLabel = childNode(withName: "Score") as! SKLabelNode
        physicsWorld.contactDelegate = self as SKPhysicsContactDelegate
        GameScene.playerWeapon1.position = CGPoint(x: 15, y: 5)
        playerWeapon2.position = CGPoint(x: -15, y: 5)
        
        let backgroundMusic = SKAudioNode(fileNamed: "Capacitor")
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchPosition = touch.location(in: self)
            let touchPositionInPlayerFrame = convert(touchPosition, to: GameScene.player)
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
                GameScene.player.position.x = GameScene.player.position.x - (lastTouchPosition!.x - touchPosition.x)
                GameScene.player.position.y = GameScene.player.position.y - (lastTouchPosition!.y - touchPosition.y)
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
        if (frameCount % GameScene.playerWeapon1.fireRate == 0) {
            fireWeapon(weapon: GameScene.playerWeapon1, senderPosition: GameScene.player.position)
            fireWeapon(weapon: playerWeapon2, senderPosition: GameScene.player.position)
        }
        backgroundImage1.position.y -= 1
        backgroundImage2.position.y -= 1
        if (backgroundImage1.position.y < GameScene.gameHeight * -1) {
            backgroundImage1.position.y = backgroundImage2.position.y + GameScene.gameHeight
        }
        if (backgroundImage2.position.y < GameScene.gameHeight * -1) {
            backgroundImage2.position.y = backgroundImage1.position.y + GameScene.gameHeight
        }
        frameCount += 1
        
        //Update active patterns, garbage collect
        for patternNode in GameScene.bulletLayer.children {
            if let pattern = patternNode as? BulletPattern {
                if (pattern.bullets.count > 0) {
                    pattern.update(frameCount: frameCount)
                } else {
                    pattern.removeFromParent()
                }
            }
        }
        
        //WAVE SPAWNING CODE
        //Tick the currently active waveSequence
        if (currentWaveSequence != nil) {
            for wave in (currentWaveSequence?.step(frame: frameCount))! {
                activeWaves.append(wave)
            }
        }
        //Shouldn't happen in final version, just until I set it so that the game finishes when the wave sequence
        //completes. At some point, the contents of this method should be just ... displayScoreScreen() or startStage2().
        if (!startedWaveSpawning || (currentWaveSequence!.isComplete())) {
            
            currentWaveSequence = WaveSequence(waves: [
                TimedWave(wave: BasicWave(parent: GameScene.foreground), duration: 300),
                TimedWave(wave: BasicWave2(parent: GameScene.foreground), duration: 300),
                TimedWave(wave: BasicWave(parent: GameScene.foreground), duration: 300),
                TimedWave(wave: ComplexWave1FromLeft(parent:GameScene.foreground), duration: 180),
                TimedWave(wave: ComplexWave1FromRight(parent:GameScene.foreground), duration: 180),
                TimedWave(wave: BasicWave2(parent: GameScene.foreground), duration: 300)
                ], startingFrame: frameCount)
            /* TEST WAVE
            currentWaveSequence = WaveSequence(waves: [
                TimedWave(wave: TestWave(parent: GameScene.foreground), duration: 600)
                ], startingFrame: frameCount
            
            )*/
            startedWaveSpawning = true
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
        bullet.physicsBody?.collisionBitMask = UInt32(128)
        GameScene.bulletLayer.addChild(bullet)
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
                        if (enemy.collision(withBody: body1)) {
                            particleEffect(position: body2.position, filename: "EnemyExplosion", duration: 1)
                        }
                    }
                    particleEffect(position: body1.position, filename: "BulletSplash", duration: 0.15)
                    body1.removeFromParent()
                    score += GameScene.playerWeapon1.damage
                } else if (body2.name == "PlayerBullet" && body1.name == "Enemy") {
                    if let enemy = body1 as? Enemy {
                        if (enemy.collision(withBody: body2)) {
                            particleEffect(position: body1.position, filename: "EnemyExplosion", duration: 1)
                        }
                    }
                    particleEffect(position: body2.position, filename: "BulletSplash", duration: 0.15)
                    body2.removeFromParent()
                    score += GameScene.playerWeapon1.damage
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
    
    func particleEffect(position: CGPoint, filename: String, duration: Double) {
        let splash = SKEmitterNode(fileNamed: filename)
        splash?.position = position
        splash?.zPosition = 4
        GameScene.bulletLayer.addChild(splash!)
        splash?.run(SKAction.sequence([SKAction.wait(forDuration: duration),
                                       SKAction.fadeOut(withDuration: 0.05),
                                       SKAction.removeFromParent()]))
    }
    
    func restart() {
        GameScene.player.position.x = 0
        GameScene.player.position.y = -300
        GameScene.foreground.removeAllChildren()
        GameScene.bulletLayer.removeAllChildren()
        GameScene.foreground.addChild(GameScene.player)
        GameScene.foreground.addChild(GameScene.bulletLayer)
        activeWaves.removeAll()
        score = 0
        navcircleTouch = nil
        moving = false
        startedWaveSpawning = false
        navcircle.run(SKAction.scale(to: 1.5, duration: 0.1))
    }
}
