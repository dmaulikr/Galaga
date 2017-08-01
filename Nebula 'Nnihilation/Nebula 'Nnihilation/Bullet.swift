//
//  Bullet.swift
//  Nebula 'Nnihilation
//
//  Created by Jack Hamilton on 8/1/17.
//  Copyright © 2017 App Camp. All rights reserved.
//

import Foundation
import SpriteKit

class Bullet: SKSpriteNode {
    
    var velocity: Velocity
    var spawnFrame: Int
    var spawnLocation: CGPoint
    
    var collisionMask: Int
    var contactMask: Int
    var categoryMask: Int
    
    let zPos = 4
    
    //Override in subclasses
    var imageFilename: String {
        return "spark"
    }
    var scale: CGFloat {
        return 0.3
    }
    var nodeName: String {
        return "EnemyBullet"
    }
    
    var index = 0
    
    //spawnFrame is the frame in which it should spawn RELATIVE TO THE WAVE.
    //This means just the number of frames after the wave is created.
    init(spawnLocation: CGPoint, spawnFrame: Int) {
        velocity = Velocity(magnitude: 0, angle: 0)
        collisionMask = 0
        contactMask = 1
        categoryMask = 1
        self.spawnLocation = spawnLocation
        self.spawnFrame = spawnFrame
        super.init(texture: SKTexture(), color: UIColor.clear, size: CGSize.zero)
        texture = SKTexture(imageNamed: imageFilename)
        size = CGSize(width: texture!.size().width * scale, height: texture!.size().height * scale)
        position = spawnLocation
        name = nodeName
        zPosition = CGFloat(self.zPos)
    }
    convenience init(spawnX: Int, spawnY: Int, spawnFrame: Int) {
        self.init(spawnLocation: CGPoint(x: spawnX, y: spawnY), spawnFrame: spawnFrame)
    }
    convenience init(spawnX: Int, spawnY: Int, spawnSeconds: Double) {
        self.init(spawnLocation: CGPoint(x: spawnX, y: spawnY), spawnFrame: Int(spawnSeconds * 60))
    }
    convenience init(spawnX: Int, spawnY: Int, spawnFrame: Int, startVelocity: Velocity) {
        self.init(spawnLocation: CGPoint(x: spawnX, y: spawnY), spawnFrame: spawnFrame)
        velocity = startVelocity
    }
    convenience init(spawnX: Int, spawnY: Int, spawnSeconds: Double, startVelocity: Velocity) {
        self.init(spawnLocation: CGPoint(x: spawnX, y: spawnY), spawnFrame: Int(spawnSeconds * 60))
        velocity = startVelocity
    }
    
    //All will be set to default values. Don't call this without changing them afterwards.
    required init?(coder aDecoder: NSCoder) {
        fatalError("Warning: Default bullet initializer called.")
    }
    
    //Override in subclasses. Required. Something like 'return super.duplicate() as! BulletSubclass'
    func duplicate() -> Bullet {
        
        if ((self.superclass as? Bullet) != nil) {
            print("Error: Bullet subclass does not override the 'duplicate' method")
        }
        return Bullet(spawnLocation: spawnLocation, spawnFrame: spawnFrame)
        
    }
    
    //Framecount will be relative to pattern, which is in turn relative to the shot type.
    func update(frameCount: Int) {
        position.x = position.x + velocity.vector.dx
        position.y = position.y + velocity.vector.dy
    }
}
