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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    func getBullet() -> SKEmitterNode {
        return SKEmitterNode()
    }
    
    func getFireRate() -> Int {
        return 60
    }
    
    func getImpulse() -> CGVector {
        return CGVector(dx: 0, dy: 0)
    }
    
    func getCategoryMask() -> UInt32 {
        return 2
    }
    
}
