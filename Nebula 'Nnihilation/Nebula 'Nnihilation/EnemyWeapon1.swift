//
//  PlayerWeapon.swift
//  Nebula 'Nnihilation
//
//  Created by Jack Hamilton on 7/15/17.
//  Copyright © 2017 App Camp. All rights reserved.
//

import Foundation
import SpriteKit

class EnemyWeapon1: Weapon {
    
    var damage = 3
    var force = -0.15
    var fireRate = 30
    var filename = "CannonBullet"
    var bulletName = "EnemyBullet"
    var categoryMask = 1
    var contactMask = 1
    var position = CGPoint(x: 0, y: 0)
    
}
