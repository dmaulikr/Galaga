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

class GameScene: SKScene {
    
    var foreground: SKNode!
    var background: SKNode!
    var bg1: SKSpriteNode!
    var bg2: SKSpriteNode!
    var player: SKSpriteNode!
    var playerMoveHitbox: SKSpriteNode!
    var gun1: SKSpriteNode!
    var gun2: SKSpriteNode!
    
    
    var fingerPosTrack: CGPoint? = nil
    let backgroundScrollSpeed = 4
    let gameWidth = CGFloat(425)
    let gameHeight = CGFloat(667)
    var moving = false
    var mainTouch: UITouch? = nil
    var guns: [SKSpriteNode] = []
    var bullets: [SKEmitterNode] = []
    var frameCount = 0
    
    override func didMove(to view: SKView) {
        //Initialize local reference variables
        let foreground = childNode(withName: "Foreground")!
        let background = childNode(withName: "Background")!
        bg1 = background.childNode(withName: "b1") as! SKSpriteNode
        bg2 = background.childNode(withName: "b2") as! SKSpriteNode
        player = foreground.childNode(withName: "Player") as! SKSpriteNode
        playerMoveHitbox = foreground.childNode(withName: "navcircle") as! SKSpriteNode
        gun1 = player.childNode(withName: "Gun1") as! SKSpriteNode
        gun2 = player.childNode(withName: "Gun2") as! SKSpriteNode
        guns = [gun1, gun2]
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
        frameCount += 1
        //Adjust the background by the speed of the scroll
        bg1.position.y -= CGFloat(backgroundScrollSpeed);
        bg2.position.y -= CGFloat(backgroundScrollSpeed);
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
    }
    
    func fireGuns() {
        for gun in guns {
            let bullet = SKEmitterNode(fileNamed: "Bullet.sks")
            bullet?.position = CGPoint(x: player.position.x + gun.position.x,
                                       y: player.position.y + gun.position.y)
            bullet?.physicsBody = SKPhysicsBody(circleOfRadius: 2)
            bullet?.physicsBody?.affectedByGravity = false
            self.addChild(bullet!)
            bullet?.zPosition = 5
            bullet?.particleZPosition = 5
            bullet?.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 1))
            bullets.append(bullet!)
        }
        for bullet in bullets {
            if (bullet.position.y > gameHeight * 2.5) {
                bullet.removeFromParent()
                bullets.removeFirst() //hacky if bullets move at different speeds
            }
        }
    }
    
}
