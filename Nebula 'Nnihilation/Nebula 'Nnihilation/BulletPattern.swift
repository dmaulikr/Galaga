//
//  BulletPattern.swift
//  Nebula 'Nnihilation
//
//  Created by Jack Hamilton on 8/1/17.
//  Copyright © 2017 App Camp. All rights reserved.
//

import Foundation
import SpriteKit

//Essentially a gun - given an origin, it can
class BulletPattern: SKSpriteNode {
    
    var nodeToFollow: SKNode?
    let bulletsTemplate: [Bullet]
    var bullets: [Bullet] = []
    var startFrameCount: Int = 0
    
    var velocity: Velocity = Velocity(magnitude: 0, angle: 0)
    
    init (originPosition: CGPoint, startFrameCount: Int, bullets: [Bullet]) {
        self.bulletsTemplate = bullets
        self.startFrameCount = startFrameCount
        super.init(texture: SKTexture(), color: UIColor.clear, size: CGSize.zero)
        position = originPosition
        for bullet in bullets {
            addChild(bullet)
            bullet.index = bullets.count - 1
            self.bullets.append(bullet)
        }
        name = "BulletPattern"
        GameScene.bulletLayer.addChild(self)
    }
    convenience init (originPosition: CGPoint, startFrameCount: Int, bullets: Bullet...) {
        self.init(originPosition: originPosition, startFrameCount: startFrameCount, bullets: bullets)
    }
    convenience init (originPosition: CGPoint, startFrameCount: Int, startingVelocity: Velocity, bullets: Bullet...) {
        self.init(originPosition: originPosition, startFrameCount: startFrameCount, bullets: bullets)
        velocity = startingVelocity
    }
    //'Tracking' fires the pattern initially at some other node.
    
    convenience init (originPosition: CGPoint, startFrameCount: Int, tracking: Bool, bullets: [Bullet]) {
        self.init(originPosition: originPosition, startFrameCount: startFrameCount, bullets: bullets)
        //In radians
        //Calculate the relative angle from 0.
        if (tracking) {
            let xDiff: CGFloat = (GameScene.playerHitbox.position.x + GameScene.player.position.x) - position.x
            let yDiff: CGFloat = (GameScene.playerHitbox.position.y + GameScene.player.position.y + 20) - position.y
            let angle = atan(abs(yDiff) / abs(xDiff))
            var angleToOrigin: CGFloat = angle
            //We calculate the angle in each quadrant, then modify it based on which quadrant it's in to make it relative to theta = 0.
            if (xDiff >= 0 && yDiff >= 0) {
                angleToOrigin = angle
            } else if (xDiff >= 0) {
                //y is negative
                angleToOrigin = (.pi * 2) - angle
            } else if (yDiff >= 0) {
                //x is negative
                angleToOrigin = .pi - angle
            } else {
                //both negative
                angleToOrigin = .pi + angle
            }
            
            //Convert to degrees
            velocity.angle = Double(angleToOrigin * 180) / .pi
        }
    }
    
    convenience init (originPosition: CGPoint, startFrameCount: Int, tracking: Bool, bullets: Bullet...) {
        self.init(originPosition: originPosition, startFrameCount: startFrameCount, tracking: tracking, bullets: bullets)
    }
    convenience init (originPosition: CGPoint, startFrameCount: Int, tracking: Bool, startingVelocity: Velocity, bullets: Bullet...) {
        self.init(originPosition: originPosition, startFrameCount: startFrameCount, tracking: tracking, bullets: bullets)
        velocity.magnitude = startingVelocity.magnitude
    }
    
    func update(frameCount: Int) {
        position.x = position.x + velocity.vector.dx
        position.y = position.y + velocity.vector.dy
        zRotation = CGFloat(velocity.angle)
        for bullet in bullets {
            if (bullet.parent == nil) {
                //Remove the bullet, update indexes
                if (bullet.index + 1 < bullets.count)
                {
                    for i in (bullet.index + 1)...(bullets.count - 1) {
                        bullets[i].index -= 1
                    }
                }
                bullets.remove(at: bullet.index)
            } else {
                bullet.update(frameCount: frameCount - startFrameCount)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
