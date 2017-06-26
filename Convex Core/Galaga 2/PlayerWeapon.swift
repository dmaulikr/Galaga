//
//  PlayerWeapon.swift
//  Galaga 2
//
//  Created by Jack Hamilton on 6/26/17.
//  Copyright © 2017 Jack Hamilton. All rights reserved.
//

import Foundation
import SpriteKit
import SceneKit

class PlayerWeapon: Weapon {
    
    override var fireRate: Int {
        get {
            return 4
        }
    }
    override var bulletFile: String {
        get {
            return "Bullet1.sks"
        }
    }
    override var bulletName: String {
        get {
            return "bullet"
        }
    }
    //When fired, which speed to go (sign signifies direction)
    override var impulse: CGVector {
        get {
            return CGVector(dx: 0, dy: 0.3)
        }
    }
    
    override var categoryMask: UInt32 {
        get {
            return 2
        }
    }
    
    override var contactTestMask: UInt32 {
        get {
            return 1
        }
    }
    
}
