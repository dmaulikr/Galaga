//
//  PlayerWeapon.swift
//  Nebula 'Nnihilation
//
//  Created by Jack Hamilton on 7/15/17.
//  Copyright © 2017 App Camp. All rights reserved.
//

import Foundation
import SpriteKit

protocol Weapon {
    
    var damage: Int { get }
    var force: Double { get }
    var fireRate: Int { get }
    var filename: String { get }
    var bulletName: String { get }
    var categoryMask: Int { get }
    var contactMask: Int { get }
    var position: CGPoint { get }
    
}

class PlayerWeapon: Weapon {
    
    var damage = 3
    var force = 0.3
    var fireRate = 6
    var filename = "PlayerBullet"
    var bulletName = "PlayerBullet"
    var categoryMask = 1
    var contactMask = 0
    var position = CGPoint(x: 0, y: 0)
    
}
