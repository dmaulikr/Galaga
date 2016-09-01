//
//  invader.swift
//  Galaga
//
//  Created by App Camp on 7/25/16.
//  Copyright © 2016 App Camp. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class Enemy: SKSpriteNode {
    
    var row = 0
    let enemyCategory: UInt32 = 0x1 << 0
    var health = 100
    var scoreMul = 1
    
    init(type: EnemyType) {
        var texture = SKTexture(imageNamed: "enemy1")
        switch type {
        case .redMoth:
            break
        case .blueMoth:
            texture = SKTexture(imageNamed: "enemy2")
            health = 300
            scoreMul = 3
            break
        }
        super.init(texture: texture, color: SKColor.clearColor(), size: texture.size())
        physicsBody = SKPhysicsBody(rectangleOfSize: SKTexture(imageNamed:"galaga").size())
        physicsBody?.dynamic = true
        physicsBody?.velocity = CGVectorMake(0, -120)
        physicsBody?.affectedByGravity = false
        physicsBody?.linearDamping = 0
        physicsBody?.collisionBitMask = 0x0
        physicsBody?.categoryBitMask = enemyCategory
        physicsBody?.usesPreciseCollisionDetection = true
        self.name = "enemy"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func fire(scene: SKScene) {
        
    }
    
}