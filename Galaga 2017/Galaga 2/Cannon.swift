//
//  Enemy2Weapon.swift
//  Galaga 2
//
//  Created by Jack Hamilton on 6/19/17.
//  Copyright © 2017 Jack Hamilton. All rights reserved.
//

import Foundation
import SpriteKit
import SceneKit

class Cannon: Weapon {
    
    var cannonBullets: [SKEmitterNode] = []
    
    //Number of frames between fires
    let fireRate = 120
    let bullet = SKEmitterNode(fileNamed: "CannonBullet.sks")
    let bulletName = "cannonBullet"
    let impulse = CGVector(dx: 0, dy: -0.2)
    let categoryMask: UInt32 = 4
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initBullet()
        
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        initBullet()
    }

    func initBullet() {
        bullet?.name = bulletName
        bullet?.zPosition = 8
        bullet?.particleZPosition = 8
        bullet?.physicsBody = SKPhysicsBody(circleOfRadius: 1)
        bullet?.physicsBody?.affectedByGravity = false
    }
    
    override func getFireRate() -> Int {
        return fireRate
    }
    
    override func getBullet() -> SKEmitterNode {
        return bullet!
    }
    
    override func getImpulse() -> CGVector {
        return impulse
    }
    
    override func getCategoryMask() -> UInt32 {
        return categoryMask
    }
    
}
