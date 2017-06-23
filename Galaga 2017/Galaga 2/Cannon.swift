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
    
    override var fireRate: Int {
        get {
            return 32
        }
    }
    override var bulletFile: String {
        get {
            return "CannonBullet.sks"
        }
    }
    //When fired, which speed to go (sign signifies direction)
    override var impulse: CGVector {
        get {
            return CGVector(dx: 0, dy: -0.10)
        }
    }
    
}
