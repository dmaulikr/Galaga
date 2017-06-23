//
//  GameScene.swift
//  Galaga 2
//
//  Created by Jack Hamilton on 6/15/17.
//  Copyright © 2017 Jack Hamilton. All rights reserved.
//

import SpriteKit
import GameplayKit
import SceneKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var foreground: SKNode!
    var background: SKNode!
    var bulletLayer: SKNode!
    var bg1: SKSpriteNode!
    var bg2: SKSpriteNode!
    var player: SKSpriteNode!
    var playerMoveHitbox: SKSpriteNode!
    var gun1: SKSpriteNode!
    var gun2: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    
    var fingerPosTrack: CGPoint? = nil
    let backgroundScrollSpeed = 4
    let gameWidth = CGFloat(425)
    let gameHeight = CGFloat(667)
    var moving = false
    var mainTouch: UITouch? = nil
    var playerGuns: [SKSpriteNode] = []
    let playerGunsFireRate = 4
    var frameCount = 0
    
    var wavesParent: SKNode!
    var wave1: SKSpriteNode!
    var wave2: SKSpriteNode!
    var wave3: SKSpriteNode!
    //A list of all the waves currently present in the scene
    var activeWaves: [SKSpriteNode] = []
    
    //The array is just a list of all the possible waves. Initialised in didMove function.
    var waveSet: [(node: SKSpriteNode, flipY: Bool)] = []
    
    var score: Int {
        get {
            return Int(scoreLabel.text!)!
        }
        set (newScore) {
            scoreLabel.text = String(newScore)
        }
    }
    
    let shockWaveAction: SKAction = {
        let growAndFadeAction = SKAction.group([SKAction.scale(to: 1, duration: 0.5),
                                                SKAction.fadeOut(withDuration: 0.3)])
        let sequence = SKAction.sequence([growAndFadeAction,
                                          SKAction.removeFromParent()])
        return sequence
    }()
    
    override func didMove(to view: SKView) {
        //Initialize local reference variables
        foreground = childNode(withName: "Foreground")!
        background = childNode(withName: "Background")!
        wavesParent = childNode(withName: "Waves")
        bulletLayer = foreground.childNode(withName: "Bullets")
        bg1 = background.childNode(withName: "b1") as! SKSpriteNode
        bg2 = background.childNode(withName: "b2") as! SKSpriteNode
        player = foreground.childNode(withName: "player") as! SKSpriteNode
        playerMoveHitbox = foreground.childNode(withName: "navcircle") as! SKSpriteNode
        gun1 = player.childNode(withName: "Gun1") as! SKSpriteNode
        gun2 = player.childNode(withName: "Gun2") as! SKSpriteNode
        playerGuns = [gun1, gun2]
        scoreLabel = foreground.childNode(withName: "ScoreLabel") as! SKLabelNode
        wave1 = SKScene(fileNamed: "wave1")?.childNode(withName: "overlay") as! SKSpriteNode
        wave2 = SKScene(fileNamed: "wave2")?.childNode(withName: "overlay") as! SKSpriteNode
        wave3 = SKScene(fileNamed: "wave3")?.childNode(withName: "overlay") as! SKSpriteNode
        
        //Each tuple is ((wave scene variable), (whether or not it's flipped on y-axis))
        //This lets you add more than one wave option for waves in which flipping it on the y-axis could
        //represent an additional disparate wave.
        //Wave1: can be flipped. Wave2: cannot.
        waveSet = [(wave1, true), (wave1, false), (wave2, false), (wave3, true), (wave3, false)]
        
        //Initialize physics contact system
        physicsWorld.contactDelegate = self as SKPhysicsContactDelegate
    }
    
    func touchDown(atPoint pos : CGPoint, withTouch touch: UITouch) {
        //Consider for control schemes: current scheme, but restrict when it moves to when touch and drag is
        //just below the ship.
        if (playerMoveHitbox.frame.contains(pos) && !moving) {
            fingerPosTrack = pos
            mainTouch = touch;
            moving = true;
        }
    }
    
    func touchMoved(toPoint pos : CGPoint, withTouch touch: UITouch) {
        if (moving && touch == mainTouch) {
            //Move the player by as much as the finger's moved, then reset the baseline
            player.position.x -= fingerPosTrack!.x - pos.x
            //Bound the player on the x-axis to within the game screen
            if (player.position.x <= -gameWidth + player.frame.size.width) {
                player.position.x = -gameWidth + player.frame.size.width
            } else if (player.position.x >= gameWidth - player.frame.size.width) {
                player.position.x = gameWidth - player.frame.size.width
            }
            //Bound the player on the y-axis to within the game screen
            player.position.y -= fingerPosTrack!.y - pos.y
            if (player.position.y <= -gameHeight + player.frame.size.height) {
                player.position.y = -gameHeight + player.frame.size.height
            } else if (player.position.y >= gameHeight - player.frame.size.height) {
                player.position.y = gameHeight - player.frame.size.height
            }
            //Move the tracking navigation circle with the player sprite
            playerMoveHitbox.position.x = player.position.x;
            playerMoveHitbox.position.y = player.position.y - 40 - player.size.height;
            fingerPosTrack = pos;
        }
    }
    
    func touchUp(atPoint pos : CGPoint, withTouch touch: UITouch) {
        if (touch == mainTouch) {
            moving = false;
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self), withTouch: t) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self), withTouch: t) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self), withTouch: t) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self), withTouch: t) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        //Waves of length is 12s
        if (frameCount % 300 == 0) {
            //As long as there are waves, spawn them. Pick one randomly from the set of possible waves.
            if (waveSet.count != 0) {
                let index = Int(arc4random_uniform(UInt32(waveSet.count)))
                let currentWave = waveSet[index].node.copy() as! SKSpriteNode
                //If the wave needs to be flipped along the y-axis, flip the y-index of all children accordingly.
                if (waveSet[index].flipY) {
                    for node in currentWave.children {
                        node.position.y *= -1
                    }
                }
                activeWaves.append(currentWave)
                wavesParent.addChild(currentWave)
            }
        }
        for wave in activeWaves {
            wave.position.y -= 3
            //If it's below the screen, delete it, as the overlay object does not have a physicsBody
            //and thus will not be deleted on contact with the barriers.
            if (wave.position.y < gameHeight * -2) {
                wave.removeFromParent()
                //If any wave moves faster than any other, this won't work, and you'll need to keep track of each individual wave's index in the array and delete that one specifically. Shouldn't be a problem in current implementation.
                activeWaves.removeFirst()
            }
        }
        
        frameCount += 1
        //Adjust the background by the speed of the scroll
        bg1.position.y -= CGFloat(backgroundScrollSpeed)
        bg2.position.y -= CGFloat(backgroundScrollSpeed)
        
        //If any of the two backgrounds are below the display, move them back above the other.
        if (bg2.position.y <= gameHeight * -2) {
            bg2.position.y = bg1.position.y + gameHeight * 2
        }
        if (bg1.position.y <= gameHeight * -2) {
            bg1.position.y = bg2.position.y + gameHeight * 2
        }
        if (frameCount % playerGunsFireRate == 0) {
            fireGuns()
        }
        //For every gun in the current wave, fire
        for wave in activeWaves {
            for enemy in wave.children {
                for gun: SKNode in enemy.children {
                    if let weapon = gun as? Weapon {
                        //If it's the right frame, fire
                        if (frameCount % weapon.getFireRate() == 0) {
                            let bullet: SKEmitterNode = weapon.getBullet().copy() as! SKEmitterNode
                            let pos = weapon.parent?.convert(weapon.position, to: self)
                            var rotationMod: CGFloat = 0
                            if (weapon.getVariation() > 0) {
                                //Modify the rotation of the firing direction by the variability of the weapon -
                                //specifically, generate a random number between 0 and the variability, then
                                //subtract that from half the variation. For instance, a variability range of sixty
                                //might generate 59 as it's value, but as this algorithm doesn't go into negatives,
                                //what we actually want this to produce is a value of 29. As such, we subtract 30
                                //from 59 in this example.
                                rotationMod = CGFloat(arc4random_uniform(UInt32(weapon.getVariation() - 1) + 1))
                                    - CGFloat(weapon.getVariation() / 2)
                            }
                            let rotation = toDegrees(radians: weapon.zRotation) + rotationMod
                            let impulseMag = sqrt(pow(weapon.getImpulse().dx, 2) + pow(weapon.getImpulse().dy, 2))
                            var yMod: CGFloat = 1
                            var xMod: CGFloat = 1
                            //Magnitude ignores negatives, so check if they're negative and adjust them later
                            if (weapon.getImpulse().dy < 0) {
                                yMod = -1
                            }
                            if (weapon.getImpulse().dx < 0) {
                                xMod = -1
                            }
                            bullet.position = pos!
                            bullet.physicsBody?.categoryBitMask = weapon.getCategoryMask()
                            bullet.physicsBody?.collisionBitMask = weapon.getCategoryMask()
                            bulletLayer.addChild(bullet)
                            bullet.physicsBody?.applyImpulse(CGVector(dx: impulseMag * sin(degrees: rotation) * xMod,
                                                                      dy: impulseMag * cos(degrees: rotation) * yMod))
                        }
                    }
                }
            }
        }
    }
    
    //Fire the player's guns.
    func fireGuns() {
        for gun in playerGuns {
            //Create a bullet
            let bullet = SKEmitterNode(fileNamed: "Bullet1.sks")
            bullet?.position = CGPoint(x: player.position.x + gun.position.x,
                                       y: player.position.y + gun.position.y)
            let rotation = toDegrees(radians: gun.zRotation)
            let impulseMag: CGFloat = 1
            bullet?.physicsBody = SKPhysicsBody(circleOfRadius: 2)
            bullet?.physicsBody?.affectedByGravity = false
            bullet?.physicsBody?.contactTestBitMask = 1
            bullet?.physicsBody?.collisionBitMask = 1
            bullet?.physicsBody?.categoryBitMask = 2
            bullet?.name = "bullet"
            bulletLayer.addChild(bullet!)
            bullet?.zPosition = 5
            bullet?.particleZPosition = 5
            bullet?.physicsBody?.applyImpulse(CGVector(dx: sin(degrees: rotation) * impulseMag,
                                                       dy: cos(degrees: rotation) * impulseMag))
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let node = contact.bodyA.node
        let node2 = contact.bodyB.node
        guard node != nil else {
            return
        }
        guard node2 != nil else {
            return
        }
        //If a bullet and enemy ship collide, ship and ship, or bullet and bullet collide
        //We only deal with bullet and enemy, because others shouldn't theoretically happen
        if (node?.physicsBody?.contactTestBitMask == 1
            && node2?.physicsBody?.contactTestBitMask == 1) {
            if (node?.name == "Enemy" && node2?.name == "bullet"
                || node2?.name == "Enemy" && node?.name == "bullet") {
                var enemy: SKNode
                var bullet: SKNode
                if (node?.name == "Enemy") {
                    enemy = node!
                    bullet = node2!
                } else {
                    enemy = node2!
                    bullet = node!
                }
                genShockwave(node: bullet)
                //Update score
                score += 7
                //Lower the enemy's health - if below 0, kill it
                if let currentHealth = enemy.userData?.value(forKey: "health") as? Int {
                    //Here, you would implement different damages by bullet type.
                    //Right now, any player-emitted bullet does the same damage.
                    let damage = 4
                    //If the enemy survives
                    if (currentHealth - damage > 0) {
                        enemy.userData?.setValue(currentHealth - damage, forKey: "health")
                    } else {
                        //If the enemy's scoreValue (score given on death) property is initialized, add it to main score.
                        if let addScore = node?.userData?.value(forKey: "scoreValue") as? Int {
                            score += addScore
                        }
                        //Kill stray bullets
                        for body in (enemy.physicsBody?.allContactedBodies())! {
                            body.node?.removeFromParent()
                        }
                        enemy.removeFromParent()
                    }
                } else {
                    print ("Error accessing enemy variables")
                }
                bullet.removeFromParent()
            }
        }
        //If enemy bullets collide with player
        if ((node?.name == "enemyBullet" && node2?.name == "playerHitbox")
            || (node2?.name == "enemyBullet" && node?.name == "playerHitbox")) {
            restartGame()
        } else if ((node?.name == "Enemy" && node2?.name == "playerHitbox")
            || (node2?.name == "Enemy" && node?.name == "playerHitbox")) {
            restartGame()
        }
        
        //If anything collides with the world barrier
        if (node?.name == "Barrier") {
            node2?.removeFromParent()
        } else if (node2?.name == "Barrier") {
            node?.removeFromParent()
        }
        
        //If the player's bullets collide with the bullet barrier
        if (node?.name == "BulletBarrier") {
            if (node2?.name == "enemyBullet" || node2?.name == "bullet") {
                node2?.removeFromParent()
            }
        } else if (node2?.name == "BulletBarrier") {
            if (node?.name == "enemyBullet" || node?.name == "bullet") {
                node?.removeFromParent()
            }
        }
    }
    
    //Create a shockwave at the given node's position
    func genShockwave(node: SKNode) {
        let shockwave = SKEmitterNode(fileNamed: "Bullet1Splash")
        shockwave!.position = node.position
        shockwave?.particleZPosition = 5
        shockwave?.zPosition = 5
        shockwave?.run(shockWaveAction)
        node.parent?.addChild(shockwave!)
    }
    
    func restartGame() {
        view?.isPaused = true
        let alert = UIAlertController(title: "Game Over!", message: "Score: \(score)", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Restart", style: .default) { action in
            self.score = 0
            self.wavesParent.removeAllChildren()
            self.activeWaves.removeAll()
            self.bulletLayer.removeAllChildren()
            self.frameCount = 0
            self.view?.isPaused = false
        })
        let vc = self.view?.window?.rootViewController
        if vc?.presentedViewController == nil {
            vc?.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func toDegrees(radians: CGFloat) -> CGFloat {
        return CGFloat((Double(radians) / Double.pi) * 180.0)
    }
    
    func sin(degrees: CGFloat) -> CGFloat {
        return CGFloat(Darwin.sin(Double(degrees) * Double.pi / 180.0))
    }
    
    func cos(degrees: CGFloat) -> CGFloat {
        return CGFloat(Darwin.cos(Double(degrees) * Double.pi / 180.0))
    }
    
}

//TODO: bullet class with indexing, so that the proper one can be removed when destroyed
