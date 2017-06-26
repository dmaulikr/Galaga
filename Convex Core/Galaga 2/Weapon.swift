//
//  Weapon.swift
//  Galaga 2
//
//  Created by Jack Hamilton on 6/20/17.
//  Copyright © 2017 Jack Hamilton. All rights reserved.
//

import Foundation
import SpriteKit

class Weapon: SKSpriteNode {
    
    var bullet: SKEmitterNode!
    //Number of frames between fires
    var fireRate: Int {
        get {
            return 120
        }
    }
    var bulletFile: String {
        get {
            return "Bullet1.sks"
        }
    }
    var bulletName: String {
        get {
            return "enemyBullet"
        }
    }
    //When fired, which speed to go (sign signifies direction)
    var impulse: CGVector {
        return CGVector(dx: 0, dy: -0.15)
    }
    var categoryMask: UInt32 {
        get {
            return 4
        }
    }
    var contactTestMask: UInt32 {
        get {
            return 4
        }
    }
    //The variability of the projection direction in degrees.
    var variation: Int {
        get {
            return 0
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initBullet()
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        initBullet()
    }
    
    func initBullet() {
        bullet = SKEmitterNode(fileNamed: bulletFile)!
        bullet.name = bulletName
        bullet.zPosition = 8
        bullet.particleZPosition = 8
        bullet.physicsBody = SKPhysicsBody(circleOfRadius: 1)
        bullet.physicsBody?.affectedByGravity = false
        bullet.physicsBody?.isDynamic = true
    }
    
    func getFireRate() -> Int {
        return fireRate
    }
    
    func getBullet() -> SKEmitterNode {
        return bullet
    }
    
    func getImpulse() -> CGVector {
        return impulse
    }
    
    func getCategoryMask() -> UInt32 {
        return categoryMask
    }
    
    func getContactTestMask() -> UInt32 {
        return contactTestMask
    }
    
    func getVariation() -> Int {
        return variation
    }
    
}
