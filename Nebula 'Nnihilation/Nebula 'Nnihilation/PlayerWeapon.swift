//
//  PlayerWeapon.swift
//  Nebula 'Nnihilation
//
//  Created by Jack Hamilton on 7/15/17.
//  Copyright © 2017 App Camp. All rights reserved.
//

import Foundation
import SpriteKit

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
