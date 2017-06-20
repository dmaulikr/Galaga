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
    var guns: [SKSpriteNode] = []
    var bullets: [SKEmitterNode] = []
    var frameCount = 0
    
    var waveScene: SKScene!
    var wave1: SKSpriteNode!
    var currentWave: SKSpriteNode!
    
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
        let foreground = childNode(withName: "Foreground")!
        let background = childNode(withName: "Background")!
        bg1 = background.childNode(withName: "b1") as! SKSpriteNode
        bg2 = background.childNode(withName: "b2") as! SKSpriteNode
        player = foreground.childNode(withName: "player") as! SKSpriteNode
        playerMoveHitbox = foreground.childNode(withName: "navcircle") as! SKSpriteNode
        gun1 = player.childNode(withName: "Gun1") as! SKSpriteNode
        gun2 = player.childNode(withName: "Gun2") as! SKSpriteNode
        guns = [gun1, gun2]
        scoreLabel = foreground.childNode(withName: "ScoreLabel") as! SKLabelNode
        waveScene = SKScene(fileNamed: "wave1")
        wave1 = waveScene.childNode(withName: "overlay") as! SKSpriteNode
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
        if (frameCount % 720 == 0) {
            if (currentWave != nil) {
                currentWave.removeFromParent()
            }
            currentWave = wave1.copy() as! SKSpriteNode
            addChild(currentWave)
        }
        
        currentWave.position.y -= 3
        
        frameCount += 1
        //Adjust the background by the speed of the scroll
        bg1.position.y -= CGFloat(backgroundScrollSpeed)
        bg2.position.y -= CGFloat(backgroundScrollSpeed)
        
        //If any of the two are below the display, move them back above the other.
        if (bg2.position.y <= -1334) {
            bg2.position.y = bg1.position.y + 1334
        }
        if (bg1.position.y <= -1334) {
            bg1.position.y = bg2.position.y + 1334
        }
        if (frameCount % 3 == 0) {
            fireGuns()
        }
        for enemy: SKNode in currentWave.children {
            for gun: SKNode in enemy.children {
                if let weapon = gun as? Weapon {
                    //If it's the right frame, fire
                    if (frameCount % weapon.getFireRate() == 0) {
                        let bullet: SKEmitterNode = weapon.getBullet().copy() as! SKEmitterNode
                        let pos = weapon.parent?.convert(weapon.position, to: self)
                        bullet.position = pos!
                        bullet.physicsBody?.categoryBitMask = weapon.getCategoryMask()
                        bullet.physicsBody?.collisionBitMask = weapon.getCategoryMask()
                        addChild(bullet)
                        bullet.physicsBody?.applyImpulse(weapon.getImpulse())
                    }
                }
            }
        }
    }
    
    func fireGuns() {
        for gun in guns {
            //Create a bullet
            let bullet = SKEmitterNode(fileNamed: "Bullet1.sks")
            bullet?.position = CGPoint(x: player.position.x + gun.position.x,
                                       y: player.position.y + gun.position.y)
            bullet?.physicsBody = SKPhysicsBody(circleOfRadius: 2)
            bullet?.physicsBody?.affectedByGravity = false
            bullet?.physicsBody?.contactTestBitMask = 1
            bullet?.physicsBody?.collisionBitMask = 1
            bullet?.physicsBody?.categoryBitMask = 2
            bullet?.name = "bullet"
            addChild(bullet!)
            bullet?.zPosition = 5
            bullet?.particleZPosition = 5
            bullet?.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 1))
            bullets.append(bullet!)
        }
        for bullet in bullets {
            if (bullet.position.y > gameHeight + 20) {
                bullet.removeFromParent()
                bullets.removeFirst() //hacky if bullets move at different speeds
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let delA = handleNodeCollision(node: contact.bodyA.node, node2: contact.bodyB.node)
        let delB = handleNodeCollision(node: contact.bodyB.node, node2: contact.bodyA.node)
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
                    let damage = 4
                    if (currentHealth - damage > 0) {
                        node?.userData?.setValue(currentHealth - damage, forKey: "health")
                        return false
                    } else {
                        //Delete stray bullets
                        for nodeDel in (node?.physicsBody?.allContactedBodies())! {
                            nodeDel.node?.removeFromParent()
                        }
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
        if ((node?.name == "cannonBullet" && node2?.name == "player")
            || (node2?.name == "cannonBullet" && node?.name == "player")) {
            restartGame()
        }
        return false
    }
    
    func restartGame() {
        view?.isPaused = true
        let alert = UIAlertController(title: "Game Over!", message: "Score: \(score)", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Restart", style: .default) { action in
            self.score = 0
            self.currentWave.removeFromParent()
            self.currentWave = self.wave1.copy() as! SKSpriteNode
            self.addChild(self.currentWave)
            self.view?.isPaused = false
        })
        let vc = self.view?.window?.rootViewController
        if vc?.presentedViewController == nil {
            vc?.present(alert, animated: true, completion: nil)
        }
        
    }
    
}

//TODO: bullet class with indexing, so that the proper one can be removed when destroyed
