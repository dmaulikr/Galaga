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
    var wave1Scene: SKScene!
    var wave2Scene: SKScene!
    var wave1: SKSpriteNode!
    var wave2: SKSpriteNode!
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
        wave1Scene = SKScene(fileNamed: "wave1")
        wave2Scene = SKScene(fileNamed: "wave2")
        wave1 = wave1Scene.childNode(withName: "overlay") as! SKSpriteNode
        wave2 = wave2Scene.childNode(withName: "overlay") as! SKSpriteNode
        
        //Each tuple is ((wave scene variable), (whether or not it's flipped on y-axis))
        //This lets you add more than one wave option for waves in which flipping it on the y-axis could
        //represent an additional disparate wave.
        //Wave1: can be flipped. Wave2: cannot.
        waveSet = [(wave1, true), (wave1, false), (wave2, false)]
        
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
        if (playerMoveHitbox.frame.contains(pos)) {
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
        if (frameCount % 480 == 0) {
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
                            let rotation = weapon.zRotation
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
                            bullet.physicsBody?.applyImpulse(CGVector(dx: impulseMag * sin(rotation) * xMod,
                                                                      dy: impulseMag * cos(rotation) * yMod))
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
            let rotation = gun.zRotation
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
            bullet?.physicsBody?.applyImpulse(CGVector(dx: sin(rotation) * impulseMag,
                                                       dy: cos(rotation) * impulseMag))
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let delA = handleNodeCollision(node: contact.bodyA.node, node2: contact.bodyB.node)
        let delB = handleNodeCollision(node: contact.bodyB.node, node2: contact.bodyA.node)
        //Below is so that the second handleCollision function can be run while the first node is still active
        //if otherwise it would have been deleted during the running of the first handleCollision function.
        if (delA) {
            if (contact.bodyA.node != nil) {
                contact.bodyA.node?.removeFromParent()
            }
        }
        if (delB) {
            if (contact.bodyB.node != nil) {
                contact.bodyB.node?.removeFromParent()
            }
        }
    }
    
    //Returns whether or not to remove the node after function completion.
    func handleNodeCollision(node: SKNode?, node2: SKNode?) -> Bool {
        guard node != nil else {
            return false
        }
        guard node2 != nil else {
            return false
        }
        //If a bullet and enemy ship collide, ship and ship, or bullet and bullet collide
        if (node?.physicsBody?.contactTestBitMask == 1
            && node2?.physicsBody?.contactTestBitMask == 1) {
            if (node?.name == "bullet") {
                //Create a shockwave
                let shockwave = SKEmitterNode(fileNamed: "Bullet1Splash")
                shockwave!.position = node!.position
                shockwave?.particleZPosition = 5
                shockwave?.zPosition = 5
                node?.parent?.addChild(shockwave!)
                shockwave?.run(shockWaveAction)
                //Remove bullet from array
                return true
            } else if (node?.name == "Enemy1"
                || node?.name == "Enemy2") {
                //Update score
                score += 7
                //Lower the enemy's health - if below 0, kill it
                if let currentHealth = node?.userData?.value(forKey: "health") as? Int {
                    //TEMP: Implement different damges by bullet type.
                    let damage = 5
                    if (currentHealth - damage > 0) {
                        node?.userData?.setValue(currentHealth - damage, forKey: "health")
                        return false
                    } else {
                        
                        //If the scoreValue property is initialized, add it to main score.
                        if let addScore = node?.userData?.value(forKey: "scoreValue") as? Int {
                            score += addScore
                        } else {
                            print ("Issue initializing scoreValue property.")
                            return true
                        }
                        return true
                    }
                } else {
                    print ("Error accessing enemy variables")
                    return false
                }
            }
        }
        //If enemy bullets collide with player
        if ((node?.name == "cannonBullet" && node2?.name == "playerHitbox")
            || (node2?.name == "cannonBullet" && node?.name == "playerHitbox")) {
            restartGame()
        } else if ((node?.name == "Enemy1" && node2?.name == "playerHitbox")
            || (node2?.name == "Enemy1" && node?.name == "playerHitbox")) {
            restartGame()
        } else if ((node?.name == "Enemy2" && node2?.name == "playerHitbox")
            || (node2?.name == "Enemy2" && node?.name == "playerHitbox")) {
            restartGame()
        }
        
        //If anything collides with the world barrier
        if (node?.name == "Barrier") {
            node2?.removeFromParent()
        } else if (node2?.name == "Barrier") {
            node?.removeFromParent()
        }
        
        //Default exit condition
        return false
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
    
}

//TODO: bullet class with indexing, so that the proper one can be removed when destroyed
